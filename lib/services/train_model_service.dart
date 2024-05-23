import 'dart:convert';

import 'package:detect_license_plate_app/local_service.dart';
import 'package:get_it/get_it.dart';

import '../models/model_result_dto.dart';

import 'base_api.dart';

abstract class TrainModelService {
  Future<List<ModelResultDto>> trainModel(List<int> listIdSample);
  Future<List<ModelResultDto>> getAllModel();
  Future<List<ModelResultDto>> deleteModel(int id);
}

class TrainModelServiceImpl extends BaseApi implements TrainModelService {
  @override
  Future<List<ModelResultDto>> trainModel(List<int> listIdSample) async {
    try {
      print('Train model with images: $listIdSample');

      var data = json.encode({
        "listId": listIdSample,
        "token": GetIt.instance.get<LocalService>().getFcmToken(),
      });

      // Gửi POST request với FormData
      final response = await dio.post(
        'api/v1/training_model',
        data: data,
      );

      // Xử lý response và trả về kết quả
      if (response.statusCode == 200) {
        List<dynamic> results = response.data['data'];
        return results
            .map((result) => ModelResultDto.fromJson(result))
            .toList();
      } else {
        throw Exception(
            'Failed to train model. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to train model. Error: $e');
    }
  }

  @override
  Future<List<ModelResultDto>> getAllModel() async {
    try {
      // Gửi POST request với FormData
      final response = await dio.get(
        'api/v1/gets_models',
      );

      // Xử lý response và trả về kết quả
      if (response.statusCode == 200) {
        List<dynamic> results = response.data['data'];
        return results
            .map((result) => ModelResultDto.fromJson(result))
            .toList();
      } else {
        throw Exception(
            'Failed to train model. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to train model. Error: $e');
    }
  }

  @override
  Future<List<ModelResultDto>> deleteModel(int id) async {
    try {
      // Gửi POST request với FormData
      final response = await dio.get(
        'api/v1/delete_model/{model_id}?id_model=$id',
      );

      // Xử lý response và trả về kết quả
      if (response.statusCode == 200) {
        List<dynamic> results = response.data['data'];
        return results
            .map((result) => ModelResultDto.fromJson(result))
            .toList();
      } else {
        throw Exception(
            'Failed to train model. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to train model. Error: $e');
    }
  }
}
