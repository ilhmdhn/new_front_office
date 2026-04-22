class XSalesReportResponse {
  bool state;
  String message;
  XSalesReportModel? data;

  XSalesReportResponse({
    required this.state,
    required this.message,
    this.data,
  });

  factory XSalesReportResponse.fromJson(Map<String, dynamic> json) {
    return XSalesReportResponse(
      state: json['state'],
      message: json['message'],
      data: json['data'] != null ? XSalesReportModel.fromJson(json['data']) : null,
    );
  }
}

class XSalesReportModel {
  String outletName;
  String reportTitle;
  DateTime reportDate;
  String reportNo;
  String group;

  XSalesSummaryModel summary;
  List<XSalesItemModel> paymentMedia;
  XSalesTotalsModel totals;
  XSalesVoidModel voidData;
  XSalesSettlementModel settlement;
  XSalesTaxNetModel taxNet;
  XSalesBillsModel bills;
  XSalesGroupModel groupSales;
  XSalesGroupModel groupFoc;
  List<XSalesItemModel> salesCategory;
  XSalesDiscountModel discount;
  num salesCash;

  XSalesReportModel({
    required this.outletName,
    required this.reportTitle,
    required this.reportDate,
    required this.reportNo,
    required this.group,
    required this.summary,
    required this.paymentMedia,
    required this.totals,
    required this.voidData,
    required this.settlement,
    required this.taxNet,
    required this.bills,
    required this.groupSales,
    required this.groupFoc,
    required this.salesCategory,
    required this.discount,
    required this.salesCash,
  });

  factory XSalesReportModel.fromJson(Map<String, dynamic> json) {
    return XSalesReportModel(
      outletName: json['outlet_name'],
      reportTitle: json['report_title'],
      reportDate: DateTime.parse(json['report_date']),
      reportNo: json['report_no'],
      group: json['group'],
      summary: XSalesSummaryModel.fromJson(json['summary']),
      paymentMedia: List<XSalesItemModel>.from(
        (json['payment_media'] as List).map((x) => XSalesItemModel.fromJson(x)),
      ),
      totals: XSalesTotalsModel.fromJson(json['totals']),
      voidData: XSalesVoidModel.fromJson(json['void']),
      settlement: XSalesSettlementModel.fromJson(json['settlement']),
      taxNet: XSalesTaxNetModel.fromJson(json['tax_net']),
      bills: XSalesBillsModel.fromJson(json['bills']),
      groupSales: XSalesGroupModel.fromJson(json['group_sales']),
      groupFoc: XSalesGroupModel.fromJson(json['group_foc']),
      salesCategory: List<XSalesItemModel>.from(
        (json['sales_category'] as List).map((x) => XSalesItemModel.fromJson(x)),
      ),
      discount: XSalesDiscountModel.fromJson(json['discount']),
      salesCash: json['sales_cash'],
    );
  }
}

// ── Shared Item ───────────────────────────────────────────────────────────────

class XSalesItemModel {
  String name;
  int qty;
  num amount;

  XSalesItemModel({
    required this.name,
    required this.qty,
    required this.amount,
  });

  factory XSalesItemModel.fromJson(Map<String, dynamic> json) {
    return XSalesItemModel(
      name: json['name'],
      qty: json['qty'] ?? 0,
      amount: json['amount'] ?? 0,
    );
  }
}

// ── Sales Summary ─────────────────────────────────────────────────────────────

class XSalesSummaryModel {
  int itemSalesQty;
  num itemSalesAmount;
  int itemDiscountQty;
  num itemDiscountAmount;
  int billDiscountQty;
  num billDiscountAmount;
  int focItemQty;
  num focItemAmount;
  int focBillQty;
  num focBillAmount;
  int totalQty;
  num totalAmount;
  num estimatedSales;

  XSalesSummaryModel({
    required this.itemSalesQty,
    required this.itemSalesAmount,
    required this.itemDiscountQty,
    required this.itemDiscountAmount,
    required this.billDiscountQty,
    required this.billDiscountAmount,
    required this.focItemQty,
    required this.focItemAmount,
    required this.focBillQty,
    required this.focBillAmount,
    required this.totalQty,
    required this.totalAmount,
    required this.estimatedSales,
  });

  factory XSalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return XSalesSummaryModel(
      itemSalesQty: json['item_sales_qty'] ?? 0,
      itemSalesAmount: json['item_sales_amount'] ?? 0,
      itemDiscountQty: json['item_discount_qty'] ?? 0,
      itemDiscountAmount: json['item_discount_amount'] ?? 0,
      billDiscountQty: json['bill_discount_qty'] ?? 0,
      billDiscountAmount: json['bill_discount_amount'] ?? 0,
      focItemQty: json['foc_item_qty'] ?? 0,
      focItemAmount: json['foc_item_amount'] ?? 0,
      focBillQty: json['foc_bill_qty'] ?? 0,
      focBillAmount: json['foc_bill_amount'] ?? 0,
      totalQty: json['total_qty'] ?? 0,
      totalAmount: json['total_amount'] ?? 0,
      estimatedSales: json['estimated_sales'] ?? 0,
    );
  }
}

// ── Totals ────────────────────────────────────────────────────────────────────

