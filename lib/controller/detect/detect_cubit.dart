import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:detect_license_plate_app/services/detect_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

import '../../models/model_result_dto.dart';
import '../../models/result_detect.dart';

part 'detect_state.dart';
part 'detect_cubit.freezed.dart';

class DetectCubit extends Cubit<DetectState> {
  DetectCubit() : super(const DetectState.initial());

  DetectServiceImpl detectServiceImpl = GetIt.instance.get<DetectServiceImpl>();

  Future<void> detectVideo(File videoFile, String selectedValue) async {
    emit(const DetectState.loading());
    try {
      final data =
          await detectServiceImpl.detectVideo(videoFile, selectedValue);
      emit(DetectState.success(data));
    } catch (e) {
      emit(DetectState.error(e));
    }
  }

  Future<void> getModels() async {
    try {
      final data = await detectServiceImpl.getModels();
      emit(DetectState.successModel(data));
    } catch (e) {
      emit(DetectState.error(e));
    }
  }
}
