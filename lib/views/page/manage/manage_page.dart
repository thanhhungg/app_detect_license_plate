import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:detect_license_plate_app/config/constants/app_colors.dart';
import 'package:detect_license_plate_app/config/constants/app_constants.dart';
import 'package:detect_license_plate_app/views/page/manage/manage_create.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/manage/manage_cubit.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  late ManageCubit manageCubit;
  @override
  void initState() {
    manageCubit = ManageCubit();
    manageCubit.getManageListSample();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: manageCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blueMain,
          automaticallyImplyLeading: false,
          title: const Text(
            'Manage',
            style: TextStyle(color: AppColors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageCreatePage()));
                },
                icon: const Icon(
                  Icons.add_circle_outline_sharp,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ManageCubit, ManageState>(
          builder: (context, state) {
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
                        Expanded(
                            child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.gray49E,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data[index]
                                                            .name
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .lightGray900,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "Number of License Plate: ${data[index].licensePlate!.length.toString()} ",
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .blueMain,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  IconButton(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    onPressed: () {
                                                      manageCubit.manageDelete(
                                                          data[index].id!);
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete_forever,
                                                        color: Colors.red),
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
                                                        decoration:
                                                            BoxDecoration(
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
                                                                    .kSpacingItemW8,
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
                                                                    .kSpacingItemW8,
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
                                })),
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
    );
  }
}
