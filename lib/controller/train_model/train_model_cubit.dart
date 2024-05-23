import 'package:bloc/bloc.dart';
import 'package:detect_license_plate_app/services/train_model_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

import '../../models/model_result_dto.dart';
part 'train_model_state.dart';
part 'train_model_cubit.freezed.dart';

class TrainModelCubit extends Cubit<TrainModelState> {
  TrainModelCubit() : super(const TrainModelState.initial());
  TrainModelServiceImpl trainModelService =
      GetIt.instance.get<TrainModelServiceImpl>();
  Future<void> trainModel(List<int> imageNames) async {
    emit(const TrainModelState.loading());
    try {
      final data = await trainModelService.trainModel(imageNames);
      emit(TrainModelState.success(data));
    } catch (e) {
      emit(TrainModelState.error(e));
    }
  }

  Future getAllModel() async {
    emit(const TrainModelState.loading());
    try {
      final data = await trainModelService.getAllModel();
      emit(TrainModelState.success(data));
    } catch (e) {
      emit(TrainModelState.error(e));
    }
  }

  Future deleteModel(int id) async {
    emit(const TrainModelState.loading());
    try {
      final data = await trainModelService.deleteModel(id);
      emit(TrainModelState.success(data));
    } catch (e) {
      emit(TrainModelState.error(e));
    }
  }
}
