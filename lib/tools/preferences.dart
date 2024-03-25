import 'package:front_office_2/data/model/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_office_2/data/model/network.dart';

class PreferencesData {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUrl(BaseUrlModel data) async {
    _prefs?.setString('SERVER_URL', data.ip!);
    _prefs?.setString('SERVER_PORT', data.port!);
    _prefs?.setString('OUTLET', data.outlet!);
  }

  static String getUrl() {
    final url = _prefs?.getString('SERVER_URL') ?? '';
    final port = _prefs?.getString('SERVER_PORT') ?? '';
    return 'http://$url:$port';
  }

  static BaseUrlModel getConfigUrl(){
    return BaseUrlModel(
      ip: _prefs?.getString('SERVER_URL'),
      port: _prefs?.getString('SERVER_PORT'),
      outlet: _prefs?.getString('OUTLET'),
    );
  }

  static String getOutlet() {
    return _prefs?.getString('OUTLET') ?? 'HP000';
  }

  static Future<void> setUser(UserDataModel data) async {
    _prefs?.setString('USER_ID', data.userId!);
    _prefs?.setString('USER_LEVEL', data.level!);
    _prefs?.setString('USER_TOKEN', data.token!);
  }

  static UserDataModel getUser() {
    final userId = _prefs?.getString('USER_ID') ?? '';
    final level = _prefs?.getString('USER_LEVEL') ?? '';
    final token = _prefs?.getString('USER_TOKEN') ?? '';
    return UserDataModel(userId: userId, level: level, token: token);
  }
}
