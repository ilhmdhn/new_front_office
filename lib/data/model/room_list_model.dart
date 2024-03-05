class RoomListModel{
  bool isLoading;
  bool? state;
  String? message;
  List<RoomModel> data;

  RoomListModel({
    this.isLoading = true,
    this.state,
    this.message,
    this.data = const []
  });

  factory RoomListModel.fromJson(Map<String, dynamic> json){
    if(json['state'] != true){
      throw json['message'];
    }

    return RoomListModel(
      isLoading: false,
      state: true,
      message: json['message'],
      data: List<RoomModel>.from(
        (json['data'] as List).map((x) => RoomListModel.fromJson(x))
      )
    );
  }
}

class RoomModel{
  String? roomCode;
  String? roomName;
  int? roomCapacity;

  RoomModel({
    this.roomCode,
    this.roomName,
    this.roomCapacity
  });

  factory RoomModel.fromJson(Map<String, dynamic>json)=>RoomModel(
    roomCode: json['kamar'],
    roomName: json['kamar_alias'],
    roomCapacity: json['kapasitas']
  );
}