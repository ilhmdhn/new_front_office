import 'dart:convert';
import 'package:device_information/device_information.dart';
import 'package:front_office_2/data/model/base_response.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/model/cek_member_response.dart';
import 'package:front_office_2/data/model/checkin_body.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/data/model/order_body.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';
import 'package:front_office_2/data/model/room_checkin_response.dart';
import 'package:front_office_2/data/model/room_list_model.dart';
import 'package:front_office_2/data/model/room_type_model.dart';
import 'package:front_office_2/data/model/sol_response.dart';
import 'package:front_office_2/data/model/string_response.dart';
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

    Future<BaseResponse> doCheckinLobby(Map<String, dynamic> params)async{
    try{
      final url = Uri.parse('$serverUrl/checkin-direct/direct-lobby-member');
      final apiResponse = await http.post(url, headers: {'Content-Type': 'application/json', 'authorization': token}, body: json.encode(params));
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

  Future<RoomCheckinResponse> getListRoomPaid(String? search)async{
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

  Future<RoomCheckinResponse> getListRoomCheckout(String? search)async{
    try{
      if(isNullOrEmpty(search)){
        search = '';
      }
      final url = Uri.parse('$serverUrl/room/all-room-checkout?keyword=$search');
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
        isLoading: false,
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
        isLoading: false,
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
        isLoading: false,
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


  Future<PreviewBillResponse> getBill(String roomCode)async{
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
        isLoading: false,
        state: false, 
        message: e.toString());
    }
  }

  Future<BaseResponse> checkout(String room)async{
    try{
      final url = Uri.parse('$serverUrl/room/checkout');

      final checkinBody = {
        'room': room,
        'chusr': PreferencesData.getUser().userId
      };

      final apiResponse = await http.post(url , body: json.encode(checkinBody), headers: {'Content-Type': 'application/json', 'authorization': token});

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }

  Future<BaseResponse> clean(String room)async{
    try{
      final url = Uri.parse('$serverUrl/room/clean');

      final checkinBody = {
        'room': room,
        'chusr': PreferencesData.getUser().userId
      };

      final apiResponse = await http.post(url , body: json.encode(checkinBody), headers: {'Content-Type': 'application/json', 'authorization': token});

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }

  Future<BaseResponse> removePromoRoom(String rcpCode)async{
    try{
      final url = Uri.parse('$serverUrl/checkin-direct/remove_promo?rcp=$rcpCode');
      final apiResponse = await http.delete(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }

  Future<BaseResponse> removePromoFood(String rcpCode)async{
    try{
      final url = Uri.parse('$serverUrl/checkin-direct/remove-promo-fnb/$rcpCode');
      final apiResponse = await http.delete(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }

  Future<FnBResultModel> fnbPage(int page, String category, String search)async{
    try{
      Uri url = Uri.parse('$serverUrl/inventory/list-paging?page=$page&size=10&category=$category&search=$search');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return FnBResultModel.fromJson(convertedResult);
    }catch(e){
      return FnBResultModel(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }

  Future<OrderResponse> getOrder(String roomCode)async{
    try{
      Uri url = Uri.parse('$serverUrl/room/$roomCode/order');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return OrderResponse.fromJson(convertedResult);
    }catch(e){
      return OrderResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  Future<BaseResponse> sendOrder(String roomCode, String rcp, String roomType, int checkinDuration, List<SendOrderModel> orderData)async{
    try{
      Uri url = Uri.parse('$serverUrl/order/single/room/sol/sod');
      final bodyParams = await GenerateOrderParams.orderParams(roomCode, rcp, roomType, checkinDuration, orderData);
      final apiResponse = await http.post(url, body: json.encode(bodyParams), headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }

  Future<BaseResponse> revisiOrder(OrderedModel data, String sol, String rcp, String oldQty)async{
    try{
      Uri url = Uri.parse('$serverUrl/order/revisi-order');
      
      final bodyParams = {
        "order_slip_order": sol,
        "order_inventory": data.invCode,
        "order_note": data.notes,
        "order_qty": oldQty,
        "order_qty_temp": data.qty,
        "order_room_rcp": rcp,
        "order_room_user": PreferencesData.getUser().userId,
        "order_model_android": await DeviceInformation.deviceModel
      };
      
      final apiResponse = await http.post(url, body: json.encode(bodyParams), headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);

    }catch(e){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }

  Future<BaseResponse> cancelSo(String invCode, String sol, String rcp, String oldQty)async{
    try{
      Uri url = Uri.parse('$serverUrl/order/cancelOrder');
      
      final bodyParams = {
        "order_slip_order": sol,
        "order_inventory": invCode,
        "order_qty": oldQty,
        "order_room_rcp": rcp,
        "order_room_user": PreferencesData.getUser().userId,
        "order_model_android": await DeviceInformation.deviceModel
      };
      
      final apiResponse = await http.post(url, body: json.encode(bodyParams), headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);

    }catch(e){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }

  Future<BaseResponse> confirmDo(String roomCode, OrderedModel fnb)async{
    try{
      Uri url = Uri.parse('$serverUrl/neworder/add');
      
      final bodyParams = {
        "room": roomCode,
        "chusr": PreferencesData.getUser().userId,
        "order_inventory": [{
          'inventory': fnb.invCode,
          'nama': fnb.name,
          'qty': fnb.qty,
          'slip_order': fnb.sol,
          }
        ]
      };
      
      final apiResponse = await http.post(url, body: json.encode(bodyParams), headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);

    }catch(e){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }

  Future<BaseResponse> cancelDo(String roomCode, OrderedModel fnb, int qty)async{
    try{
      Uri url = Uri.parse('$serverUrl/cancelorder/add');
      
      final bodyParams = {
        "room": roomCode,
        "chusr": PreferencesData.getUser().userId,
        "order_inventory": [{
          'inventory': fnb.invCode,
          'nama': fnb.name,
          'qty': qty,
          'order_penjualan': fnb.okl,
          'slip_order': fnb.sol,
          }
        ]
      };
      
      final apiResponse = await http.post(url, body: json.encode(bodyParams), headers: {'Content-Type': 'application/json', 'authorization': token});
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);

    }catch(e){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }

  Future<SolResponse> getSol(String sol)async{
    try{
      Uri url = Uri.parse('$serverUrl/mobile-print/list-so?sol=$sol');
      final apiResponse = await http.get(url);

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return SolResponse.fromJson(convertedResult);
    }catch(e){
      return SolResponse(state: false, message: e.toString(), data: List.empty());
    }
  }

  Future<StringResponse> latestSo(String rcp)async{
    try{
      Uri url = Uri.parse('$serverUrl/mobile-print/latest-so?rcp=$rcp');
      final apiResponse = await http.get(url);

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return StringResponse.fromJson(convertedResult);
    }catch(e){
      return StringResponse(state: false, message: e.toString(), data: '');
    }
  }

  void loginPage(){
    getIt<NavigationService>().pushNamedAndRemoveUntil(LoginPage.nameRoute);
  }
}