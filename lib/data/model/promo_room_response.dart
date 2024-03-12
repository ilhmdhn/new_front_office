class PromoRoomResponse{
  bool isLoading;
  bool? state;
  String? message;
  List<PromoRoomModel> data;

  PromoRoomResponse({
    this.isLoading = true,
    this.state,
    this.message,
    this.data = const[]
  });

  factory PromoRoomResponse.fromJson(Map<String, dynamic> json){
    return PromoRoomResponse(
      isLoading: false,
      state: json['state'],
      message: json['message'],
      data: List<PromoRoomModel>.from(
        (json['data'] as List).map((e) => PromoRoomModel.fromJson(e))
      ),
    );
  }
}

class PromoRoomModel{
  String? promoName;
  int? promoPercent;
  int? promoIdr;
  String? timeStart;
  int? finishDate;
  String? timeFinish;

  PromoRoomModel({
    this.promoName, 
    this.promoPercent,  
    this.promoIdr,
    this.timeStart, 
    this.finishDate, 
    this.timeFinish
  });

  factory PromoRoomModel.fromJson(Map<String, dynamic>json){
    return PromoRoomModel(
      promoName: json['promo_room'],
      promoPercent: json['diskon_persen'],
      promoIdr: json['diskon_rp'],
      timeStart: json['time_start'],
      finishDate: json['date_finish'],
      timeFinish: json['time_finish']
    );
  }
}