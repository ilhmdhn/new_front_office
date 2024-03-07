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
}