import 'package:detect_license_plate_app/services/detect_service.dart';
import 'package:detect_license_plate_app/services/firebase_service.dart';
import 'package:detect_license_plate_app/services/manage_service.dart';
import 'package:detect_license_plate_app/services/train_model_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';
import 'local_service.dart';
import 'services/authentication_service.dart';

final g = GetIt.I;
const baseUrl = 'http://10.0.2.2:8000/';
Future initializeDependencies() async {
  Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  MobileAds.instance.initialize();
  g.registerLazySingleton(() => dio, instanceName: baseUrl);
  GetIt.instance.registerSingleton(DetectServiceImpl());
  GetIt.instance.registerSingleton(ManageServiceImpl());
  GetIt.instance.registerSingleton(AuthenticationRepositoryImpl());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GetIt.instance.registerSingleton(await SharedPreferences.getInstance());
  GetIt.instance.registerSingleton(LocalService());
  GetIt.instance.registerSingleton(TrainModelServiceImpl());
  await FirebaseService.initNotifications();
}
