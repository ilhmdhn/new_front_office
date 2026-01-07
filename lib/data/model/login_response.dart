class LoginResponse{
  bool isLoading;
  bool? state;
  String? message;
  UserDataModel? data;

  LoginResponse({
    this.isLoading = true,
    this.state,
    this.message,
    this.data
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    if (json['state'] != true) {
      throw json['message'];
    }
    return LoginResponse(
      state: json['state'],
      isLoading: false,
      message: json['message'],
      data: UserDataModel.fromJson(json['data'])
    );
  }
}

class UserDataModel{
  String userId;
  String level;
  String token;
  String pass;
  String outlet;

  UserDataModel({
    required this.userId,
    required this.level,
    required this.token,
    required this.pass,
    required this.outlet
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json)=>UserDataModel(
    userId: json['user_id'],
    level: json['level_user'],
    token: json['token'],
    pass: json['pass'],
    outlet: json['outlet']
  );
}