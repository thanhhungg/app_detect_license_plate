import 'dart:ui';

import 'package:detect_license_plate_app/config/constants/app_colors.dart';
import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/controller/train_model/train_model_cubit.dart';
import 'package:detect_license_plate_app/views/page/manage/manage_create.dart';
import 'package:detect_license_plate_app/views/page/train/result_train.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/manage/manage_cubit.dart';
import '../../common/common_button.dart';

class TrainPage extends StatefulWidget {
  const TrainPage({super.key});

  @override
  State<TrainPage> createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  late ManageCubit manageCubit;

  ValueNotifier<List<int>> choose = ValueNotifier([]);
  ValueNotifier<bool> isCheck = ValueNotifier(false);
  late TrainModelCubit trainModelCubit;

  @override
  void initState() {
    manageCubit = ManageCubit();
    manageCubit.getManageListSample();
    trainModelCubit = TrainModelCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: manageCubit,
        ),
        BlocProvider.value(
          value: trainModelCubit,
        ),
      ],
      child: BlocListener<TrainModelCubit, TrainModelState>(
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
                          "Training...",
                          style: TextStyle(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
              success: (data) {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultTrainPage(data: data),
                  ),
                );
              },
              error: (error) {});
        },
        child: Scaffold(
          backgroundColor: AppColors.gray49E,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.blueMain,
            automaticallyImplyLeading: false,
            title: const Text(
              'Train Model',
              style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          body: BlocBuilder<ManageCubit, ManageState>(
            builder: (context, state) {
              print("hhhhh");
              return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () =>
                      const Center(child: CupertinoActivityIndicator()),
                  success: (data) {
                    print(data.length);
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          AppConstants.kSpacingItem16,
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ListTile(
                                            leading: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Image.network(
                                                data[index]
                                                    .imagePath
                                                    .toString(),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            title: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data[index]
                                                          .name
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .lightGray900,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "Number of License Plate: ${data[index].licensePlate!.length.toString()} ",
                                                      style: const TextStyle(
                                                        color:
                                                            AppColors.blueMain,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                ValueListenableBuilder(
                                                  valueListenable: isCheck,
                                                  builder:
                                                      (context, _, child) =>
                                                          Checkbox(
                                                    value: choose.value
                                                        .contains(
                                                            data[index].id),
                                                    onChanged: (value) {
                                                      if (choose.value.contains(
                                                          data[index].id)) {
                                                        isCheck.value =
                                                            !isCheck.value;
                                                        choose.value.remove(
                                                            (data[index].id));
                                                      } else {
                                                        choose.value.add(
                                                            data[index]
                                                                .id!
                                                                .toInt());
                                                        isCheck.value =
                                                            !isCheck.value;
                                                      }
                                                      print(
                                                          "choose: ${choose.value}");
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: SizedBox(
                                              width: 100,
                                              height: 50,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: data[index]
                                                      .licensePlate!
                                                      .length,
                                                  itemBuilder:
                                                      (context, subIndex) {
                                                    return Container(
                                                      width: 100,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColors
                                                                .black2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "xMin: ${data[index].licensePlate![subIndex].xMin.toString()}",
                                                                style: const TextStyle(
                                                                    color: AppColors
                                                                        .lightGray900,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              AppConstants
                                                                  .kSpacingItemW16,
                                                              Text(
                                                                "yMin: ${data[index].licensePlate![subIndex].yMin.toString()}",
                                                                style: const TextStyle(
                                                                    color: AppColors
                                                                        .lightGray900,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "xMax: ${data[index].licensePlate![subIndex].xMax.toString()}",
                                                                style: const TextStyle(
                                                                    color: AppColors
                                                                        .lightGray900,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              AppConstants
                                                                  .kSpacingItemW16,
                                                              Text(
                                                                "yMax: ${data[index].licensePlate![subIndex].yMax.toString()}",
                                                                style: const TextStyle(
                                                                    color: AppColors
                                                                        .lightGray900,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AppConstants.kSpacingItem16,
                                  ],
                                );
                              },
                            ),
                          ),
                          CommonButton(
                            minWidth: MediaQuery.of(context).size.width * 0.5,
                            btnText: "Training model",
                            onPress: () {
                              trainModelCubit.trainModel(choose.value);
                            },
                            sizeType: SizeType.large,
                            backgroundColor: AppColors.blueMain,
                            btnTextColorEnable: AppColors.white,
                          ),
                          AppConstants.kSpacingItem32,
                        ],
                      ),
                    );
                  },
                  error: (error) {
                    print(error);
                    return const SizedBox.shrink();
                  });
            },
          ),
        ),
      ),
    );
  }
}
