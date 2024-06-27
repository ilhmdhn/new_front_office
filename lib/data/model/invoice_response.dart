import 'package:front_office_2/data/model/bill_response.dart';

class InvoiceResponse{
  bool state;
  String message;
  PrintInvoiceModel? data;

  InvoiceResponse({
    required this.state,
    required this.message,
    required this.data,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic>json){
    return InvoiceResponse(
      state: json['state'], 
      message: json['message'], 
      data: PrintInvoiceModel.fromJson(json['data'])
    );
  }
}

class PrintInvoiceModel{
  OutletModel dataOutlet;
  InvoiceModel dataInvoice;
  RoomModel dataRoom;
  ServiceTaxPercentModel dataServiceTaxPercent;
  PaymentDetail payment;
  int? footerStyle;

  List<OrderModel> dataOrder;
  List<CancelOrderModel> dataCancelOrder;
  List<PromoOrderModel> dataPromoOrder;
  List<PromoCancelOrderModel> dataPromoCancelOrder;
  List<TransferListModel> transferList;
  List<TransferModel> transferData;
  List<PaymentData> paymentList;

  PrintInvoiceModel({
    required this.dataOutlet,
    required this.dataInvoice,
    required this.dataRoom,
    required this.dataServiceTaxPercent,
    required this.payment,
    required this.dataOrder,
    required this.dataCancelOrder,
    required this.dataPromoOrder,
    required this.dataPromoCancelOrder,
    required this.transferList,
    required this.transferData,
    required this.paymentList,
    this.footerStyle,
  });

  factory PrintInvoiceModel.fromJson(Map<String, dynamic>json){

    return PrintInvoiceModel(
      dataOutlet: OutletModel.fromJson(json['dataOutlet']), 
      dataInvoice: InvoiceModel.fromJson( json['dataInvoice']), 
      dataRoom: RoomModel.fromJson(json['dataRoom']), 
      payment: PaymentDetail.fromJson(json['paymentDetail']),
      dataOrder: List<OrderModel>.from((json['orderData'] as List).map((x) => OrderModel.fromJson(x))), 
      dataCancelOrder: List<CancelOrderModel>.from((json['cancelOrderData'] as List).map((x) => CancelOrderModel.fromJson(x))), 
      dataPromoOrder: List<PromoOrderModel>.from((json['promoOrderData'] as List).map((x) => PromoOrderModel.fromJson(x))), 
      dataPromoCancelOrder: List<PromoCancelOrderModel>.from((json['promoOrderCancel'] as List).map((x) => PromoCancelOrderModel.fromJson(x))), 
      dataServiceTaxPercent: ServiceTaxPercentModel.fromJson(json['service_percent']),
      transferList: List<TransferListModel>.from((json['transferListData'] as List).map((x) => TransferListModel.fromJson(x))),
      transferData: List<TransferModel>.from((json['transferBillData'] as List).map((x) => TransferModel.fromJson(x))),
      paymentList: List<PaymentData>.from((json['paymentData'] as List).map((x) => PaymentData.from(x))),
      footerStyle: json['footerStyle']??5
    );
  }
}

class PaymentData{
  String paymentName;
  num value;

  PaymentData({
    required this.paymentName,
    required this.value,
  });

  factory PaymentData.from(Map<String, dynamic> json){
    return PaymentData(
      paymentName: json['nama_payment'], 
      value: json['total']
    );
  }
}

class PaymentDetail{
  num payValue;
  num payChange;

  PaymentDetail({
    required this.payValue,
    required this.payChange,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic>json){
    return PaymentDetail(
      payValue: json['pay_value'], 
      payChange: json['pay_change']
    );
  }
}