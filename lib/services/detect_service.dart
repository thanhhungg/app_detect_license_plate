import 'dart:io';

import '../models/model_result_dto.dart';
import '../models/result_detect.dart';
import 'package:dio/dio.dart';

import 'base_api.dart';

abstract class DetectService {
  Future<List<LicensePlateResult>> detectVideo(
      File videoFile, String nameModel);
  Future<List<ModelResultDto>> getModels();
}

class DetectServiceImpl extends BaseApi implements DetectService {
  @override
  Future<List<LicensePlateResult>> detectVideo(
      File videoFile, String nameModel) async {
    try {
      FormData formData = FormData.fromMap({
        'video': await MultipartFile.fromFile(videoFile.path),
      });

      // Gửi POST request với FormData
      final response = await dio.post(
        'detect/video?nameModel=$nameModel',
        data: formData,
      );

      // Xử lý response và trả về kết quả
      if (response.statusCode == 200) {
        List<dynamic> results = response.data['data'];
        return results
            .map((result) => LicensePlateResult.fromJson(result))
            .toList();
      } else {
        throw Exception(
            'Failed to detect license plate. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to detect license plate. Error: $e');
    }
  }

  @override
  Future<List<ModelResultDto>> getModels() async {
    try {
      final response = await dio.get('api/v1/gets_models');
      if (response.statusCode == 200) {
        List<dynamic> results = response.data['data'];
        return results
            .map((result) => ModelResultDto.fromJson(result))
            .toList();
      } else {
        throw Exception(
            'Failed to get model. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get models. Error: $e');
    }
  }
}
