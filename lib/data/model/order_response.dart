class OrderResponse{
  bool? state;
  String? message;
  List<OrderedModel>? data;
  
  OrderResponse({
    this.state,
    this.message,
    this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic>json){
    if(json['state'] != true){
      throw json['message'];
    }
    
    return OrderResponse(
      state: json['state'],
      message: json['message'],
      data: List<OrderedModel>.from(
        (json['data'] as List).map((x) => OrderedModel.fromJson(x))
    ));
  }
}

class OrderedModel{
  String? sol;
  String? okl;
  String? invCode;
  int? qty;
  String? idGlobal;
  int? queue;
  int? location;
  String? orderState;
  int? cancelQty;
  String? name;
  String? notes;
  num? price;
  num? realPrice;
  String? printerIP;
  String? forwarderPORT;
  String? stationName;
  String? user;
  DateTime? deliveredAt;
  String? roomCode;

  OrderedModel({
    this.sol,
    this.okl,
    this.invCode,
    this.qty,
    this.queue,
    this.idGlobal,
    this.location,
    this.orderState,
    this.cancelQty,
    this.name,
    this.notes,
    this.price,
    this.realPrice,
    this.printerIP,
    this.forwarderPORT,
    this.stationName,
    this.user,
    this.deliveredAt,
    this.roomCode
  });

  factory OrderedModel.fromJson(Map<String, dynamic>json){
    return OrderedModel(
      sol: json['order_sol'],
      okl: json['order_code'],
      invCode: json['order_inventory'],
      queue: json['order_urutan'],
      qty: json['order_quantity'],
      orderState: json['order_state'],
      cancelQty: json['order_qty_cancel'],
      idGlobal: json['order_inventory_id_global'],
      location: json['order_location'],
      name: json['order_inventory_nama'],
      notes: json['order_notes'],
      price: json['order_price'],
      printerIP: json['printer_ip_address'],
      forwarderPORT: json['printer_port'],
      stationName: json['station_name'],
      user: json['order_user'],
      realPrice: json['real_price']??0,
      deliveredAt: json['order_date_terkirim'] != null ? DateTime.parse(json['order_date_terkirim']) : null,
      roomCode: json['order_room_rcp']
    );
  }
}