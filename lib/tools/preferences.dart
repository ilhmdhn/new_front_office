import 'package:front_office_2/model/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesData{
  
  Future<bool> setUrl(BaseUrlModel url)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SERVER_URL', url.ip.toString());
    await prefs.setString('SERVER_PORT', url.port.toString());
    return true;
  }

  Future<BaseUrlModel> getUrl()async{
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('SERVER_URL');
    final port = prefs.getString('SERVER_PORT');
    return BaseUrlModel(
      ip: url,
      port: port
    );
  }
}