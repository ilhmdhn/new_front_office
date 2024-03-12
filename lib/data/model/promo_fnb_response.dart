class PromoFnbResponse{
  bool isLoading; 
  bool? state;
  String? message;
  List<PromoFnbModel> data;

  PromoFnbResponse({
    this.isLoading = true,
    this.state,
    this.message,
    this.data = const[]
  });

  factory PromoFnbResponse.fromJson(Map<String, dynamic>json){
    return PromoFnbResponse(
      isLoading: false,
      state: json['state'],
      message: json['message'],
      data: List<PromoFnbModel>.from((json['data'] as List).map((e) => PromoFnbModel.fromJson(e)))
    );
  }
}

class PromoFnbModel{
  String? promoName;
  int? minimumHour;
  String? inventory;
  int? promoPercent;
  int? promoIdr;
  String? timeStart;
  int? finishDate;
  int? specialItem;
  String? timeFinish;

  PromoFnbModel({
    this.promoName,
    this.minimumHour,
    this.inventory,
    this.promoPercent,
    this.promoIdr,
    this.timeStart,
    this.specialItem,
    this.finishDate,
    this.timeFinish,
  });

  factory PromoFnbModel.fromJson(Map<String, dynamic>json){
    return PromoFnbModel(
      promoName: json['promo_food'],
      minimumHour: json['syarat_jam'],
      inventory: json['inventory'],
      specialItem: json['khusus'],
      promoPercent: json['diskon_persen'],
      promoIdr: json['diskon_rp'],
      timeStart: json['time_start'],
      finishDate: json['date_finish'],
      timeFinish: json['time_finish'],      
    );
  }
}