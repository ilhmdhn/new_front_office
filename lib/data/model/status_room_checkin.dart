class RoomCheckinState{
  bool state;
  String? message;
  List<RoomCheckinStateModel>? data;

  RoomCheckinState({
    required this.state,
    this.message,
    this.data
  });

  factory RoomCheckinState.fromJson(Map<String, dynamic>json){
    return RoomCheckinState(
      state: json['state'],
      message: json['message'],
      data: List<RoomCheckinStateModel>.from(
        (json['data'] as List).map((e) => RoomCheckinStateModel.fromJson(e)))
      );
  }
}

class RoomCheckinStateModel{
  String room;
  String state;
  int so;
  int delivery;
  int cancel;
  int process;

  RoomCheckinStateModel({
    required this.room,
    this.state = '0',
    this.so = 0,
    this.delivery = 0,
    this.cancel = 0,
    this.process = 0,
  });

  factory RoomCheckinStateModel.fromJson(Map<String, dynamic> json){
    final soList = json['order_inventory'];
    num soCount = 0;
    
    for(var so in soList){
      soCount += so['qty'];
    }

    return RoomCheckinStateModel(
      room: json['room'],
      state: json['status_print'],
      so: soCount.toInt()
    );
  }
}