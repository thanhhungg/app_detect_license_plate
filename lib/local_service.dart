import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  final String kKeyUser = 'key_user';
  final String kKeyFCMToken = 'key_fcm_token';
  final String kKeyAvatar = 'key_avatar';
  //NOTE: List key not delete when user logout
  final List<String> keyExcludes = [];

  final SharedPreferences sharedPreferences = GetIt.instance.get();

  String? getUser() {
    return sharedPreferences.getString(kKeyUser);
  }

  Future setUser(String user) {
    return sharedPreferences.setString(kKeyUser, user);
  }

  String? getAvatar() {
    return sharedPreferences.getString(kKeyAvatar);
  }

  Future setAvatar(String avatar) {
    return sharedPreferences.setString(kKeyAvatar, avatar);
  }

  String? getFcmToken() {
    return sharedPreferences.getString(kKeyFCMToken);
  }

  Future setFcmToken(String token) {
    return sharedPreferences.setString(kKeyFCMToken, token);
  }
}
