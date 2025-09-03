class FnBResultModel {
  bool isLoading;
  bool? state;
  String? message;
  List<FnBModel>? data = List.empty();

  FnBResultModel({this.isLoading = true, this.state, this.message, this.data});

  factory FnBResultModel.fromJson(Map<String, dynamic> json) {
    if (json['state'] != true) {
      throw json['message'];
    }
    return FnBResultModel(
        isLoading: false,
        state: true,
        message: json['message'],
        data:
            List<FnBModel>.from(
              (json['data'] as List).map((x) => FnBModel.fromJson(x))));
  }
}

class FnBModel{
  String? invCode;
  String? name;
  num? price;
  int? location;
  String? globalId;

  FnBModel({
    this.invCode = '',
    this.name = '',
    this.price = 0,
    this.location = 0,
    this.globalId = '',
  });

  factory FnBModel.fromJson(Map<String, dynamic>json){
    return FnBModel(
      invCode: json['inventory_code'],
      name: json['name'],
      price: json['price'],
      location: json['location'],
      globalId: json['inventory_global_id']
    );
  }
}

class SendOrderModel{
  String invCode;
  int qty;
  String note;
  num price;
  String name;
  int location;

  SendOrderModel({
    this.invCode = '',
    this.qty = 1,
    this.note = '',
    this.price = 0,
    this.name = '',
    this.location = 1,
  });
}