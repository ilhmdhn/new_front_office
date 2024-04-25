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
  String? invCode;
  int? qty;
  String? idGlobal;
  int? location;
  String? orderState;
  String? name;
  String? notes;
  num? price;

  OrderedModel({
    this.sol,
    this.invCode,
    this.qty,
    this.idGlobal,
    this.location,
    this.orderState,
    this.name,
    this.notes,
    this.price
  });

  factory OrderedModel.fromJson(Map<String, dynamic>json){
    return OrderedModel(
      sol: json['order_sol'],
      invCode: json['order_inventory'],
      qty: json['order_quantity'],
      orderState: json['order_state'],
      idGlobal: json['order_inventory_id_global'],
      location: json['order_location'],
      name: json['order_inventory_nama'],
      notes: json['order_notes'],
      price: json['order_price']
    );
  }
}