import 'package:front_office_2/data/model/bill_response.dart';

class SolResponse{
  bool state;
  String? message;
  SolPrintModel? data;

  SolResponse({
    required this.state,
    required this.message,
    this.data
  });

  factory SolResponse.fromJson(Map<String, dynamic>json){
    return SolResponse(
      state: json['state'], 
      message: json['message'], 
      data: SolPrintModel.fromJson(json['data'])
    );
  }
}

class SolPrintModel{
  OutletModel outlet;
  List<SolModel> solList;

  SolPrintModel({
    required this.outlet,
    required this.solList
  });

  factory SolPrintModel.fromJson(Map<String, dynamic>json){
    return SolPrintModel(
      outlet: OutletModel.fromJson(json['outlet']), 
      solList: List<SolModel>.from(
        (json['sod'] as List).map((e) => SolModel.fromJson(e)))
    );
  }
}

class SolModel{
  String name;
  int qty;
  String? note;

  SolModel({
    required this.name,
    required this.qty,
    this.note,
  });

  factory SolModel.fromJson(Map<String, dynamic>json){
    return SolModel(
      name: json['name'], 
      qty: json['qty'],
      note: json['note']);
  }
}