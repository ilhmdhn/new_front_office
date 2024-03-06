class BaseResponse{
  bool isLoading;
  bool? state;
  String? message;

  BaseResponse({
    this.isLoading = true,
    this.state,
    this.message
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json){
    return BaseResponse(
      isLoading: false,
      state: json['state'],
      message: json['message']
    );
  }
}