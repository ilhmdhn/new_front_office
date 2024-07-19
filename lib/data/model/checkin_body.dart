class CheckinBody{
  String chusr;
  int hour;
  int minute;
  int pax;
  CheckinRoom? checkinRoom;
  CheckinRoomType? checkinRoomType;
  Visitor? visitor;

  CheckinBody({
    this.chusr = '',
    this.hour = 0,
    this.minute = 0,
    this.pax = 0,
    this.checkinRoom,
    this.checkinRoomType,
    this.visitor
  });
}


class CheckinRoom{
  String room;

  CheckinRoom({
    this.room = ''
  });
}

class CheckinRoomType{
  int roomCapacity;
  String roomType;
  bool isRoomCheckin;

  CheckinRoomType({
    this.roomCapacity = 0,
    this.roomType = '',
    this.isRoomCheckin = false
  });
}

class Visitor{
  String? memberCode;
  String? memberName;

  Visitor({
    this.memberCode, 
    this.memberName
  });
}

class VoucherDetail{
  String code;
  String expired;
  int hour;
  int hourPrice;
  int hourPercent;
  String item;
  int itemPrice;
  int itemPercent;
  num price;
  
  VoucherDetail({
    required this.code,
    this.expired = '',
    this.hour = 0,
    this.hourPrice = 0,
    this.hourPercent = 0,
    this.item = '',
    this.itemPrice = 0,
    this.itemPercent = 0,
    this.price = 0,
  });
}

class EditCheckinBody{
  String room;
  int pax;
  String hp;
  String dp;
  String description;
  String event;
  String chusr;
  String voucher;
  String dpNote;
  String cardType;
  String cardName;
  String cardNo;
  VoucherDetail? voucherDetail;
  String cardApproval;
  String edcMachine;
  String memberCode;
  List<String> promo;

  EditCheckinBody({
    this.room = '',//
    this.pax = 1,//
    this.hp = '',//
    this.dp = '',//
    this.description = '',//
    this.event = '',//
    this.chusr = '',
    this.voucher = '',//
    this.voucherDetail,
    this.dpNote = '',//
    this.cardType = '',
    this.cardName = '',
    this.cardNo = '',
    this.cardApproval = '',
    this.edcMachine = '',
    this.memberCode = '',
    this.promo = const []
  });
}

class GenerateVoucherParams{
  Map<String, dynamic> execute(VoucherDetail data){
    return <String, dynamic>{
      'code': data.code,
      'expired': data.expired,
      'hour': data.hour,
      'hour_price': data.hourPrice,
      'hour_percent': data.hourPercent,
      'item': data.item,
      'item_price': data.itemPrice,
      'item_percent': data.itemPercent,
      'price': data.price
    };
  }
}

class GenerateCheckinParams{
  Map<String, dynamic> checkinBodyRequest(CheckinBody checkinData){
    return <String, dynamic> {
      'checkin_room': <String, dynamic>{
        'kamar': checkinData.checkinRoom?.room,
      },
      'checkin_room_type': <String, dynamic>{
        'kapasitas': checkinData.checkinRoomType?.roomCapacity,
        'jenis_kamar': checkinData.checkinRoomType?.roomType,
        'kamar_untuk_checkin': checkinData.checkinRoomType?.isRoomCheckin
      },
      'visitor': <String, dynamic>{
        'member': checkinData.visitor?.memberCode,
        'nama_lengkap': checkinData.visitor?.memberName
      },
      'chusr': checkinData.chusr,
      'durasi_jam': checkinData.hour,
      'durasi_menit': checkinData.minute,
      'pax': checkinData.pax,
    }; 
  }


  Map<String, dynamic> editCheckinBodyRequest(EditCheckinBody checkinData){
    return<String, dynamic>{
      'room': checkinData.room,
      'qm1':  '0',
      'qm2':  '0',
      'qm3':  checkinData.pax.toString(),
      'qm4':  '0',
      'qf1':  '0',
      'qf2':  '0',
      'qf3':  '0',
      'qf4':  '0',
      'hp': checkinData.hp,
      'uang_muka':  checkinData.dp,
      'keterangan': checkinData.description,
      'event_acara':  checkinData.event,
      'event_owner':  '',
      'chusr':  checkinData.chusr,
      'voucher':  checkinData.voucher,
      'voucher_detail': checkinData.voucherDetail == null? null: GenerateVoucherParams().execute(checkinData.voucherDetail!),
      'keterangan_payment_uang_muka': checkinData.dpNote,
      'input1_jenis_kartu': checkinData.cardType,
      'input2_nama':  checkinData.cardName,
      'input3_nomor_kartu': checkinData.cardNo,
      'input4_nomor_approval':  checkinData.cardApproval,
      'edc_machine':  checkinData.edcMachine,
      'member_ref': checkinData.memberCode,
      'promo': checkinData.promo
    };
  }
}