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
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.blueMain,
        title: const Text(
          'Result Train',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppConstants.kSpacingItem24,
          const Text(
            'Result Train',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppConstants.kSpacingItem24,
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(widget.data[index].name.toString()),
                    subtitle: Column(
                      children: [
                        Text(
                          widget.data[index].acc.toString(),
                        ),
                        Text(
                          widget.data[index].pre.toString(),
                        ),
                        Text(
                          widget.data[index].recall.toString(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonButton(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                btnText: "Train Page",
                onPress: () {
                  Navigator.pop(context);
                },
                sizeType: SizeType.large,
                backgroundColor: AppColors.blueMain,
                btnTextColorEnable: AppColors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
