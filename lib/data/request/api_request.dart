import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/rendering.dart';
import 'package:front_office_2/data/dummy/dummy_response_helper.dart';
import 'package:front_office_2/data/model/base_response.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/model/call_service_history.dart';
import 'package:front_office_2/data/model/cek_member_response.dart';
import 'package:front_office_2/data/model/checkin_body.dart';
import 'package:front_office_2/data/model/checkin_slip_response.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/data/model/invoice_response.dart';
import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/data/model/order_body.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';
import 'package:front_office_2/data/model/room_checkin_response.dart';
import 'package:front_office_2/data/model/room_list_model.dart';
import 'package:front_office_2/data/model/room_type_model.dart';
import 'package:front_office_2/data/model/sol_response.dart';
import 'package:front_office_2/data/model/status_room_checkin.dart';
import 'package:front_office_2/data/model/string_response.dart';
import 'package:front_office_2/data/model/transfer_params.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/execute_printer.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/json_converter.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:http/http.dart' as http;

class ApiRequest{

  // Gunakan getter untuk akses GlobalProviders
  String get serverUrl => GlobalProviders.read(serverUrlProvider);
  String get token => GlobalProviders.read(userTokenProvider);
  String get userId => GlobalProviders.read(userProvider).userId;
  
  Future<LoginResponse> loginFO(String userId, String password)async{
    try {
      if(userId == 'test'){
        final data =  await DummyResponseHelper.getLoginResponse();
        return data;
      }
      final url = Uri.parse('$serverUrl/user/login-fo-droid');
      final apiResponse = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode({
        'user_id': userId,
        'user_password': password
      }));
      final convertedResult = json.decode(apiResponse.body);
      return LoginResponse.fromJson(convertedResult, password);
    } catch (e, stakTrace) {
      debugPrint('ERROR loginFO: $e\n$stakTrace');
      return LoginResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  Future<CekMemberResponse> cekMember(String memberCode) async {
  try {
    if(userId == 'TEST'){
      final data =  await DummyResponseHelper.getCekMember(memberCode);
      return data;
    }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getListRoomTypeReady();
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getRoomListByType(roomType);
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      final url = Uri.parse('$serverUrl/checkin-direct/direct-checkin-member');
      final body = GenerateCheckinParams().checkinBodyRequest(checkinData);
      final apiResponse = await http.post(url, headers: {'Content-Type': 'application/json', 'authorization': token}, body: json.encode(body));
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
      final convertedResult = json.decode(apiResponse.body);
      debugPrint('DEBUGGING checkin response: $convertedResult');
      DoPrint.checkin(convertedResult['data']['checkin_room']['room_rcp']);
      return BaseResponse.fromJson(convertedResult);
    }catch(err, stackTrace){
      showToastError('Gagal checkin $err');
      debugPrint('DEBUGGING Error apa ini $err');
      debugPrint('DEBUGGING line error $stackTrace');
      return BaseResponse(
        isLoading: false,
        state: false,
        message: err.toString()
      );
    }
  }

  Future<BaseResponse> doCheckinLobby(Map<String, dynamic> params)async{
    try{
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      final url = Uri.parse('$serverUrl/checkin-direct/direct-lobby-member');
      final apiResponse = await http.post(url, headers: {'Content-Type': 'application/json', 'authorization': token}, body: json.encode(params));
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
          loginPage();
      }
      final convertedResult = json.decode(apiResponse.body);
      // DoPrint.checkin(convertedResult['data']['checkin_room']['room_rcp']);
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getEdcList();
        return data;
      }
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

  Future<PromoRoomResponse> getPromoRoom(String roomType)async{
    try{
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getPromoRoom();
        return data;
      }
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

  Future<PromoFnbResponse> getPromoFnB(String roomType, String roomCode)async{
    try{
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getPromoFnb();
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getListRoomCheckin();
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getListRoomCheckin();
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getListRoomCheckin();
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getDetailRoomCheckin(roomCode);
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      final url = Uri.parse('$serverUrl/sign');
      final apiResponse = await http.get(
        url, 
        headers: {'Content-Type': 'application/json', 'authorization': token},
      ).timeout(
        const Duration(seconds: 10), // <--- set timeout
        onTimeout: () {
          throw Exception('Tidak terhubung ke server');
        },
      );
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      final userIdz = GlobalProviders.read(userProvider).userId;
      final bodyRequest = {
        "room": roomCode,
        "durasi_jam": duration,
        "durasi_menit": "0",
        "chusr": userIdz
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      final userIdz = GlobalProviders.read(userProvider).userId;
      final bodyRequest = {
        "rcp": reception,
        "durasi": duration,
        "chusr": userIdz
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getPreviewBill('SUCCESS');
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getPreviewBill('SUCCESS');
        return data;
      }
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

  Future<InvoiceResponse> getInvoice(String rcp)async{
    try{
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getInvoice('SUCCESS');
        return data;
      }
      final url = Uri.parse('$serverUrl/mobile-print/invoice?rcp=$rcp');
      final apiResponse = await http.get(url ,headers: {'Content-Type': 'application/json', 'authorization': token});

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return InvoiceResponse.fromJson(convertedResult);
    }catch(e){
      return InvoiceResponse(
        state: false,
        message: e.toString(),
        data: null
      );
    }
  }

  Future<BaseResponse> pay(Map<String, dynamic> params)async{
    try{
        if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      final url = Uri.parse('$serverUrl/room/checkout');

      final checkinBody = {
        'room': room,
        'chusr': GlobalProviders.read(userProvider).userId
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      final url = Uri.parse('$serverUrl/room/clean');

      final checkinBody = {
        'room': room,
        'chusr': GlobalProviders.read(userProvider).userId
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getFnbList();
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getOrderList('SUCCESS');
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      Uri url = Uri.parse('$serverUrl/order/revisi-order');
      final deviceInfo = DeviceInfoPlugin();
      String deviceModel = '';
      if(Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceModel = androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceModel = iosInfo.utsname.machine;
      }
      final bodyParams = {
        "order_slip_order": sol,
        "order_inventory": data.invCode,
        "order_note": data.notes,
        "order_qty": oldQty,
        "order_qty_temp": data.qty,
        "order_room_rcp": rcp,
        "order_room_user": GlobalProviders.read(userProvider).userId,
        "order_model_android": deviceModel
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      Uri url = Uri.parse('$serverUrl/order/cancelOrder');
      final deviceInfo = DeviceInfoPlugin();
      String deviceModel = '';
      if(Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceModel = androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceModel = iosInfo.utsname.machine;
      }
      final bodyParams = {
        "order_slip_order": sol,
        "order_inventory": invCode,
        "order_qty": oldQty,
        "order_room_rcp": rcp,
        "order_room_user": GlobalProviders.read(userProvider).userId,
        "order_model_android": deviceModel
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      Uri url = Uri.parse('$serverUrl/neworder/add');
      
      final bodyParams = {
        "room": roomCode,
        "chusr": GlobalProviders.read(userProvider).userId,
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      Uri url = Uri.parse('$serverUrl/cancelorder/add');
      
      final bodyParams = {
        "room": roomCode,
        "chusr": GlobalProviders.read(userProvider).userId,
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
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getSolResponse('SUCCESS');
        return data;
      }
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
      if(userId == 'TEST'){
        final data = StringResponse(state: true, message: 'SUCCESS', data: 'SO');
        return data;
      }
      Uri url = Uri.parse('$serverUrl/mobile-print/latest-so?rcp=$rcp');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return StringResponse.fromJson(convertedResult);
    }catch(e){
      return StringResponse(state: false, message: e.toString(), data: '');
    }
  }

  Future<BaseResponse> transferRoomtoRoom(TransferParams data)async{
    try{
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      Uri url = Uri.parse('$serverUrl/checkin-direct/transfer-room-member');
      final bodyParams = JsonConverter.generateTransferParams(data);
      final apiResponse = await http.post(url, body: json.encode(bodyParams), headers: {'Content-Type': 'application/json', 'authorization': token} );

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      DoPrint.checkin(convertedResult['data']['kode_rcp']);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(state: false, message: e.toString());
    }
  }

  Future<BaseResponse> transferLobbytoLobby(TransferParams data)async{
    try{
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      Uri url = Uri.parse('$serverUrl/transfer/tolobby');
      final chusr = GlobalProviders.read(userProvider).userId;
      Map<String, dynamic> bodyParams = {
        "room_code": data.oldRoom,
        "room_destination": data.roomDestination,
        "chusr": chusr
      };

      final apiResponse = await http.post(url, body: json.encode(bodyParams), headers: {'Content-Type': 'application/json', 'authorization': token} );

      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(state: false, message: e.toString());
    }
  }

  Future<BaseResponse> updatePrintState(String rcp, String state)async{
    try{
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      Uri url = Uri.parse('$serverUrl/mobile-print/update-status?rcp=$rcp&status_print=$state');
      final apiResponse = await http.get(url);
      
      if(apiResponse.statusCode == 401 || apiResponse.statusCode == 403){
        loginPage();
      }
      
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(state: false, message: e.toString());
    }
  }

  Future<CheckinSlipResponse> checkinSlip(String rcp)async{
    try{
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getCheckinSlip('SUCCESS');
        return data;
      }
      Uri url = Uri.parse('$serverUrl/mobile-print/checkin-slip?rcp=$rcp');
      final apiResponse = await http.get(url);

      if (apiResponse.statusCode == 401 || apiResponse.statusCode == 403) {
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return CheckinSlipResponse.fromJson(convertedResult);

    }catch(e){
      return CheckinSlipResponse(state: false, message: e.toString());
    }
  }

  Future<RoomCheckinState> checkinState()async{
    try{
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getRoomCheckinState();
        return data;
      }
      Uri url = Uri.parse('$serverUrl/room/all-room-checkin-by-type');
      final apiResponse = await http.get(url);

      if (apiResponse.statusCode == 401 || apiResponse.statusCode == 403) {
        loginPage();
      }

      final convertedResult = json.decode(apiResponse.body);
      return RoomCheckinState.fromJson(convertedResult);
    }catch(e){
      return RoomCheckinState(state: false, message: e.toString());
    }
  }

  Future<BaseResponse> tokenPost()async{
    try{
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      final url = Uri.parse('$serverUrl/firebase/token');
      Map<String, dynamic> bodyParams = {
        "token": GlobalProviders.read(fcmTokenProvider),
        "user": GlobalProviders.read(userProvider).userId,
        "user_level": GlobalProviders.read(userProvider).level
      };
      final apiResponse = await http.post(
        url, 
        body: json.encode(bodyParams),
        headers: {'Content-Type': 'application/json', 'authorization': token},
      ).timeout(
        const Duration(seconds: 10), // <--- set timeout
        onTimeout: () {
          throw Exception('Tidak terhubung ke server');
        },
      );
      final convertedResult = json.decode(apiResponse.body);
      debugPrint('DEBUGGING tokenPost: ${convertedResult.toString()}');
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        isLoading: false,
        state: false,
        message: e.toString()
      );
    }
  }

  Future<BaseResponse> callResponse(String roomCode)async{
    try{
      if(userId == 'TEST'){
        final data =  await DummyResponseHelper.getBaseResponseSuccess('SUCCESS');
        return data;
      }
      final url = Uri.parse('$serverUrl/call/callroom/$roomCode');
      Map<String, dynamic> bodyParams = {
        "chusr": GlobalProviders.read(userProvider).userId
      };
      final apiResponse = await http.put(
        url, 
        body: json.encode(bodyParams),
        headers: {'Content-Type': 'application/json', 'authorization': token},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tidak terhubung ke server');
        },
      );
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

  Future<CallServiceHistoryResponse> getServiceHistory()async{
    try{
      if(userId == 'TEST'){
        final data =  CallServiceHistoryResponse(
          state: true,
          message: 'SUCCESS',
          data: [
            CallServiceHistory(
              isNow: 1,
              roomCode: '101',
              callTime: '10:00',
              callResponse: '',
              responsedBy: 'Admin'
            ),
            CallServiceHistory(
              isNow: 0,
              roomCode: '101',
              callTime: '10:00',
              callResponse: '10:02',
              responsedBy: 'Admin'
            ),
          ]
        );
        return data;
      }
      final url = Uri.parse('$serverUrl/call/callroom');
      final apiResponse = await http.get(
        url, 
        headers: {'Content-Type': 'application/json', 'authorization': token},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tidak terhubung ke server');
        },
      );
      final convertedResult = json.decode(apiResponse.body);
      return CallServiceHistoryResponse.fromJson(convertedResult);
    }catch(e){
      return CallServiceHistoryResponse(
        state: false,
        message: e.toString(),
        data: []
      );
    }
  }
  void loginPage(){
    getIt<NavigationService>().pushNamedAndRemoveUntil(LoginPage.nameRoute);
  }
}