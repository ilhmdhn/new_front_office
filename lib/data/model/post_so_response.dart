import 'package:front_office_2/data/model/order_response.dart';

class PostSoResponse{
  bool state;
  String? message;
  List<OrderedModel>? data;

  PostSoResponse({
    required this.state,
    required this.message,
    this.data
  });

  factory PostSoResponse.fromJson(Map<String, dynamic> json) {
    return PostSoResponse(
      state: json['state'],
      message: json['message'],
      data: (json['data'] as List)
          .map((x) => OrderedModel.fromJson(x))
          .toList(),
    );
  }
}

// class PostSolModel{
//   String solCode;
//   String name;
//   String inventory;
//   int qty;

//   PostSolModel({
//     required this.solCode,
//     required this.name,
//     required this.inventory,
//     required this.qty
//   });

//   factory PostSolModel.fromJson(Map<String, dynamic>json){
//     return PostSolModel(
//       solCode: json['order_sol'], 
//       name: json['order_inventory_nama'],
//       inventory: json['order_inventory'],
//       qty: json['order_quantity']
//     );
//   }
// }