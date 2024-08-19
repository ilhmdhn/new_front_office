import 'package:front_office_2/data/model/bill_response.dart';

class CheckinSlipResponse{
  bool state;
  String message;
  CheckinSlipModel? data;
  
  CheckinSlipResponse({
    this.state = false,
    this.message = '',
    this.data
  });

  factory CheckinSlipResponse.fromJson(Map<String, dynamic>json){
    return CheckinSlipResponse(
      state: json['state'],
      message: json['message'],
      data: CheckinSlipModel.fromJson(json['data'])
    );
  }

}

class CheckinSlipModel{
  OutletModel outlet;
  CheckinDetail detail;

  CheckinSlipModel({
    required this.outlet,
    required this.detail
  });

  factory CheckinSlipModel.fromJson(Map<String, dynamic> json){
    return CheckinSlipModel(
      outlet: OutletModel.fromJson(json['outlet_info']), 
      detail: CheckinDetail.fromJson(json['checkin_detail']));
  }
}

class CheckinDetail{
  String name;
  String phone;
  int pax;
  String roomType;
  String checkinTime;
  String checkoutTime;
  String checkinDuration;
  num checkinFee;
  String roomName;

  CheckinDetail({
    this.name = '',
    this.phone = '',
    this.pax = 0,
    this.roomType = '',
    this.checkinTime = '',
    this.checkoutTime = '',
    this.checkinDuration = '',
    this.checkinFee = 0,
    this.roomName = '',
  });

  factory CheckinDetail.fromJson(Map<String, dynamic>json){
    return CheckinDetail(
      name: json['name'],
      phone: json['phone'],
      pax: json['pax'],
      roomType: json['room_type'],
      checkinTime: json['checkin_time'],
      checkoutTime: json['checkout_time'],
      checkinDuration: json['checkin_duration'],
      checkinFee: json['checkin_fee'],
      roomName: json['room_name'],
    );
  }
}