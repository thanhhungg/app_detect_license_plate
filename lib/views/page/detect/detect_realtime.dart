import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/config/constants/app_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../config/constants/app_colors.dart';
import '../../../models/result_detect.dart';

class DetectRealtime extends StatefulWidget {
  const DetectRealtime({super.key, required this.cameras});
  final List<CameraDescription> cameras;
  @override
  State<DetectRealtime> createState() => _DetectRealtimeState();
}

class _DetectRealtimeState extends State<DetectRealtime> {
  late CameraController controller;
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse(AppString.baseUrlWs),
  );
  CameraController? _cameraController;
  Uint8List? _imageData;
  Timer? _timer;
  late List<LicensePlateResult> data = [];
  ValueNotifier<bool> isDetecting = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    _initializeCamera();
    channel.stream.listen((dataWs) {
      final decodedData = jsonDecode(dataWs);
      print(dataWs);
      if (decodedData['data'].length > 0) {
        List<LicensePlateResult> tmp = List<LicensePlateResult>.from(
          decodedData['data'].map(
            (x) => LicensePlateResult.fromJson(x),
          ),
        );
        setState(
          () {
            print("hahsdh");
            data.insertAll(0, tmp);
          },
        );
      }
    });
  }

  Future<void> _initializeCamera() async {
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          ValueListenableBuilder(
            valueListenable: isDetecting,
            builder: (context, value, child) {
              return IconButton(
                onPressed: () {
                  if (!isDetecting.value) {
                    _timer = Timer.periodic(const Duration(microseconds: 500),
                        (timer) {
                      toTakePhoto();
                    });
                  } else {
                    _timer?.cancel();
                  }
                  isDetecting.value = !isDetecting.value;
                },
                icon: Icon(
                  isDetecting.value
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline_sharp,
                  color: isDetecting.value ? Colors.red : Colors.white,
                ),
              );
            },
          )
        ],
        iconTheme: const IconThemeData(color: AppColors.white),
        centerTitle: true,
        backgroundColor: AppColors.blueMain,
        title: const Text(
          'Detect Realtime',
          style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          CameraPreview(controller),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Text(
                    DateFormat('dd/MM/yyyy hh:mm:ss').format(
                      DateTime.now(),
                    ),
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 300,
              color: Colors.black.withOpacity(0.3),
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: InteractiveViewer(
                                      panEnabled: true, // Cho phép kéo

                                      maxScale: 3, // Tỷ lệ phóng to tối đa
                                      child: Image.network(
                                        data[index].frame.toString(),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 8,
                            ),
                            child: ListTile(
                              leading: SizedBox(
                                child: Image.network(
                                  data[index].frame.toString(),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        'License Plate:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.blueMain),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  Text(
                                    data[index].label.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppColors.blueMain),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Confidence: ${data[index].confidence?.toStringAsFixed(6)}'),
                                  Text('Time: ${data[index].timestamp}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  toTakePhoto() async {
    try {
      final image = await controller.takePicture();
      final imageData = await image.readAsBytes();
      final base64Image = base64Encode(imageData);
      channel.sink.add(base64Image);
    } catch (e) {
      print("Error taking photo: $e");
    }
  }
}
