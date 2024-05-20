class StringResponse{
  bool? state;
  String? message;
  String? data;

  StringResponse({
    this.state,
    this.message,
    this.data
  });

  factory StringResponse.fromJson(Map<String, dynamic>json){
    return StringResponse(
      state: json['state'],
      message: json['message'],
      data: json['data']
    );
  }
}