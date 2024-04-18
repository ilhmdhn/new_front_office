import 'dart:convert';
import 'package:front_office_2/data/model/base_response.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/model/cek_member_response.dart';
import 'package:front_office_2/data/model/checkin_body.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';
import 'package:front_office_2/data/model/room_checkin_response.dart';
import 'package:front_office_2/data/model/room_list_model.dart';
import 'package:front_office_2/data/model/room_type_model.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:http/http.dart' as http;

class ApiRequest{

  final serverUrl = PreferencesData.getUrl();
  final token = PreferencesData.getUserToken();
  
  Future<LoginResponse> loginFO(String userId, String password)async{
    try {
      final url = Uri.parse('$serverUrl/user/login-fo-droid');
      final apiResponse = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode({
        'user_id': userId,
        'user_password': password
      }));
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
    final serverUrl = PreferencesData.getUrl();
    final url = Uri.parse('$serverUrl/member/membership/$memberCode');
    final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});
    if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
    }
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
      final url = Uri.parse('$serverUrl/room/all-room-type-ready-grouping');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
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
      final url = Uri.parse('$serverUrl/room/all-room-ready-by-type-grouping/$roomType');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
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
      final url = Uri.parse('$serverUrl/checkin-direct/direct-checkin-member');
      final body = GenerateCheckinParams().checkinBodyRequest(checkinData);
      final apiResponse = await http.post(url, headers: {'Content-Type': 'application/json', 'authorization': token}, body: json.encode(body));
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
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
      final url = Uri.parse('$serverUrl/edc/list-edc');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
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
      final url = Uri.parse('$serverUrl/promo/promo-room/$roomType');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
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
      final url = Uri.parse('$serverUrl/promo/promo-food/$roomType/$roomCode');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
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

  Future<BaseResponse> editCheckin(EditCheckinBody editData)async{
    try{
      final url = Uri.parse('$serverUrl/checkin-direct/edit-checkin');
      final body = GenerateCheckinParams().editCheckinBodyRequest(editData);
      final apiResponse = await http.post(url, headers: {'Content-Type': 'application/json', 'authorization': token}, body: json.encode(body));
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
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

  Future<RoomCheckinResponse> getListRoomCheckin(String? search)async{
    try{
      if(isNullOrEmpty(search)){
        search = '';
      }
      final url = Uri.parse('$serverUrl/room/all-room-checkin?keyword=$search');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
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

  Future<RoomCheckinResponse> getListRoomPaidd(String? search)async{
    try{
      if(isNullOrEmpty(search)){
        search = '';
      }
      final url = Uri.parse('$serverUrl/room/all-room-paid?keyword=$search');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
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
      final url = Uri.parse('$serverUrl/checkin/checkin-result/$roomCode');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
      final convertedResult = json.decode(apiResponse.body);
      return DetailCheckinResponse.fromJson(convertedResult);
    }catch(e){
      return DetailCheckinResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  Future<BaseResponse> cekSign()async{
    try{
      
      final url = Uri.parse('$serverUrl/sign');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});  
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  Future<BaseResponse> extendRoom(String roomCode, String duration)async{
    try{
      String userId = PreferencesData.getUser().userId??'UNKNOWN';
      final bodyRequest = {
        "room": roomCode,
        "durasi_jam": duration,
        "durasi_menit": "0",
        "chusr": userId
      };

      final url = Uri.parse('$serverUrl/checkin-direct/extend-room');
      final apiResponse = await http.post(url ,headers: {'Content-Type': 'application/json', 'authorization': token}, body: json.encode(bodyRequest));

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString() 
      );
    }
  }

  Future<BaseResponse> reduceRoom(String reception, String duration)async{
    try{
      String userId = PreferencesData.getUser().userId??'UNKNOWN';
      final bodyRequest = {
        "rcp": reception,
        "durasi": duration,
        "chusr": userId
      };

      final url = Uri.parse('$serverUrl/checkin-direct/reduce_duration');
      final apiResponse = await http.post(url ,headers: {'Content-Type': 'application/json', 'authorization': token}, body: json.encode(bodyRequest));

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString() 
      );
    }
  }

  Future<PreviewBillResponse> previewBill(String roomCode)async{
    try{
      final url = Uri.parse('$serverUrl/mobile-print/view-bill?room=$roomCode');
      final apiResponse = await http.get(url ,headers: {'Content-Type': 'application/json', 'authorization': token});

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return PreviewBillResponse.fromJson(convertedResult);
    }catch(e){
      return PreviewBillResponse(
        state: false, 
        message: e.toString());
    }
  }

  Future<BaseResponse> pay(Map<String, dynamic> params)async{
    try{
      final url = Uri.parse('$serverUrl/payment/add');
      final apiResponse = await http.post(url , body: json.encode(params), headers: {'Content-Type': 'application/json', 'authorization': token});

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false, 
        message: e.toString());
    }
  }

  void loginPage(){
    getIt<NavigationService>().pushNamedAndRemoveUntil(LoginPage.nameRoute);
  }
}