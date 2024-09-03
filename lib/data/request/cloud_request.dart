import 'dart:convert';

import 'package:front_office_2/data/model/list_approval_request.dart';
import 'package:front_office_2/data/model/voucher_member_response.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:front_office_2/data/model/base_response.dart';

class CloudRequest{

  static final baseUrl = dotenv.env['server_fo_cloud'];
  static final token = dotenv.env['fo_cloud_auth']!;

  static final membershipServer = dotenv.env['server_membership']!;
  static final membershipToken = dotenv.env['membership_auth']!;

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

  static Future<BaseResponse> apporvalRequest(String idApproval, String rcp, String room, String notes)async{
    try{
      
      String outlet = PreferencesData.getOutlet();
      String userId = PreferencesData.getUser().userId??'';

      final body = {
      "outlet": outlet,
      "id": idApproval,
      "user": userId,
      "reception": rcp,
      "room": room,
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

  static Future<RequestApprovalResponse> approvalList()async{
    try{
      String outlet = PreferencesData.getOutlet();

      final url = Uri.parse('http://172.188.42.60:3200/approval/list?outlet=$outlet');
      final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json', 'authorization': token});
      final convertedResult = json.decode(apiResponse.body);
      return RequestApprovalResponse.fromJson(convertedResult);
    }catch(e){
      return RequestApprovalResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> confirmApproval(String idApproval)async{
    try{
      String outlet = PreferencesData.getOutlet();
      String userId = PreferencesData.getUser().userId??'';
      final url = Uri.parse('$baseUrl/approval/confirm/$outlet/$idApproval');
    
      final apiResponse = await http.put(url, 
        headers:{'Content-Type': 'application/json','authorization': token},
        body: json.encode({
          'user': userId
        })
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

  static Future<BaseResponse> rejectApproval(String idApproval)async{
    try{
      String outlet = PreferencesData.getOutlet();
      String userId = PreferencesData.getUser().userId??'';
      final url = Uri.parse('$baseUrl/approval/reject/$outlet/$idApproval');
      
      final apiResponse = await http.put(url, 
        headers:{'Content-Type': 'application/json','authorization': token},
        body: json.encode({
        'user': userId
        })
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

  static Future<BaseResponse> cancelApproval(String idApproval)async{
    try{
      String outlet = PreferencesData.getOutlet();
      final url = Uri.parse('$baseUrl/approval/cancel/$outlet/$idApproval');
      final apiResponse = await http.put(url, headers:{'Content-Type': 'application/json','authorization': token});
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> finishApproval(String idApproval)async{
    try{
      String outlet = PreferencesData.getOutlet();
      final url = Uri.parse('$baseUrl/approval/finish/$outlet/$idApproval');
      
      final apiResponse = await http.put(url, 
        headers:{'Content-Type': 'application/json','authorization': token});
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> timeoutApproval(String idApproval)async{
    try{
      String outlet = PreferencesData.getOutlet();
      final url = Uri.parse('$baseUrl/approval/timeout/$outlet/$idApproval');
      
      final apiResponse = await http.put(url, headers:{'Content-Type': 'application/json','authorization': token});
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> totalApprovalRequest(String outlet)async{
    try{
      String outlet = PreferencesData.getOutlet();
      final url = Uri.parse('$baseUrl/approval/total/$outlet');
      
      final apiResponse = await http.get(url, headers:{'Content-Type': 'application/json','authorization': token});
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

    static Future<BaseResponse> insertRate(String? invoice, String? member, double? rate, String? reason)async{
      try{
        String outlet = PreferencesData.getOutlet();
        final url = Uri.parse('$baseUrl/transaction/insert-rating');

        final bodyParams = {
          'invoice': invoice,
          'outlet': outlet,
          'member': member,
          'rate': rate,
          'reason': reason
        };
        final apiResponse = await http.post(url,body: json.encode(bodyParams) ,headers:{'Content-Type': 'application/json','authorization': token});
        final convertedResult = json.decode(apiResponse.body);
        return BaseResponse.fromJson(convertedResult);
      }catch(e){
        return BaseResponse(
          state: false,
          message: e.toString()
        );
      }
  }

  static Future<BaseResponse> approvalState(String idApproval)async{
    try{
        String outlet = PreferencesData.getOutlet();
        final url = Uri.parse('$baseUrl/approval/state?outlet=$outlet&id_approval=$idApproval');
        final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json','authorization': token});
        final convertedResult = json.decode(apiResponse.body);
        return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> approvalReason(String idApproval, String reason)async{
    try{
      String outlet = PreferencesData.getOutlet();
      final url = Uri.parse('$baseUrl/approval/note/$outlet/$idApproval');
      final apiResponse = await http.put(
        url, 
        headers: {'Content-Type': 'application/json','authorization': token},
        body: json.encode({
          'reason': reason
        })
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

    static Future<VoucherMemberResponse> memberVoucher(String memberCode, String voucherCode)async{
    try{
        final url = Uri.parse('$membershipServer/voucher-info?member_code=$memberCode&voucher_code=$voucherCode');
        final apiResponse = await http.get(url, headers: {'Content-Type': 'application/json','authorization': membershipToken});
        final convertedResult = json.decode(apiResponse.body);
        return VoucherMemberResponse.fromJson(convertedResult);
    }catch(e){
      return VoucherMemberResponse(
        state: false,
        message: e.toString()
      );
    }
  }
}