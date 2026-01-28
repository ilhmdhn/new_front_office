class CallServiceHistoryResponse{
  bool isLoading;
  bool? state;
  String? message;
  List<CallServiceHistory> data;

  CallServiceHistoryResponse({
    this.isLoading = true,
    this.state,
    this.message,
    this.data = const []
  });

  factory CallServiceHistoryResponse.fromJson(Map<String, dynamic> json){
    if(json["state"] != true){
      throw json['message'];
    }

    return CallServiceHistoryResponse(
      isLoading: false,
      state: true,
      message: json['message'],
      data: List<CallServiceHistory>.from(
        (json['data']??[]).map((x) => CallServiceHistory.fromJson(x))
      )
    );
  }
}

class CallServiceHistory{
  int isNow;
  String roomCode;
  String callTime;
  String? callResponse;
  String? responsedBy;
/*
            "is_now": 0,
            "reception": "RCP-2512110001",
            "notif_type": 1,
            "room": "R05",
            "description": "Service room ditanggapi",
            "user": "KASIR",
            "call_time": "10:41",
            "call_response": "10:54"
 */
  CallServiceHistory({
    required this.isNow,
    required this.roomCode,
    required this.callTime,
    this.callResponse,
    this.responsedBy
  });

  factory CallServiceHistory.fromJson(Map<String, dynamic>json)=>CallServiceHistory(
    isNow: json['is_now'],
    roomCode: json['room'],
    callTime: json['call_time'],
    callResponse: json['call_response'],
    responsedBy: json['user']
  );
}