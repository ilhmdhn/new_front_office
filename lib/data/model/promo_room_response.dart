import 'package:flutter/material.dart';

class PromoRoomResponse{
  bool isLoading;
  bool? state;
  String? message;
  List<PromoRoomModel> data;

  PromoRoomResponse({
    this.isLoading = true,
    this.state,
    this.message,
    this.data = const[]
  });

  factory PromoRoomResponse.fromJson(Map<String, dynamic> json){
    return PromoRoomResponse(
      isLoading: false,
      state: json['state'],
      message: json['message'],
      data: List<PromoRoomModel>.from(
        (json['data'] as List).map((e) => PromoRoomModel.fromJson(e))
      ),
    );
  }
}

class PromoRoomModel{
  String? promoName;
  int? promoPercent;
  int? promoIdr;
  String? timeStart;
  int? finishDate;
  String? timeFinish;

  PromoRoomModel({
    this.promoName, 
    this.promoPercent,  
    this.promoIdr,
    this.timeStart, 
    this.finishDate, 
    this.timeFinish
  });

  factory PromoRoomModel.fromJson(Map<String, dynamic>json){
    return PromoRoomModel(
      promoName: json['promo_room'],
      promoPercent: json['diskon_persen'],
      promoIdr: json['diskon_rp'],
      timeStart: json['time_start'],
      finishDate: json['date_finish'],
      timeFinish: json['time_finish']
    );
  }
}

// class VoucherDetail{
//   String code;
//   String reception;
//   int hour;
//   num roomPrice;
//   int roomPercent;
//   String item;
//   num itemPrice;
//   int itemPercent;
//   num price;

//   VoucherDetail({
//     required this.code,
//     required this.reception,
//     required this.hour,
//     required this.roomPrice,
//     required this.roomPercent,
//     required this.item,
//     required this.itemPrice,
//     required this.itemPercent,
//     required this.price,
//   });

//   factore VoucherDetail.fromJson
// }