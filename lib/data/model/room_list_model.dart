class RoomListResponse{
  bool isLoading;
  bool? state;
  String? message;
  List<RoomModel> data;

  RoomListResponse({
    this.isLoading = true,
    this.state,
    this.message,
    this.data = const []
  });

  factory RoomListResponse.fromJson(Map<String, dynamic> json){
    if(json["state"] != true){
      throw json['message'];
    }

    return RoomListResponse(
      isLoading: false,
      state: true,
      message: json['message'],
      data: List<RoomModel>.from(
        (json['data'] as List).map((x) => RoomModel.fromJson(x))
      )
    );
  }
}

class RoomModel{
  String? roomCode;
  String? roomName;
  int? roomCapacity;
  bool? isRoomCheckin;

  RoomModel({
    this.roomCode,
    this.roomName,
    this.roomCapacity,
    this.isRoomCheckin
  });

  factory RoomModel.fromJson(Map<String, dynamic>json)=>RoomModel(
    roomCode: json['kamar'],
    roomName: json['kamar_alias'],
    roomCapacity: json['kapasitas'],
    isRoomCheckin: json['status_kamar_ready_untuk_checkin']
  );
}