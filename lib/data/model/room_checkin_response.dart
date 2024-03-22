class RoomCheckinResponse{
  bool state;
  String message;
  List<ListRoomCheckinModel>? data;

  RoomCheckinResponse({
    this.state = false,
    this.message = '',
    this.data
  });

  factory RoomCheckinResponse.fromJson(Map<String, dynamic>json){
    return RoomCheckinResponse(
      state: json['state'],
      message: json['message'],
      data: List<ListRoomCheckinModel>.from(
        (json['data'] as List).map((x) => ListRoomCheckinModel.fromJson(x))
      )
    );
  }
}

class ListRoomCheckinModel{
  String room;
  int remainTime;
  int remainHour;
  int remainMinute;
  String memberName;
  String printState;
  String summaryCode;

  ListRoomCheckinModel({
    this.room = '',
    this.remainTime = 0,
    this.remainHour = 0,
    this.remainMinute = 0,
    this.memberName = '',
    this.summaryCode = '',
    this.printState = '0'
  });

  factory ListRoomCheckinModel.fromJson(Map<String, dynamic>json){
    return ListRoomCheckinModel(
      room: json['kamar'],
      remainTime: json['sisa_checkin'],
      remainHour: json['sisa_jam_checkin'],
      remainMinute: json['sisa_menit_checkin'],
      memberName: json['nama_member'],
      printState: json['status_print'],
      summaryCode: json['summary'],
    );
  }
}