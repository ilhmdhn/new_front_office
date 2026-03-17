class OrderOldRoomResponse{
  bool? state;
  String? message;
  List<OldRoomModel>? data;
  
  OrderOldRoomResponse({
    this.state,
    this.message,
    this.data,
  });

  factory OrderOldRoomResponse.fromJson(Map<String, dynamic>json){
    if(json['state'] != true){
      throw json['message'];
    }
    
    return OrderOldRoomResponse(
      state: json['state'],
      message: json['message'],
      data: List<OldRoomModel>.from(
        (json['data'] as List).map((x) => OldRoomModel.fromJson(x))
      )
    );
  }
}

class OldRoomModel{
  String orderCode;
  String roomCode;
  num total;
  num disc;
  num service;
  String rcpCode;
  num tax;
  DateTime date;
  List<OldRoomOrderDataModel> data;

  OldRoomModel({
    required this.orderCode,
    required this.roomCode,
    required this.total,
    required this.disc,
    required this.service,
    required this.rcpCode,
    required this.tax,
    required this.date,
    required this.data,
  });

  factory OldRoomModel.fromJson(Map<String, dynamic>json){
    return OldRoomModel(
      orderCode: json['order_code']??'',
      roomCode: json['room']??'', 
      total: json['total']??0, 
      disc: json['discount']??0, 
      service: json['service']??0, 
      rcpCode: json['rcp_code']??'', 
      tax: json['tax']??0, 
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      data: List<OldRoomOrderDataModel>.from(
        (json['okd'] as List).map((x) => OldRoomOrderDataModel.fromJson(
          x, 
          json['room']??'',
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
          json['user']??'',
          json['rcp_code']??''
        ))
      )
    );
  }
}

class OldRoomOrderDataModel{
  String inventoryCode;
  String name;
  String slipOrder;
  String orderCode;
  num price;
  String note;
  int qty;
  num total;
  DateTime date;
  String roomCode;
  String user;
  String rcpCode;

  OldRoomOrderDataModel({
    required this.inventoryCode,
    required this.name,
    required this.slipOrder,
    required this.orderCode,
    required this.date,
    required this.price,
    required this.note,
    required this.qty,
    required this.total,
    required this.roomCode,
    required this.user,
    required this.rcpCode
  });

  factory OldRoomOrderDataModel.fromJson(Map<String, dynamic>json, String roomCode, DateTime date, String user, String rcp){
    return OldRoomOrderDataModel(
      inventoryCode: json['inventory_code']??'', 
      name: json['name']??'', 
      slipOrder: json['slip_order_code']??'', 
      price: json['price']??0, 
      note: json['note']??'', 
      qty: json['qty']??0, 
      total: json['total']??0,
      orderCode: json['order_code']??'',
      date: date,
      roomCode: roomCode,
      user: user,
      rcpCode: rcp
    );
  }
}