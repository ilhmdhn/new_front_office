class ItemProductionResponse {
  bool state;
  String message;
  ItemProductionModel? data;

  ItemProductionResponse({
    required this.state,
    required this.message,
    this.data,
  });

  factory ItemProductionResponse.fromJson(Map<String, dynamic> json) {
    return ItemProductionResponse(
      state: json['state'],
      message: json['message'],
      data: json['data'] != null
          ? ItemProductionModel.fromJson(json['data'])
          : null,
    );
  }
}

class ItemProductionModel {
  String outletName;
  DateTime reportDate;
  String reportNo;
  List<ItemProductionGroupModel> groups;

  ItemProductionModel({
    required this.outletName,
    required this.reportDate,
    required this.reportNo,
    required this.groups,
  });

  factory ItemProductionModel.fromJson(Map<String, dynamic> json) {
    return ItemProductionModel(
      outletName: json['outlet_name'],
      reportDate: DateTime.parse(json['report_date']),
      reportNo: json['report_no'],
      groups: List<ItemProductionGroupModel>.from(
        (json['groups'] as List).map((x) => ItemProductionGroupModel.fromJson(x)),
      ),
    );
  }
}

class ItemProductionGroupModel {
  String name;
  List<ItemProductionDeptModel> depts;

  ItemProductionGroupModel({
    required this.name,
    required this.depts,
  });

  factory ItemProductionGroupModel.fromJson(Map<String, dynamic> json) {
    return ItemProductionGroupModel(
      name: json['name'],
      depts: List<ItemProductionDeptModel>.from(
        (json['depts'] as List).map((x) => ItemProductionDeptModel.fromJson(x)),
      ),
    );
  }
}

class ItemProductionDeptModel {
  String name;
  List<ItemProductionItemModel> items;

  ItemProductionDeptModel({
    required this.name,
    required this.items,
  });

  factory ItemProductionDeptModel.fromJson(Map<String, dynamic> json) {
    return ItemProductionDeptModel(
      name: json['name'],
      items: List<ItemProductionItemModel>.from(
        (json['items'] as List).map((x) => ItemProductionItemModel.fromJson(x)),
      ),
    );
  }
}

class ItemProductionItemModel {
  String name;
  int qty;

  ItemProductionItemModel({
    required this.name,
    required this.qty,
  });

  factory ItemProductionItemModel.fromJson(Map<String, dynamic> json) {
    return ItemProductionItemModel(
      name: json['name'],
      qty: json['qty'] ?? 0,
    );
  }
}
