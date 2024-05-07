import 'package:dio/dio.dart';

import '../getIt.dart';

class BaseApi {
  static const String baseUrl = "http://10.0.2.2:8000/";
  final dio = g<Dio>(instanceName: baseUrl);
}
