class RoomCheckinResponse{
  bool state;
  String message;
  List<ListRoomCheckinModel> data;

  RoomCheckinResponse({
    this.state = false,
    this.message = '',
    this.data = const []
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
  String memberName;
  String printState;

  ListRoomCheckinModel({
    this.room = '',
    this.remainTime = 0,
    this.memberName = '',
    this.printState = '0'
  });

  factory ListRoomCheckinModel.fromJson(Map<String, dynamic>json){
    return ListRoomCheckinModel(
      room: json['kamar'],
      remainTime: json['sisa_checkin'],
      memberName: json['nama_member'],
      printState: json['status_print'],
    );
  }
}