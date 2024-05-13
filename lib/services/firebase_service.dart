import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';

import '../local_service.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message ${message.notification?.body}');
  print('Message data: ${message.notification?.title}');
  print('Message data: ${message.data}');
}

class FirebaseService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMtoken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMtoken');
    if (fCMtoken != null) {
      GetIt.instance.get<LocalService>().setFcmToken(fCMtoken);
    }
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }
}
