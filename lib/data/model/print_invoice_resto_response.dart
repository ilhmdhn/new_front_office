import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/model/bill_resto_response.dart';

class InvoiceRestoResponse {
  bool state;
  String message;
  PrintInvoiceRestoModel? data;
  
  InvoiceRestoResponse({
    required this.state,
    required this.message,
    this.data
  });

  factory InvoiceRestoResponse.fromJson(Map<String, dynamic>json){
    return InvoiceRestoResponse(
      state: json['state'], 
      message: json['message'], 
      data: PrintInvoiceRestoModel.fromJson(json['data'])
    );
  }
}

class PrintInvoiceRestoModel{
  OutletModel outlet;
  List<OrderRestoModel> order;
  InvoiceRestoModel invoice;
  ReceptionRestoModel rcp;
  PaymentSummary paymentSummary;
  List<PaymentList> paymentList;

  PrintInvoiceRestoModel({
    required this.outlet,
    required this.order,
    required this.invoice,
    required this.rcp,
    required this.paymentSummary,
    required this.paymentList
  });

  factory PrintInvoiceRestoModel.fromJson(Map<String, dynamic>json){
    return PrintInvoiceRestoModel(
      outlet: OutletModel.fromJson(json['outlet']), 
      invoice: InvoiceRestoModel.fromJson(json['invoice']), 
      rcp: ReceptionRestoModel.fromJson(json['reception']),
      order: List<OrderRestoModel>.from(
        (json['order'] as List).map((x) => OrderRestoModel.fromJson(x))
      ),
      paymentSummary: PaymentSummary.fromJson(json['payment_summary']),
      paymentList: List<PaymentList>.from(
        (json['payment_list'] as List).map((x) => PaymentList.fromJson(x))
      )
    );
  }
}

class PaymentSummary{
  int payValue;
  int payChange;

  PaymentSummary({
    required this.payValue,
    required this.payChange
  }); 

  factory PaymentSummary.fromJson(Map<String, dynamic>json){
    return PaymentSummary(
      payValue: json['pay_value']??0, 
      payChange: json['pay_change']??0
    );
  }
}

class PaymentList{
  String paymentMethod;
  int paymentValue;

  PaymentList({
    required this.paymentMethod,
    required this.paymentValue
  });

  factory PaymentList.fromJson(Map<String, dynamic>json){
    return PaymentList(
      paymentMethod: json['nama_payment'], 
      paymentValue: json['total']
    );
  }
}