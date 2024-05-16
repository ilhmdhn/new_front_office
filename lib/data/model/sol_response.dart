class SolResponse{
  bool state;
  String? message;
  List<SolModel>? data = List.empty();

  SolResponse({
    required this.state,
    required this.message,
    required this.data
  });

  factory SolResponse.fromJson(Map<String, dynamic>json){
    return SolResponse(
      state: json['state'], 
      message: json['message'], 
      data: List<SolModel>.from(
        (json['data'] as List).map((e) => SolModel.fromJson(e)))
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