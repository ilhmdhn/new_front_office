import 'package:front_office_2/data/model/order_response.dart';

class PostSoResponse{
  bool state;
  String? message;
  List<OrderedModel>? data;
  String? checkerIp;
  String? checkerPort;

  PostSoResponse({
    required this.state,
    required this.message,
    this.data,
    this.checkerIp,
    this.checkerPort
  });

  factory PostSoResponse.fromJson(Map<String, dynamic> json) {
    return PostSoResponse(
      state: json['state'],
      message: json['message'],
      data: (json['data'] as List)
          .map((x) => OrderedModel.fromJson(x))
          .toList(),
      checkerIp: json['checker_ip'],
      checkerPort: json['checker_port']
    );
  }
}