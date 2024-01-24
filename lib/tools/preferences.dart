import 'package:front_office_2/data/model/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesData{
  
  static Future<bool> setUrl(BaseUrlModel url)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SERVER_URL', url.ip.toString());
    await prefs.setString('SERVER_PORT', url.port.toString());
    return true;
  }

  static Future<BaseUrlModel> getUrl()async{
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('SERVER_URL');
    final port = prefs.getString('SERVER_PORT');
    return BaseUrlModel(
      ip: url,
      port: port
    );
  }

  static Future<String> url()async{
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('SERVER_URL');
    final port = prefs.getString('SERVER_PORT');

    return 'http://$url:$port';
  }

  static Future<BaseUrlModel> setUser()async{
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('USER_ID');
    final port = prefs.getString('USER_LEVEL');
    return BaseUrlModel(
      ip: url,
      port: port
    );
  }
}