import 'dart:io' show Platform;

class VersionResponse{
  bool state;
  String message;
  int option;
  int force;
  String url;
  String desc;
  
  VersionResponse({
    required this.state,
    required this.message,
    required this.option,
    required this.force,
    required this.url,
    required this.desc
  });

  factory VersionResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return VersionResponse(
      state: json['state'],
      message: json['message'],
      option: Platform.isAndroid
          ? data['android_version_optional']
          : data['ios_version_optional'],
      force: Platform.isAndroid
          ? data['android_force_update']
          : data['ios_force_update'],
      url: Platform.isAndroid
          ? data['android_url']
          : data['ios_url'],
      desc: data['update_description'],
    );
  }
}