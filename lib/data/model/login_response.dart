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

  factory LoginResponse.fromJson(Map<String, dynamic> json, String pass){
    if (json['state'] != true) {
      throw json['message'];
    }
    return LoginResponse(
      state: json['state'],
      isLoading: false,
      message: json['message'],
      data: UserDataModel.fromJson(json['data'], pass)
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
    this.pass = '',
    required this.outlet
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json, String pass)=>UserDataModel(
    userId: json['user_id'],
    level: json['level_user'],
    token: json['token'],
    pass: pass,
    outlet: json['outlet']
  );
}