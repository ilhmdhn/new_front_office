class EdcResponse{
  bool isLoading;
  bool? state;
  String? message;
  List<EdcDataModel> data;

  EdcResponse({
    this.isLoading = true,
    this.state,
    this.message,
    this.data = const []
  });

  factory EdcResponse.fromJson(Map<String, dynamic> json){
    return EdcResponse(
      isLoading: false,
      state: json['state'],
      message: json['message'],
      data: List<EdcDataModel>.from(
        (json['data'] as List).map((x) => EdcDataModel.fromJson(x))
      )
    );
  }
}

class EdcDataModel{
  int? edcNumber;
  String? edcName;
  int? isActive;

  EdcDataModel({
    this.edcNumber,
    this.edcName,
    this.isActive
  });

  factory EdcDataModel.fromJson(Map<String, dynamic>json){
    return EdcDataModel(
      edcNumber: json['nomor_edc'],
      edcName: json['nama_mesin'],
      isActive: json['status_aktif'],
    );
  }
}