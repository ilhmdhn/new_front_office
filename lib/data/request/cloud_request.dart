import 'dart:convert';

import 'package:front_office_2/tools/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:front_office_2/data/model/base_response.dart';

class CloudRequest{

  static final baseUrl = dotenv.env['server_fo_cloud']!;
  static final token = dotenv.env['fo_cloud_auth']!;

  static Future<BaseResponse> insertLogin()async{
    try{
      final url = Uri.parse('$baseUrl/user-login');
      
      String outlet = PreferencesData.getOutlet();
      String userId = PreferencesData.getUser().userId??'';
      String level = PreferencesData.getUser().level??'';
      String fcmToken = PreferencesData.getFcmToken();
      String device = await PreferencesData.getImei();
      
      final apiResponse = await http.post(url, headers:{
        'Content-Type': 'application/json',
        'authorization': token
      }, body: json.encode({
        'outlet': outlet,
        'user_id': userId,
        'user_level': level,
        'token': fcmToken,
        'device': device
      }));

      final convertedResult = json.decode(apiResponse.body);

      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString()
      ); 
    }
  }

  static Future<BaseResponse> apporvalRequest(String idApproval, String rcp, String notes)async{
    try{
      
      String outlet = PreferencesData.getOutlet();
      String userId = PreferencesData.getUser().userId??'';

      final body = {
      "outlet": outlet,
      "id": idApproval,
      "user": userId,
      "reception": rcp,
      "note": notes
      };

      final url = Uri.parse('$baseUrl/approval/request');
      final apiResponse = await http.post(url, 
      headers:{'Content-Type': 'application/json',
              'authorization': token},
      body: json.encode(body)
      );
      
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString()
      ); 
    }
  }

}