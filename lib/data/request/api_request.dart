import 'dart:convert';
import 'package:front_office_2/data/model/cek_member_response.dart';
import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:http/http.dart' as http;

class ApiRequest{
  Future<LoginResponse> loginFO(String userId, String password)async{
    try {
      final serverUrl = await PreferencesData.url();
      final url = Uri.parse('$serverUrl/login-fo-droid');
      final apiResponse = await http.post(url, body: {
        'user_id': userId,
        'user_paddword': password
      });
      // if(apiResponse.statusCode == 401) throw 'invalid token';
      final convertedResult = json.decode(apiResponse.body);
      return LoginResponse.fromJson(convertedResult);
    } catch (e) {
      return LoginResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  Future<CekMemberResponse> cekMember(String memberCode)async{
    try{
      final serverUrl = await PreferencesData.url();
      // final url = Uri.parse('$serverUrl/member/membership/$memberCode');
      final url = Uri.parse('http://192.168.1.136:3000/member/membership/$memberCode');
      final apiResponse = await http.get(url);
      final convertedResult = json.decode(apiResponse.body);

      return CekMemberResponse.fromJson(convertedResult);
    }catch(e){
      return CekMemberResponse(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }  
}