import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/models/sample_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/constants/app_colors.dart';
import '../../../controller/manage/manage_cubit.dart';
import '../main_page.dart';
import 'manage_page.dart';

class MyPainter extends StatefulWidget {
  const MyPainter({super.key, this.dataSample});
  final SampleDto? dataSample;
  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> {
  List<Map<String, dynamic>> rectangles = [];
  Offset? start;
  Offset? end;
  XFile? image;
  Size? imageSize;
  final ImagePicker _picker = ImagePicker();
  double imageWidth = 0;
  double imageHeight = 0;
  List<Map<String, double>> coordinates = [];
  final TextEditingController _labelController = TextEditingController();

  late ManageCubit manageCubit;
  bool check = false;
  @override
  void initState() {
    manageCubit = ManageCubit();
    if (widget.dataSample != null) {
      for (var rect in widget.dataSample!.licensePlate!) {
        double left = rect.xMin! - rect.xMax! / 2;
        double right = rect.xMin! + rect.xMax! / 2;
        double top = rect.yMin! - rect.yMax! / 2;
        double bottom = rect.yMin! + rect.yMax! / 2;

        RelativeRect relativeRect = RelativeRect.fromLTRB(
          left,
          top,
          right,
          bottom,
        );
        print("${rect.xMin} ${rect.yMin} ${rect.xMax} ${rect.yMax}");
        rectangles.add({
          'rect': relativeRect,
          'label': widget.dataSample!.name!,
        });
      }
      check = true;
    }
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
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                    ),
                  );
                },
              );
            },
            success: (data) {
              Navigator.pop(context);
              Navigator.pop(context, data);
            },
            error: (e) {},
          );
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.white),
            backgroundColor: AppColors.blueMain,
            title: const Text(
              'Draw Rectangle',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  _pickImage();
                },
                icon: const Icon(Icons.image_outlined),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 2,
                child: image == null && widget.dataSample == null
                    ? Container(
                        decoration: BoxDecoration(
                          color: AppColors.gray49E,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 100,
                            color: AppColors.lightGray900,
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          return GestureDetector(
                            onPanStart: (details) {
                              setState(() {
                                start = details.localPosition;
                                imageSize = Size(constraints.maxWidth,
                                    constraints.maxHeight);
                              });
                            },
                            onPanUpdate: (details) {
                              setState(() {
                                end = details.localPosition;
                              });
                            },
                            onPanEnd: (details) async {
                              if (start != null && end != null) {
                                RelativeRect rect = _createRelativeRect(
                                    start!, end!, imageSize!);
                                String? label = await _showLabelDialog(context);
                                if (label != null && label.isNotEmpty) {
                                  setState(() {
                                    rectangles.add({
                                      'rect': rect,
                                      'label': label,
                                    });
                                    start = null;
                                    end = null;
                                  });
                                }
                              }
                            },
                            child: Stack(
                              children: [
                                widget.dataSample == null || image != null
                                    ? Image.file(
                                        File(image!.path),
                                        width: constraints.maxWidth,
                                        height: constraints.maxHeight,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        widget.dataSample!.imagePath.toString(),
                                        width: constraints.maxWidth,
                                        height: constraints.maxHeight,
                                        fit: BoxFit.fill,
                                      ),
                                CustomPaint(
                                  painter: RectanglePainter(
                                      rectangles, start, end, check),
                                  child: Container(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    AppConstants.kSpacingItem16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              rectangles.clear();
                            });
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: rectangles.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> rectData = rectangles[index];
                          RelativeRect rect = rectData['rect'];
                          String label = rectData['label'];
                          String x =
                              ((rect.left + rect.right) / 2).toStringAsFixed(6);
                          String y =
                              ((rect.top + rect.bottom) / 2).toStringAsFixed(6);
                          String w =
                              (rect.right - rect.left).toStringAsFixed(6);
                          String h =
                              (rect.bottom - rect.top).toStringAsFixed(6);

                          return ListTile(
                            title: Text(
                              'Label: $label\nxMin: $x, yMin: $y, xMax: $w, yMax: $h',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blueMain,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    coordinates.clear();
                    for (var rectData in rectangles) {
                      RelativeRect rect = rectData['rect'];
                      double x = ((rect.left + rect.right) / 2).toDouble();
                      double y = ((rect.top + rect.bottom) / 2).toDouble();
                      double w = (rect.right - rect.left).toDouble();
                      double h = (rect.bottom - rect.top).toDouble();
                      coordinates.add({
                        'xMin': x,
                        'yMin': y,
                        'xMax': w,
                        'yMax': h,
                      });
                    }
                    print(coordinates);
                    if (widget.dataSample != null) {
                      if (image != null) {
                        print('update');
                        manageCubit.manageUpdate(
                          widget.dataSample!.id!,
                          rectangles[0]['label'],
                          '',
                          File(image!.path),
                          coordinates,
                        );
                      } else {
                        print('update2');
                        manageCubit.manageUpdate(
                          widget.dataSample!.id!,
                          rectangles[0]['label'],
                          widget.dataSample!.imagePath!,
                          null,
                          coordinates,
                        );
                      }
                    } else {
                      print('update3');
                      manageCubit.manageCreate(
                        rectangles[0]['label'],
                        File(image!.path),
                        coordinates,
                      );
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
              AppConstants.kSpacingItem16,
            ],
          ),
        ),
      ),
    );
  }

  RelativeRect _createRelativeRect(Offset start, Offset end, Size size) {
    double left = start.dx / size.width;
    double top = start.dy / size.height;
    double right = end.dx / size.width;
    double bottom = end.dy / size.height;

    // Ensure left < right and top < bottom
    if (left > right) {
      double temp = left;
      left = right;
      right = temp;
    }
    if (top > bottom) {
      double temp = top;
      top = bottom;
      bottom = temp;
    }

    return RelativeRect.fromLTRB(left, top, right, bottom);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final ui.Image decodedImage = await _loadImage(imageFile);
      setState(() {
        imageWidth = decodedImage.width.toDouble();
        imageHeight = decodedImage.height.toDouble();
        image = pickedFile;
        rectangles.clear();
      });
    }
  }

  Future<ui.Image> _loadImage(File file) async {
    final Completer<ui.Image> completer = Completer();
    final ImageStream stream =
        FileImage(file).resolve(ImageConfiguration.empty);
    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        completer.complete(info.image);
      },
      onError: (dynamic error, StackTrace? stackTrace) {
        completer.completeError(error, stackTrace);
      },
    );
    stream.addListener(listener);
    return completer.future;
  }

  Future<String?> _showLabelDialog(BuildContext context) async {
    _labelController.clear();
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Label'),
        content: TextField(
          controller: _labelController,
          decoration: InputDecoration(hintText: 'Label'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(_labelController.text),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  final List<Map<String, dynamic>> rectangles;
  final Offset? start;
  final Offset? end;
  final bool? check;

  RectanglePainter(this.rectangles, this.start, this.end, this.check);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var rectData in rectangles) {
      RelativeRect rect = rectData['rect'];
      if (check == true) {
        paint.color = Colors.green;
      } else {
        paint.color = Colors.blue;
      }
      canvas.drawRect(
        Rect.fromLTRB(
          rect.left * size.width,
          rect.top * size.height,
          rect.right * size.width,
          rect.bottom * size.height,
        ),
        paint,
      );
    }

    if (start != null && end != null) {
      canvas.drawRect(
        Rect.fromPoints(start!, end!),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
