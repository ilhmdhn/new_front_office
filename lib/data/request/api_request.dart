import 'dart:convert';
import 'package:front_office_2/data/model/base_response.dart';
import 'package:front_office_2/data/model/cek_member_response.dart';
import 'package:front_office_2/data/model/checkin_body.dart';
import 'package:front_office_2/data/model/checkin_params.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';
import 'package:front_office_2/data/model/room_checkin_response.dart';
import 'package:front_office_2/data/model/room_list_model.dart';
import 'package:front_office_2/data/model/room_type_model.dart';
import 'package:front_office_2/tools/helper.dart';
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

Future<CekMemberResponse> cekMember(String memberCode) async {
  try {
    final serverUrl = await PreferencesData.url();
    // final url = Uri.parse('$serverUrl/member/membership/$memberCode');
    final url = Uri.parse('http://192.168.1.136:3000/member/membership/$memberCode');
    final apiResponse = await http.get(url);
    final convertedResult = json.decode(apiResponse.body);
    final result = CekMemberResponse.fromJson(convertedResult);
    return result;
  } catch (err) {
    return CekMemberResponse(
      isLoading: false,
      state: false,
      message: 'Terjadi kesalahan saat memproses permintaan: $err',
    );
  }
}


  Future<ListRoomTypeReadyResponse> getListRoomTypeReady()async{
    try{
      final serverUrl = await PreferencesData.url();
      // final url = Uri.parse('$serverUrl/member/membership/$memberCode');
      final url = Uri.parse('http://192.168.1.136:3000/room/all-room-type-ready-grouping');
      final apiResponse = await http.get(url);
      final convertedResult = json.decode(apiResponse.body);

      return ListRoomTypeReadyResponse.fromJson(convertedResult);
    }catch(err){
      return ListRoomTypeReadyResponse(
        isLoading: false,
        state: false,
        message: err.toString()
      );
    }
  }

  Future<RoomListResponse> getRoomList(String roomType)async{
    try{
      final serverUrl = await PreferencesData.url();
      // final url = Uri.parse('$serverUrl/member/membership/$memberCode');
      final url = Uri.parse('http://192.168.1.136:3000/room/all-room-ready-by-type-grouping/$roomType');
      final apiResponse = await http.get(url);
      final convertedResult = json.decode(apiResponse.body);

      return RoomListResponse.fromJson(convertedResult);
    }catch(err){
      return RoomListResponse(
        isLoading: false,
        state: false,
        message: err.toString()
      );
    }
  }

  Future<BaseResponse> doCheckin(CheckinBody checkinData)async{
    try{
      final serverUrl = await PreferencesData.url();
      // final url = Uri.parse('$serverUrl/member/membership/$memberCode');
      final url = Uri.parse('http://192.168.1.136:3000/checkin-direct/direct-checkin-member');
      final body = GenerateCheckinParams().checkinBodyRequest(checkinData);
      final apiResponse = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(body));
      final convertedResult = json.decode(apiResponse.body);

      return BaseResponse.fromJson(convertedResult);
    }catch(err){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: err.toString()
      );
    }
  }

  Future<EdcResponse> getEdc()async{
    try{
      final serverUrl = await PreferencesData.url(); 
      // final url = Uri.parse('$serverUrl/member/membership/$memberCode');
      final url = Uri.parse('http://192.168.1.136:3000/edc/list-edc');
      final apiResponse = await http.get(url);
      final convertedResult = json.decode(apiResponse.body);
      return EdcResponse.fromJson(convertedResult);
    }catch(err){
      return EdcResponse(
        isLoading: false,
        state: false,
        message: err.toString()
      );
    }
  }

  Future<PromoRoomResponse> getPromoRoom(roomType)async{
    try{
      final serverUrl = await PreferencesData.url();
      // final url = Uri.parse('$serverUrl/member/membership/$memberCode');
      final url = Uri.parse('http://192.168.1.136:3000/promo/promo-room/$roomType');
      final apiResponse = await http.get(url);
      final convertedResult = json.decode(apiResponse.body);
      return PromoRoomResponse.fromJson(convertedResult);
    }catch(err){
      return PromoRoomResponse(
        isLoading: false,
        state: false,
        message: err.toString()
      );
    }
  }

  Future<PromoFnbResponse> getPromoFnB(roomType, roomCode)async{
    try{
      final serverUrl = await PreferencesData.url();
      // final url = Uri.parse('$serverUrl/member/membership/$memberCode');
      final url = Uri.parse('http://192.168.1.136:3000/promo/promo-food/$roomType/$roomCode');
      final apiResponse = await http.get(url);
      final convertedResult = json.decode(apiResponse.body);
      return PromoFnbResponse.fromJson(convertedResult);
    }catch(err){
      return PromoFnbResponse(
        isLoading: false,
        state: false,
        message: err.toString()
      );
    }
  }
/*
  Future<BaseResponse> editCheckin()async{
    try{
      final serverUrl = await PreferencesData.url();
      // final url = Uri.parse('$serverUrl/member/membership/$memberCode');
      final url = Uri.parse('http://192.168.1.136:3000/checkin-direct/edit-checkin');
      // final body = GenerateCheckinParams().checkinBodyRequest(checkinData);
      // final apiResponse = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(body));
      // final convertedResult = json.decode(apiResponse.body);
      // return BaseResponse.fromJson(convertedResult);
    }catch(err){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: err.toString()
      );
    }
  }*/

  Future<RoomCheckinResponse> getListRoomCheckin(String? search)async{
    try{
      if(isNullOrEmpty(search)){
        search = '';
      }
      final serverUrl = await PreferencesData.url();
      // final url = Uri.parse('$serverUrl/member/membership/$memberCode');
      final url = Uri.parse('http://192.168.1.136:3000/room/all-room-checkin?keyword=$search');
      final apiResponse = await http.get(url);
      final convertedResult = json.decode(apiResponse.body);
      return RoomCheckinResponse.fromJson(convertedResult);
    }catch(e){
      return RoomCheckinResponse(
        state: false,
        message: e.toString(),
        data: []
      );
    }
  }

  Future<DetailCheckinResponse> getDetailRoomCheckin(String roomCode)async{
    try{
      final serverUrl = await PreferencesData.url();
      // final url = Uri.parse('$serverUrl/member/membership/$memberCode');
      final url = Uri.parse('http://192.168.1.136:3000/checkin/checkin-result/$roomCode');
      final apiResponse = await http.get(url);
      final convertedResult = json.decode(apiResponse.body);
      return DetailCheckinResponse.fromJson(convertedResult);
    }catch(e){
      return DetailCheckinResponse(
        state: false,
        message: e.toString()
      );
    }
  }
}