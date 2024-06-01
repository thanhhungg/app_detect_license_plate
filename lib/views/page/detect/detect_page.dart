import 'dart:io';

import 'package:camera/camera.dart';
import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/controller/detect/detect_cubit.dart';
import 'package:detect_license_plate_app/views/common/common_button.dart';
import 'package:detect_license_plate_app/views/page/detect/detect_result.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/constants/app_colors.dart';
import '../../../models/model_result_dto.dart';
import 'detect_realtime.dart';

class DetectPage extends StatefulWidget {
  const DetectPage({super.key});

  @override
  State<DetectPage> createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  final picker = ImagePicker();
  late XFile pickedFiles = XFile('path');
  ValueNotifier<bool> isImageSelected = ValueNotifier(false);
  late VideoPlayerController _controller;
  late DetectCubit detectCubit;
  late List<ModelResultDto> models = [];
  late ModelResultDto selectedValue = ModelResultDto(name: 'Select model');
  late List<CameraDescription> cameras;
  @override
  void initState() {
    _controller = VideoPlayerController.file(File(pickedFiles.path))
      ..initialize().then((_) {
        setState(() {});
      });
    detectCubit = DetectCubit();
    detectCubit.getModels();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: detectCubit,
      child: BlocListener<DetectCubit, DetectState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {
              showDialog(
                context: context,
                builder: (context) => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Detecting...",
                        style: TextStyle(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
            success: (data) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultDetectPage(
                    data: data,
                  ),
                ),
              );
            },
            successModel: (data) {
              models.addAll(data);
              setState(() {
                selectedValue = findModelWithMaxAccuracy(models);
              });
            },
            error: (e) {},
          );
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.blueMain,
            automaticallyImplyLeading: false,
            title: const Text(
              'Detect',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  cameras = await availableCameras();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DetectRealtime(cameras: cameras);
                      },
                    ),
                  );
                },
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Select model',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  dropDownButtonCustom(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ValueListenableBuilder(
                  valueListenable: isImageSelected,
                  builder: (context, value, child) {
                    return !value
                        ? InkWell(
                            onTap: () {
                              isImageSelected.value = false;
                              getImageFromGallery();
                            },
                            child: Container(
                                height: 343,
                                decoration: BoxDecoration(
                                  color: AppColors.gray49E,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.blueMain,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.video_call_rounded,
                                    size: 100,
                                    color: AppColors.lightGray900,
                                  ),
                                )),
                          )
                        : Stack(
                            children: [
                              Container(
                                height: 343,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: _controller.value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio:
                                            _controller.value.aspectRatio,
                                        child: VideoPlayer(_controller),
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: InkWell(
                                  onTap: () {
                                    isImageSelected.value = true;
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );

                    // Remove the unnecessary semicolon
                  },
                ),
              ),
              AppConstants.kSpacingItem16,
              CommonButton(
                minWidth: MediaQuery.of(context).size.width * 0.5,
                btnText: "Detect",
                onPress: () {
                  if (pickedFiles.path == 'path') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a video'),
                      ),
                    );
                  } else {
                    detectCubit.detectVideo(
                        File(pickedFiles.path), selectedValue.name.toString());
                  }
                },
                sizeType: SizeType.large,
                backgroundColor: AppColors.blueMain,
                btnTextColorEnable: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center dropDownButtonCustom() {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<ModelResultDto>(
          isExpanded: true,
          hint: const Row(
            children: [
              Icon(
                Icons.list,
                size: 16,
                color: Colors.black,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  'Select model',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: models
              .map((ModelResultDto item) => DropdownMenuItem<ModelResultDto>(
                    value: item,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Acc: ${item.acc}',
                          style: TextStyle(
                            fontSize: 12,
                            color: item.acc!.toDouble() < 0.8
                                ? Colors.red
                                : Colors.green,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (ModelResultDto? value) {
            setState(() {
              selectedValue = value!;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 160,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.white,
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 14,
            iconEnabledColor: Colors.white,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }

  Future getImageFromGallery() async {
    XFile? image = await picker.pickVideo(source: ImageSource.gallery);
    if (image != null) {
      pickedFiles = image;
      _controller = VideoPlayerController.file(File(pickedFiles.path))
        ..initialize().then((_) {
          setState(() {});
        });
      isImageSelected.value = !isImageSelected.value;
    }
  }

  ModelResultDto findModelWithMaxAccuracy(List<ModelResultDto> models) {
    ModelResultDto? maxModel;
    double? maxAccuracy = double.negativeInfinity;

    for (var model in models) {
      if (model.acc! > maxAccuracy!) {
        maxAccuracy = model.acc;
        maxModel = model;
      }
    }

    return maxModel!;
  }
}
