import 'package:dio/dio.dart';

import '../config/constants/app_string.dart';
import '../getIt.dart';

class BaseApi {
  static const String baseUrl = AppString.baseUrl;
  final dio = g<Dio>(instanceName: baseUrl);
}
