import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/models/model_result_dto.dart';
import 'package:detect_license_plate_app/views/common/common_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../config/constants/app_colors.dart';

class ResultTrainPage extends StatefulWidget {
  const ResultTrainPage({super.key, required this.data});
  final List<ModelResultDto> data;
  @override
  State<ResultTrainPage> createState() => _ResultTrainPageState();
}

class _ResultTrainPageState extends State<ResultTrainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.blueMain,
        title: const Text(
          'Result Train',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              const Text(
                                "Tên model: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(widget.data[index].name.toString()),
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Acc: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.data[index].acc.toString(),
                                    style: TextStyle(
                                        color: widget.data[index].acc! > 0.8
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Pre: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.data[index].pre.toString(),
                                    style: TextStyle(
                                        color: widget.data[index].pre! > 0.8
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "F1Score: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.data[index].f1score.toString(),
                                    style: TextStyle(
                                        color: widget.data[index].f1score! > 0.8
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
