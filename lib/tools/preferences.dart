import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_office_2/data/model/network.dart';
import 'package:device_information/device_information.dart';

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
    final url = _prefs?.getString('SERVER_URL') ?? '192.168.1.136';
    final port = _prefs?.getString('SERVER_PORT') ?? '3000';
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

  static Future<void> setUser(UserDataModel data, pass) async {
    _prefs?.setString('USER_ID', data.userId!);
    _prefs?.setString('USER_LEVEL', data.level!);
    _prefs?.setString('USER_TOKEN', data.token!);
    _prefs?.setString('USER_PASS', pass);
  }

  static void setBiometricLogin(bool value){
    _prefs?.setBool('BIOMETRIC_LOGIN', value);
  }

  static bool getBiometricLoginState(){
    final state = _prefs?.getBool('BIOMETRIC_LOGIN')??false;
    return state;
  }

  static UserDataModel getUser() {
    final userId = _prefs?.getString('USER_ID') ?? '';
    final level = _prefs?.getString('USER_LEVEL') ?? '';
    final token = _prefs?.getString('USER_TOKEN') ?? '';
    final pass = _prefs?.getString('USER_PASS')??'';
    return UserDataModel(userId: userId, level: level, token: token, pass: pass);
  }

  static void setLoginState(bool value){
    _prefs?.setBool('LOGIN_STATE', value);
  }

  static bool getLoginState(){
    return _prefs?.getBool('LOGIN_STATE')??false;
  }

  static String getUserToken() {
    final token = _prefs?.getString('USER_TOKEN') ?? '';
    return token;
  }

  static Future<void> setFcmToken(String token)async{
    _prefs?.setString('FCM_TOKEN', token);
  }

  static String getFcmToken(){
    return _prefs?.getString('FCM_TOKEN')??'';
  }

  static Future<String> getImei()async{
    try{
      return await DeviceInformation.deviceIMEINumber;
    }catch(e){
      showToastError(e.toString());
      return 'error $e';
    }
  }

  static void setPrinter(PrinterModel printer){
    _prefs?.setString('PRINTER_NAME', printer.name);
    _prefs?.setString('PRINTER_CONNECTION', printer.connection);
    _prefs?.setString('PRINTER_TYPE', printer.type);
    _prefs?.setString('PRINTER_ADDRESS', printer.address);
  }

  static PrinterModel getPrinter(){
    return PrinterModel(
      name: _prefs?.getString('PRINTER_NAME')??'', 
      connection: _prefs?.getString('PRINTER_CONNECTION')??'', 
      type: _prefs?.getString('PRINTER_TYPE')??'', 
      address: _prefs?.getString('PRINTER_ADDRESS')??'');
  }

  static void setShowRetur(bool state){
    _prefs?.setBool('SHOW_RETUR', state);
  }

  static bool getShowReturState(){
    return _prefs?.getBool('SHOW_RETUR')??false;
  }

  static void setShowTotalItemPromo(bool state) {
    _prefs?.setBool('SHOW_TOTAL_PROMO_ITEM', state);
  }

  static bool getShowTotalItemPromo() {
    return _prefs?.getBool('SHOW_TOTAL_PROMO_ITEM') ?? false;
  }

  static void setShowPromoBelowItem(bool state) {
    _prefs?.setBool('SHOW_PROMO_BELOW_ITEM', state);
  }

  static bool getShowPromoBelowItem() {
    return _prefs?.getBool('SHOW_PROMO_BELOW_ITEM') ?? false;
  }
}