import 'dart:io';
import 'dart:typed_data';

import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/models/result_detect.dart';
import 'package:detect_license_plate_app/views/common/common_button.dart';
import 'package:detect_license_plate_app/views/page/main_page.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import '../../../config/constants/app_colors.dart';

class ResultDetectPage extends StatefulWidget {
  final List<LicensePlateResult> data;
  const ResultDetectPage({super.key, required this.data});

  @override
  State<ResultDetectPage> createState() => _ResultDetectPageState();
}

class _ResultDetectPageState extends State<ResultDetectPage> {
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.blueMain,
        title: const Text(
          'Result Detect',
          style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: SizedBox(
                      child: Image.network(
                        widget.data[index].frame.toString(),
                        fit: BoxFit.fill,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'License Plate:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.blueMain),
                            ),
                            const Spacer(),
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  saveGif(widget.data[index].frame.toString());
                                },
                                icon: const Icon(Icons.save_alt_outlined)),
                          ],
                        ),
                        Text(
                          widget.data[index].label.toString(),
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
                        Text('Confidence: ${widget.data[index].confidence}'),
                        Text('Timestamp: ${widget.data[index].timestamp}')
                      ],
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonButton(
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  btnText: "Manage",
                  onPress: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                    );
                  },
                  sizeType: SizeType.large,
                  backgroundColor: AppColors.blueMain,
                  btnTextColorEnable: AppColors.white,
                ),
              ],
            ),
            AppConstants.kSpacingItem16,
          ],
        ),
      ),
    );
  }

  _requestPermission() async {
    bool statuses;
    if (Platform.isAndroid) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;
      statuses =
          sdkInt < 29 ? await Permission.storage.request().isGranted : true;
      // statuses = await Permission.storage.request().isGranted;
    } else {
      statuses = await Permission.photosAddOnly.request().isGranted;
    }
  }

  saveGif(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    String picturesPath = "test_jpg.jpg";
    debugPrint(picturesPath);
    final result = await SaverGallery.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: picturesPath,
      androidRelativePath: "Pictures/appName/DetectLicensePlateApp",
      androidExistNotSave: false,
    );
    debugPrint(result.toString());
    if (result.errorMessage == null) {
      _toastInfo('Save image success');
    } else {
      _toastInfo('Save image fail');
    }
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: info,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
