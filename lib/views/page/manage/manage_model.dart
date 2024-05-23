import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/controller/train_model/train_model_cubit.dart';
import 'package:detect_license_plate_app/models/model_result_dto.dart';
import 'package:detect_license_plate_app/views/common/common_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/constants/app_colors.dart';

class ManageModelPage extends StatefulWidget {
  const ManageModelPage({super.key});

  @override
  State<ManageModelPage> createState() => _ManageModelPageState();
}

class _ManageModelPageState extends State<ManageModelPage> {
  late TrainModelCubit trainModelCubit;

  ValueNotifier<bool> isSearch = ValueNotifier<bool>(false);
  List<ModelResultDto> data = [];
  List<ModelResultDto> tmpData = [];

  @override
  void initState() {
    trainModelCubit = TrainModelCubit();
    trainModelCubit.getAllModel();
    super.initState();
  }

  void search(String value) {
    print('Search value: $value');

    data = tmpData
        .where((element) =>
            element.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    isSearch.value = !isSearch.value; // Notify listeners
  }

  void sortAcc() {
    isSearch.value == true
        ? tmpData.sort((a, b) => b.acc!.compareTo(a.acc!))
        : tmpData.sort((a, b) => a.acc!.compareTo(b.acc!));
    data = List.from(tmpData);
    isSearch.value = !isSearch.value; // Notify listeners
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: trainModelCubit,
      child: BlocConsumer<TrainModelCubit, TrainModelState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return state.when(initial: () {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }, loading: () {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }, success: (dataRp) {
            data = dataRp;

            tmpData = List.from(data);
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                iconTheme: const IconThemeData(color: AppColors.white),
                backgroundColor: AppColors.blueMain,
                title: const Text(
                  'Model Manage',
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      sortAcc();
                    },
                    icon: const Icon(Icons.sort),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        search(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter image name',
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    AppConstants.kSpacingItem16,
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: isSearch,
                        builder: (context, _, __) => ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Row(
                                        children: [
                                          const Text(
                                            "Tên model: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(data[index].name.toString()),
                                        ],
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Acc: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                data[index].acc.toString(),
                                                style: TextStyle(
                                                    color:
                                                        data[index].acc! > 0.8
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                data[index].pre.toString(),
                                                style: TextStyle(
                                                    color:
                                                        data[index].pre! > 0.8
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                data[index].f1score.toString(),
                                                style: TextStyle(
                                                    color:
                                                        data[index].f1score! >
                                                                0.8
                                                            ? Colors.green
                                                            : Colors.red),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Share.share(
                                                  data[index].name.toString());
                                            },
                                            child: const Text(
                                              'Share',
                                              style: TextStyle(
                                                  color: AppColors.blueMain,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text('Delete'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this model?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        trainModelCubit
                                                            .deleteModel(
                                                                data[index]
                                                                    .id!
                                                                    .toInt());
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
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }, error: (e) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                iconTheme: const IconThemeData(color: AppColors.white),
                backgroundColor: AppColors.blueMain,
                title: const Text(
                  'Model Manage',
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              body: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text("Something went wrong"),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

void sharePressed() {
  String message = "Hello";
  Share.share(message);
}
