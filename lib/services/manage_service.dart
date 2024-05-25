import 'dart:convert';
import 'dart:io';

import 'package:detect_license_plate_app/services/base_api.dart';
import 'package:dio/dio.dart';
import '../models/sample_dto.dart';

abstract class ManageService {
  Future<List<SampleDto>> manageDelete(int id);
  Future<List<SampleDto>> manageCreate(
    String label,
    File imageFile,
    List<Map<String, double>> coordinates,
  );
  Future<List<SampleDto>> manageUpdate(
    int id,
    String label,
    String imagePath,
    File imageFile,
    List<Map<String, double>> coordinates,
  );
  Future<List<SampleDto>> getManageListSample();
}

class ManageServiceImpl extends BaseApi implements ManageService {
  @override
  Future<List<SampleDto>> getManageListSample() async {
    final response = await dio.get('api/v1/getAllManageSample');
    if (response.statusCode == 200) {
      List<dynamic> results = response.data['data'];
      return results.map((result) => SampleDto.fromJson(result)).toList();
    } else {
      throw Exception(
          'Failed to get manage list sample. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<SampleDto>> manageCreate(
    String label,
    File imageFile,
    List<Map<String, double>> coordinates,
  ) async {
    final Map<String, List<Map<String, double>>> data = {
      "coordinates": coordinates
    };
    FormData formData = FormData.fromMap(
      {
        'image': await MultipartFile.fromFile(imageFile.path),
        'coordinate_list': jsonEncode(data),
      },
    );
    print('formData: $formData');
    final response =
        await dio.post('api/v1/create_sample?label=$label', data: formData);

    if (response.statusCode == 200) {
      List<dynamic> results = response.data['data'];
      return results.map((result) => SampleDto.fromJson(result)).toList();
    } else {
      throw Exception(
          'Failed to create sample. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<SampleDto>> manageUpdate(
    int id,
    String label,
    String? imagePath,
    File? imageFile,
    List<Map<String, double>> coordinates,
  ) async {
    final Map<String, List<Map<String, double>>> data = {
      "coordinates": coordinates
    };
    FormData formData;
    if (imageFile == null) {
      formData = FormData.fromMap(
        {
          'sampleId': id,
          'label': label,
          'coordinate_list': jsonEncode(data),
          'imagePath': imagePath,
        },
      );
    } else {
      formData = FormData.fromMap(
        {
          'sampleId': id,
          'label': label,
          'coordinate_list': jsonEncode(data),
          'imagePath': imagePath,
          'imageFile': await MultipartFile.fromFile(imageFile.path),
        },
      );
    }

    final response = await dio.post('api/v1/update_sample', data: formData);

    if (response.statusCode == 200) {
      List<dynamic> results = response.data['data'];
      return results.map((result) => SampleDto.fromJson(result)).toList();
    } else {
      throw Exception(
          'Failed to create sample. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<SampleDto>> manageDelete(int id) async {
    final response = await dio.delete('api/v1/delete_sample/$id');
    if (response.statusCode == 200) {
      List<dynamic> results = response.data['data'];
      return results.map((result) => SampleDto.fromJson(result)).toList();
    } else {
      throw Exception(
          'Failed to delete sample. Status code: ${response.statusCode}');
    }
  }
}
