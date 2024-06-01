import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/models/model_result_dto.dart';
import 'package:detect_license_plate_app/views/common/common_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/constants/app_colors.dart';
import '../../../controller/train_model/train_model_cubit.dart';

class ResultTrainPage extends StatefulWidget {
  const ResultTrainPage({super.key, required this.data});

  final List<ModelResultDto> data;

  @override
  State<ResultTrainPage> createState() => _ResultTrainPageState();
}

class _ResultTrainPageState extends State<ResultTrainPage> {
  late TrainModelCubit trainModelCubit;

  @override
  void initState() {
    super.initState();
    trainModelCubit = TrainModelCubit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: trainModelCubit,
      child: BlocListener<TrainModelCubit, TrainModelState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            success: (data) {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Delete model success',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
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
              'Result Train',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            const Text(
                              "Model: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(widget.data.last.name.toString()),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Acc: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.data.last.acc.toString(),
                                          style: TextStyle(
                                              color: widget.data.last.acc! > 0.8
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Pre: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.data.last.pre.toString(),
                                          style: TextStyle(
                                              color: widget.data.last.pre! > 0.8
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "F1Score: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.data.last.f1score.toString(),
                                          style: TextStyle(
                                              color: widget.data.last.f1score! >
                                                      0.8
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Delete'),
                                                content: const Text(
                                                    'Are you sure you want to delete this model?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      trainModelCubit
                                                          .deleteModel(widget
                                                              .data.last.id!);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
