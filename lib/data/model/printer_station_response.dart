class PrinterStationResponse {
  bool state;
  String message;
  List<PrinterStationModel>? data;

  PrinterStationResponse({
    required this.state,
    required this.message,
    this.data
  });

  factory PrinterStationResponse.fromJson(Map<String, dynamic>json){
    return PrinterStationResponse(
      state: json['state'], 
      message: json['message'],
      data: List<PrinterStationModel>.from(json['data'].map((x) => PrinterStationModel.fromJson(x)))
    );
  }
}

class PrinterStationModel{
  int id;
  String name;
  String ipAddress;
  String port;

  PrinterStationModel({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.port
  });

  factory PrinterStationModel.fromJson(Map<String, dynamic>json){
    return PrinterStationModel(
      id: json['id'], 
      name: json['name'], 
      ipAddress: json['ip_address'], 
      port: json['forwarder_port']
    );
  }
}