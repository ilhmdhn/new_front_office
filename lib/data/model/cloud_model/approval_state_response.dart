class ApprovalStateResponse{
  bool? state;
  String? message;
  ApprovalStateModel? data;

  ApprovalStateResponse({
    this.state,
    this.message,
    this.data,
  });

  factory ApprovalStateResponse.fromJson(Map<String, dynamic> json){
    return ApprovalStateResponse(
      state: json['state'],
      message: json['message'],
      data: json['data'] != null ? ApprovalStateModel.fromJson(json['data']) : null 
    );
  }
}

class ApprovalStateModel{
  int id;
  String outlet;
  String idApproval;
  String user;
  String room;
  String reception;
  String note;
  String state;
  String reason;
  String approver;
  String createdAt;

  ApprovalStateModel({
    required this.id,
    required this.outlet,
    required this.idApproval,
    required this.user,
    required this.room,
    required this.reception,
    required this.note,
    required this.state,
    required this.reason,
    required this.approver,
    required this.createdAt,
  });

  factory ApprovalStateModel.fromJson(Map<String, dynamic> json){
    return ApprovalStateModel(
      id: json['id'],
      outlet: json['outlet'],
      idApproval: json['id_approval'],
      user: json['user'],
      room: json['room'],
      reception: json['reception'],
      note: json['note'],
      state: json['state'],
      reason: json['reason'] ?? '',
      approver: json['approver'] ?? '',
      createdAt: json['createdAt']
    );
  }
}