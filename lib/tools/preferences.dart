import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/data/model/network.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesData {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUrl(BaseUrlModel data) async {
    _prefs?.setString('SERVER_URL', data.ip!);
    _prefs?.setString('SERVER_PORT', data.port!);
  }

  static String getUrl() {
    final url = _prefs?.getString('SERVER_URL') ?? '';
    final port = _prefs?.getString('SERVER_PORT') ?? '';
    return 'http://$url:$port';
  }

  static BaseUrlModel getConfigUrl(){
    return BaseUrlModel(
      ip: _prefs?.getString('SERVER_URL'),
      port: _prefs?.getString('SERVER_PORT')
    );
  }

  static String getOutlet() {
    return _prefs?.getString('OUTLET') ?? 'HP000';
  }

  static void setOutlet(String outletCode) {
    _prefs?.setString('OUTLET', outletCode);
  }

  static Future<void> setUser(UserDataModel data) async {
    _prefs?.setString('USER_ID', data.userId);
    _prefs?.setString('USER_LEVEL', data.level);
    _prefs?.setString('USER_TOKEN', data.token);
    _prefs?.setString('USER_PASS', data.pass);
    _prefs?.setString('OUTLET', data.outlet);
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
    final outlet = _prefs?.getString('OUTLET') ?? '';
    return UserDataModel(userId: userId, level: level, token: token, pass: pass, outlet: outlet);
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

  static Future<String> getImei()async{
    try{  
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    }
    return '';
    }catch(e){
      showToastError(e.toString());
      return 'error $e';
    }
  }

  static void setPrinter(PrinterModel printer){
    final jsonString = jsonEncode(printer.toJson());
    _prefs?.setString('PRINTER_DATA', jsonString);
  }

  static PrinterModel getPrinter(){
    final jsonString = _prefs?.getString('PRINTER_DATA');
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return PrinterModel.fromJson(json);
      } catch (e) {
        return PrinterModel(
          name: '',
          printerModel: PrinterModelType.bluetooth80mm,
          connectionType: PrinterConnectionType.bluetooth,
          address: '',
        );
      }
    }
    // Return default printer if no data
    return PrinterModel(
      name: '',
      printerModel: PrinterModelType.bluetooth80mm,
      connectionType: PrinterConnectionType.bluetooth,
      address: '',
    );
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