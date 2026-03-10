class StationResponse {
  bool state;
  String message;
  List<StationModel>? data;

  StationResponse({
    required this.state,
    required this.message,
    required this.data,
  });

  factory StationResponse.fromJson(Map<String, dynamic> json) {
    return StationResponse(
      state: json['state'],
      message: json['message'],
      data: List<StationModel>.from(json['data'].map((x) => StationModel.fromJson(x))),
    );
  }
}

class StationModel{
  int id;
  String name;

  StationModel({
    required this.id,
    required this.name,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'],
      name: json['name'],
    );
  }
}