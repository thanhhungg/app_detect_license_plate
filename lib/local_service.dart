import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  final String kKeyUser = 'key_user';

  //NOTE: List key not delete when user logout
  final List<String> keyExcludes = [];

  final SharedPreferences sharedPreferences = GetIt.instance.get();

  String? getUser() {
    return sharedPreferences.getString(kKeyUser);
  }

  Future setUser(String user) {
    return sharedPreferences.setString(kKeyUser, user);
  }
}
