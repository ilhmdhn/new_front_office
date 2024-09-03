class RequestApprovalResponse{
  bool state;
  String message;
  List<ApprovalRequestModel> data;

  RequestApprovalResponse({
    this.state =  false,
    this.message = '',
    this.data = const [] 
  });

  factory RequestApprovalResponse.fromJson(Map<String, dynamic>json){
    return RequestApprovalResponse(
      state: json['state'],
      message: json['message'],
      data: List<ApprovalRequestModel>.from(
        (json['data'] as List).map((x) => ApprovalRequestModel.fromJson(x))
      ),
    );
  }
}

class ApprovalRequestModel{
  String idApproval;
  String user;
  String reason;
  String reception;
  String room;
  String note;

  ApprovalRequestModel({
    this.idApproval = '',
    this.user = '',
    this.reception = '',
    this.reason = '',
    this.room = '',
    this.note = ''
  });

  factory ApprovalRequestModel.fromJson(Map<String, dynamic>json){
    return ApprovalRequestModel(
      idApproval: json['id_approval'],
      user: json['user'],
      reception: json['reception'],
      room: json['room'],
      reason: json['reason'],
      note: json['note']
    );
  }
}