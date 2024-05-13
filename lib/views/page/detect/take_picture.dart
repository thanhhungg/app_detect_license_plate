import 'dart:io';

import 'package:camera/camera.dart';
import 'package:detect_license_plate_app/controller/detect/detect_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/constants/app_colors.dart';
import '../../../config/constants/app_constants.dart';
import 'detect_result.dart';

class ShowTakePicture extends StatefulWidget {
  const ShowTakePicture({super.key, required this.imageFile});
  final XFile imageFile;

  @override
  State<ShowTakePicture> createState() => _ShowTakePictureState();
}

class _ShowTakePictureState extends State<ShowTakePicture> {
  late DetectCubit detectCubit;
  @override
  void initState() {
    super.initState();
    detectCubit = DetectCubit();
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
                      ],
                    ),
                  ),
                );
              },
              success: (data) {
                if (data.first.label != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultDetectPage(data: data),
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: "No license plate detected",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              successModel: (dataModel) {},
              error: (e) {
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                    msg: e.toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              });
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.black,
          ),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height - 200,
                width: double.infinity,
                child: Image.file(
                  File(widget.imageFile.path),
                  fit: BoxFit.cover,
                ),
              ),
              // const Spacer(),
              Container(
                width: double.infinity,
                height: 100,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    AppConstants.kSpacingItemW32,
                    TextButton(
                      onPressed: () {
                        detectCubit.detectImage(
                            File(widget.imageFile.path), 'modelbesst');
                      },
                      child: const Text(
                        'Detect',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
