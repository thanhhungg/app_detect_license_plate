import 'package:camera/camera.dart';
import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/views/page/detect/take_picture.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraDetectPage extends StatefulWidget {
  const CameraDetectPage({
    super.key,
    required this.cameras,
  });
  final List<CameraDescription> cameras;
  @override
  State<CameraDetectPage> createState() => _CameraDetectPageState();
}

class _CameraDetectPageState extends State<CameraDetectPage> {
  late CameraController controller;
  bool isFlashOn = false;
  late XFile? imageFile;
  final picker = ImagePicker();
  late XFile pickedFiles;
  @override
  void initState() {
    super.initState();
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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized || controller == null) {
      return Scaffold();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black.withOpacity(0.3),
        title: const Text(
          'Camera Detect',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          CameraPreview(controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      if (controller.value.isInitialized) {
                        await controller.setFlashMode(
                            isFlashOn ? FlashMode.off : FlashMode.torch);
                      }
                      setState(() {
                        isFlashOn = !isFlashOn;
                      });
                    },
                    icon: Icon(
                      isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  AppConstants.kSpacingItemW8,
                  IconButton(
                    onPressed: () {
                      controller.takePicture().then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShowTakePicture(imageFile: value),
                          ),
                        );
                      });
                    },
                    icon: const Icon(
                      Icons.radio_button_on_outlined,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                  AppConstants.kSpacingItemW8,
                  IconButton(
                    onPressed: () {
                      getImageFromGallery();
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 32,
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

  Future getImageFromGallery() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedFiles = image;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowTakePicture(imageFile: pickedFiles),
        ),
      );
    }
  }
}
