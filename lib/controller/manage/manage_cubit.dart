import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:detect_license_plate_app/models/sample_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

import '../../services/manage_service.dart';

part 'manage_state.dart';
part 'manage_cubit.freezed.dart';

class ManageCubit extends Cubit<ManageState> {
  ManageServiceImpl manageService = GetIt.instance.get<ManageServiceImpl>();
  ManageCubit() : super(const ManageState.initial());
  Future getManageListSample() async {
    emit(const ManageState.loading());
    try {
      final data = await manageService.getManageListSample();
      emit(ManageState.success(data));
    } catch (e) {
      emit(ManageState.error(e));
    }
  }

  Future manageDelete(int id) async {
    emit(const ManageState.loading());
    try {
      final data = await manageService.manageDelete(id);
      emit(ManageState.success(data));
    } catch (e) {
      emit(ManageState.error(e));
    }
  }

  Future manageCreate(
    File imageFile,
    List<Map<String, double>> coordinates,
  ) async {
    emit(const ManageState.loading());
    try {
      final data = await manageService.manageCreate(imageFile, coordinates);
      emit(ManageState.success(data));
    } catch (e) {
      emit(ManageState.error(e));
    }
  }
}