import 'dart:convert';
import 'dart:io';

import '../models/model_result_dto.dart';
import '../models/result_detect.dart';
import 'package:dio/dio.dart';

import 'base_api.dart';

abstract class TrainModelService {
  Future<List<ModelResultDto>> trainModel(List<String> imageNames);
}

class TrainModelServiceImpl extends BaseApi implements TrainModelService {
  @override
  Future<List<ModelResultDto>> trainModel(List<String> imageNames) async {
    try {
      print('Train model with images: $imageNames');

      var data = json.encode({
        "names": imageNames,
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
}
