class CekMemberResponse{
  bool isLoading;
  bool? state;
  String? message;
  MemberDataModel? data;

  CekMemberResponse({
    this.isLoading = true,
    this.state,
    this.message,
    this.data
  });

  factory CekMemberResponse.fromJson(Map<String, dynamic> json){
    return CekMemberResponse(
      isLoading: false,
      state: json['state'],
      message: json['message'],
      data: MemberDataModel.fromJson(json['data'])
    );
  }
}

class MemberDataModel{
  String? memberCode;
  String? fullName;
  String? memberType;
  num? point;

  MemberDataModel({
    this.memberCode,
    this.fullName,
    this.memberType,
    this.point
  });

  factory MemberDataModel.fromJson(Map<String, dynamic>?json)=>MemberDataModel(
    memberCode: json?['member'],
    fullName: json?['nama_lengkap'],
    memberType: json?['jenis_member'],
    point: json?['point_reward']
  );
}