import 'dart:ffi';
import 'dart:io';
import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/controller/manage/manage_cubit.dart';
import 'package:detect_license_plate_app/models/sample_dto.dart';
import 'package:detect_license_plate_app/views/common/common_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../config/constants/app_colors.dart';
import '../main_page.dart';

class ManageCreatePage extends StatefulWidget {
  const ManageCreatePage({
    super.key,
  });

  @override
  State<ManageCreatePage> createState() => _ManageCreatePageState();
}

class _ManageCreatePageState extends State<ManageCreatePage> {
  final picker = ImagePicker();
  late XFile pickedFiles;
  ValueNotifier<bool> isImageSelected = ValueNotifier(false);
  List<Map<String, double>> coordinates = [];
  Map<String, double> tmp = {};
  ValueNotifier<bool> isCheckAdd = ValueNotifier(false);
  int count = 1;

  late ManageCubit manageCubit;
  @override
  void initState() {
    manageCubit = ManageCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: manageCubit,
      child: BlocListener<ManageCubit, ManageState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Loading...'),
                  duration: Duration(microseconds: 1500),
                ),
              );
            },
            success: (data) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            },
            error: (e) {},
          );
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.white),
            backgroundColor: AppColors.blueMain,
            title: const Text(
              'Manage Create',
              style: TextStyle(color: AppColors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppConstants.kSpacingItem16,
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ValueListenableBuilder(
                    valueListenable: isImageSelected,
                    builder: (context, value, child) {
                      return InkWell(
                        onTap: () {
                          isImageSelected.value = false;
                          getImageFromGallery();
                        },
                        child: Container(
                          height: 343,
                          decoration: BoxDecoration(
                            image: value
                                ? DecorationImage(
                                    image: FileImage(
                                      File(pickedFiles.path),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: AppColors.gray49E,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: !value
                              ? const Center(
                                  child: Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 100,
                                    color: AppColors.lightGray900,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (tmp.isNotEmpty) {
                            coordinates.add(tmp);
                            count++;
                            isCheckAdd.value = !isCheckAdd.value;
                            tmp = {};
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please fill in the coordinates!'),
                                duration: Duration(microseconds: 1500),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.add_circle,
                          size: 24,
                        ),
                        color: AppColors.blueMain,
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (count > 1) {
                            tmp = coordinates.last;
                            coordinates.removeLast();
                            count--;
                            isCheckAdd.value = !isCheckAdd.value;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No coordinates to delete!'),
                                duration: Duration(microseconds: 1500),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.remove_circle, size: 24),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: isCheckAdd,
                  builder: (context, value, child) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: count,
                    itemBuilder: (context, index) {
                      return CoordinateWidget(
                        tmp: tmp,
                        coordinates: coordinates,
                      );
                    },
                  ),
                ),
                AppConstants.kSpacingItem24,
                CommonButton(
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  btnText: "Create",
                  onPress: () {
                    if (tmp.isNotEmpty) {
                      coordinates.add(tmp);
                      tmp = {};
                    }
                    manageCubit.manageCreate(
                      File(pickedFiles.path),
                      coordinates,
                    );
                  },
                  sizeType: SizeType.large,
                  backgroundColor: AppColors.blueMain,
                  btnTextColorEnable: AppColors.white,
                ),
                AppConstants.kSpacingItem85,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImageFromGallery() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedFiles = image;
      isImageSelected.value = !isImageSelected.value;
    }
  }
}

class CoordinateWidget extends StatelessWidget {
  CoordinateWidget({
    super.key,
    this.tmp,
    this.coordinates,
  });

  late Map<String, double>? tmp = {};
  late List<Map<String, double>>? coordinates = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            String tmps = '';
            switch (index) {
              case 0:
                tmps = 'xMin';
                break;
              case 1:
                tmps = 'yMin';
                break;
              case 2:
                tmps = 'xMax';
                break;
              case 3:
                tmps = 'yMax';
                break;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 70,
                    height: 30,
                    child: TextField(
                      onChanged: (value) {
                        tmp?.addAll({tmps: double.parse(value)});
                      },
                      decoration: InputDecoration(
                        label: Text(tmps),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
