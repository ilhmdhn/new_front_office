import 'package:front_office_2/data/model/checkin_body.dart';
import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';
import 'package:front_office_2/tools/helper.dart';

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
  String roomType;
  String roomCode;
  String memberName;
  String memberCode;
  String roomAlias;
  int checkinMinute;
  int minuteRemaining;
  int hourRemaining;
  int pax;
  PromoRoomModel? promoRoom;
  PromoFnbModel? promoFnb;
  VoucherDetail? vcrDetail;
  String hp;
  String invoice;
  String reception;
  int downPayment;
  String description;
  String voucher;
  String dpNote;
  String cardType;
  String cardName;
  String guestNotes;
  String cardNo;
  String cardApproval;
  String edcMachine;

  DetailCheckinModel({
    this.roomType = '',
    this.roomCode = '',
    this.memberName = '',
    this.memberCode ='',
    this.roomAlias =' ',
    this.checkinMinute = 0,
    this.minuteRemaining = 0,
    this.hourRemaining = 0,
    this.pax = 0,
    this.promoRoom,
    this.promoFnb,
    this.vcrDetail,
    this.hp = '',
    this.downPayment = 0,
    this.description = '',
    this.invoice = '',
    this.reception = '',
    this.voucher = '',
    this.guestNotes = '',
    this.dpNote = '',
    this.cardType = '',
    this.cardName = '',
    this.cardNo = '',
    this.cardApproval = '',
    this.edcMachine = ''    
  });

  factory DetailCheckinModel.fromJson(Map<String, dynamic>json){
    return DetailCheckinModel(
      roomType: json['checkin_room']['jenis_kamar'],
      roomCode: json['room'],
      checkinMinute: json['checkin_room']['durasi_checkin'],
      memberName: json['checkin_room']['nama_member'],
      memberCode: json['checkin_room']['kode_member'],
      reception: json['checkin_room']['reception'],
      invoice: json['checkin_room']['invoice'],
      minuteRemaining: json['checkin_room']['sisa_menit_checkin'],
      hourRemaining: json['checkin_room']['sisa_jam_checkin'],
      pax: json['checkin_room']['qm3'],
      promoRoom: isNullOrEmpty(json['order_promo_room']) ? null: PromoRoomModel.fromJson(json['order_promo_room'][0]),
      promoFnb: isNullOrEmpty(json['order_promo_food'])? null: PromoFnbModel.fromJson(json['order_promo_food'][0]),
      vcrDetail:  VoucherDetail.fromJson(json['vcr_detail']),
      hp: json['checkin_room']['hp'],
      downPayment: json['checkin_room']['uang_muka'],
      description: json['checkin_room']['keterangan'],
      guestNotes: json['checkin_room']['keterangan_tamu'],
      voucher: json['checkin_room']['voucher'],
      dpNote: json['checkin_room']['nama_payment_uang_muka'],
      cardType: json['checkin_room']['input1_jenis_kartu'],
      cardName: json['checkin_room']['input2_nama'],
      cardNo: json['checkin_room']['input3_nomor_kartu'],
      cardApproval: json['checkin_room']['input4_nomor_approval'],
      edcMachine: json['checkin_room']['edc_machine_'],
    );
  }
}