class XSalesTotalsModel {
  int cardQty;
  num cardAmount;
  int cashQty;
  num cashAmount;
  int voucherQty;
  num voucherAmount;

  XSalesTotalsModel({
    required this.cardQty,
    required this.cardAmount,
    required this.cashQty,
    required this.cashAmount,
    required this.voucherQty,
    required this.voucherAmount,
  });

  factory XSalesTotalsModel.fromJson(Map<String, dynamic> json) {
    return XSalesTotalsModel(
      cardQty: json['card_qty'] ?? 0,
      cardAmount: json['card_amount'] ?? 0,
      cashQty: json['cash_qty'] ?? 0,
      cashAmount: json['cash_amount'] ?? 0,
      voucherQty: json['voucher_qty'] ?? 0,
      voucherAmount: json['voucher_amount'] ?? 0,
    );
  }
}

// ── Void ──────────────────────────────────────────────────────────────────────

class XSalesVoidModel {
  int preSendQty;
  num preSendAmount;
  int postSendQty;
  num postSendAmount;

  XSalesVoidModel({
    required this.preSendQty,
    required this.preSendAmount,
    required this.postSendQty,
    required this.postSendAmount,
  });

  factory XSalesVoidModel.fromJson(Map<String, dynamic> json) {
    return XSalesVoidModel(
      preSendQty: json['pre_send_qty'] ?? 0,
      preSendAmount: json['pre_send_amount'] ?? 0,
      postSendQty: json['post_send_qty'] ?? 0,
      postSendAmount: json['post_send_amount'] ?? 0,
    );
  }
}

// ── Settlement ────────────────────────────────────────────────────────────────

class XSalesSettlementModel {
  int extCollectionQty;
  num extCollectionAmount;
  int extCollectionFocQty;
  num extCollectionFocAmount;

  XSalesSettlementModel({
    required this.extCollectionQty,
    required this.extCollectionAmount,
    required this.extCollectionFocQty,
    required this.extCollectionFocAmount,
  });

  factory XSalesSettlementModel.fromJson(Map<String, dynamic> json) {
    return XSalesSettlementModel(
      extCollectionQty: json['ext_collection_qty'] ?? 0,
      extCollectionAmount: json['ext_collection_amount'] ?? 0,
      extCollectionFocQty: json['ext_collection_foc_qty'] ?? 0,
      extCollectionFocAmount: json['ext_collection_foc_amount'] ?? 0,
    );
  }
}

// ── Tax & Net ─────────────────────────────────────────────────────────────────

class XSalesTaxNetModel {
  num pb1Amount;
  num scAmount;
  num netSales;

  XSalesTaxNetModel({
    required this.pb1Amount,
    required this.scAmount,
    required this.netSales,
  });

  factory XSalesTaxNetModel.fromJson(Map<String, dynamic> json) {
    return XSalesTaxNetModel(
      pb1Amount: json['pb1_amount'] ?? 0,
      scAmount: json['sc_amount'] ?? 0,
      netSales: json['net_sales'] ?? 0,
    );
  }
}

// ── Bills ─────────────────────────────────────────────────────────────────────

class XSalesBillsModel {
  int pending;
  int totalCount;
  num totalAmount;
  int totalCovers;
  num avgCovers;
  String bestReceiptNo;
  String secondReceiptNo;

  XSalesBillsModel({
    required this.pending,
    required this.totalCount,
    required this.totalAmount,
    required this.totalCovers,
    required this.avgCovers,
    required this.bestReceiptNo,
    required this.secondReceiptNo,
  });

  factory XSalesBillsModel.fromJson(Map<String, dynamic> json) {
    return XSalesBillsModel(
      pending: json['pending'] ?? 0,
      totalCount: json['total_count'] ?? 0,
      totalAmount: json['total_amount'] ?? 0,
      totalCovers: json['total_covers'] ?? 0,
      avgCovers: json['avg_covers'] ?? 0,
      bestReceiptNo: json['best_receipt_no'] ?? '',
      secondReceiptNo: json['second_receipt_no'] ?? '',
    );
  }
}

// ── Group (dipakai untuk Group Sales & Group FOC) ─────────────────────────────

class XSalesGroupModel {
  List<XSalesItemModel> items;
  num total;

  XSalesGroupModel({
    required this.items,
    required this.total,
  });

  factory XSalesGroupModel.fromJson(Map<String, dynamic> json) {
    return XSalesGroupModel(
      items: List<XSalesItemModel>.from(
        (json['items'] as List).map((x) => XSalesItemModel.fromJson(x)),
      ),
      total: json['total'] ?? 0,
    );
  }
}

// ── Discount / Promosi ────────────────────────────────────────────────────────

class XSalesDiscountModel {
  List<XSalesItemModel> items;
  num total;

  XSalesDiscountModel({
    required this.items,
    required this.total,
  });

  factory XSalesDiscountModel.fromJson(Map<String, dynamic> json) {
    return XSalesDiscountModel(
      items: List<XSalesItemModel>.from(
        (json['items'] as List).map((x) => XSalesItemModel.fromJson(x)),
      ),
      total: json['total'] ?? 0,
    );
  }
}
