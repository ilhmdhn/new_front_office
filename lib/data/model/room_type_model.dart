class ListRoomTypeReadyResponse{
  bool isLoading;
  bool? state;
  String? message;
  List<RoomTypeReadyData> data;

  ListRoomTypeReadyResponse({
    this.isLoading = true,
    this.state,
    this.message,
    this.data = const [],
  });

  factory ListRoomTypeReadyResponse.fromJson(Map<String, dynamic> json){
    if(json['state'] != true){
      throw json['message'];
    }

    return ListRoomTypeReadyResponse(
      isLoading: false,
      state: true,
      message: json['message'],
      data: List<RoomTypeReadyData>.from(
          (json['data'] as List).map((x) => RoomTypeReadyData.fromJson(x)))
    );
  }
}

class RoomTypeReadyData{
  String? roomType;
  int? roomAvailable;

  RoomTypeReadyData({
    this.roomType,
    this.roomAvailable
  });

  factory RoomTypeReadyData.fromJson(Map<String, dynamic>json)=>RoomTypeReadyData(
    roomType: json['jenis_kamar'],
    roomAvailable: json['jumlah_available']
  );
}