import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';

class DetailCheckinResponse{
  bool state;
  String message;
  DetailCheckinModel? data;

  DetailCheckinResponse({
    this.state = false,
    this.message = '',
    this.data,
  });

  factory DetailCheckinResponse.fromJson(Map<String, dynamic>json){
    return DetailCheckinResponse(
      state: json['state'],
      message: json['message'],
      data: DetailCheckinModel.fromJson(json['data'])
    );
  }
}

class DetailCheckinModel{
  String roomCode;
  String memberName;
  String memberCode;
  String roomAlias;
  int minuteRemaining;
  int hourRemaining;
  int pax;
  PromoRoomModel? promoRoom;
  PromoFnbModel? promoFnb;
  String hp;
  int downPayment;
  String description;
  String voucher;
  String dpNote;
  String cardType;
  String cardName;
  String cardNo;
  String cardApproval;
  String edcMachine;

  DetailCheckinModel({
    this.roomCode = '',
    this.memberName = '',
    this.memberCode ='',
    this.roomAlias =' ',
    this.minuteRemaining = 0,
    this.hourRemaining = 0,
    this.pax = 0,
    this.promoRoom,
    this.promoFnb,
    this.hp = '',
    this.downPayment = 0,
    this.description = '',
    this.voucher = '',
    this.dpNote = '',
    this.cardType = '',
    this.cardName = '',
    this.cardNo = '',
    this.cardApproval = '',
    this.edcMachine = ''    
  });

  factory DetailCheckinModel.fromJson(Map<String, dynamic>json){
    return DetailCheckinModel(
      roomCode: json['room'],
      memberName: json['checkin_room']['nama_member'],
      memberCode: json['checkin_room']['kode_member'],
      // roomAlias: json[''],
      // minuteRemaining: json[''],
      // hourRemaining: json[''],
      // pax: json[''],
      // promoRoom: json['order_promo_room'][0] == null ? null: PromoRoomModel.fromJson(json['order_promo_room'][0]),
      // promoFnb: json['order_promo_food'][0] == null? null: PromoFnbModel.fromJson(json['order_promo_food'][0]),
      // hp: json[''],
      // downPayment: json[''],
      // description: json[''],
      // voucher: json[''],
      // dpNote: json[''],
      // cardType: json[''],
      // cardName: json[''],
      // cardNo: json[''],
      // cardApproval: json[''],
      // edcMachine: json[''],
    );
  }
}