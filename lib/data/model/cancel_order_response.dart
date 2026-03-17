class CancelOrderResponse {
  bool state;
  String message;
  List<CancelOrderModel>? data;

  CancelOrderResponse({
    required this.state,
    required this.message,
    this.data
  });

  factory CancelOrderResponse.fromJson(Map<String, dynamic>json){
    return CancelOrderResponse(
      state: json['state'], 
      message: json['message'],
      data: List<CancelOrderModel>.from(
        (json['data'] as List).map((x) => CancelOrderModel.fromJson(x))
      )
    );
  }
}

class CancelOrderModel{
  String cancelCode;
  String inventoryCode;
  String name;
  num price;
  int cancelQty;
  num total;
  String orderCode;
  String slipCode;
  DateTime date;
  String user;
  String room;

  CancelOrderModel({
    required this.cancelCode,
    required this.inventoryCode,
    required this.name,
    required this.price,
    required this.cancelQty,
    required this.total,
    required this.orderCode,
    required this.slipCode,
    required this.date,
    required this.user,
    required this.room
  });

  factory CancelOrderModel.fromJson(Map<String, dynamic>json){
    return CancelOrderModel(
      cancelCode: json['cancel_code'], 
      inventoryCode: json['inventory_code'], 
      name: json['name'], 
      price: json['price'], 
      cancelQty: json['cancel_qty'], 
      total: json['total'], 
      orderCode: json['order_code'], 
      slipCode: json['slip_code'], 
      date: json['date'] != null? DateTime.parse(json['date']): DateTime.now(),
      user: json['user'], 
      room: json['room']
    );
  }
}











