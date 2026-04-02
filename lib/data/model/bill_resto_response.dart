import 'package:front_office_2/data/model/bill_response.dart';

class BillRestoResponse {
  bool state;
  String message;
  BillRestoModel? data;
  
  BillRestoResponse({
    required this.state,
    required this.message,
    this.data
  });

  factory BillRestoResponse.fromJson(Map<String, dynamic>json){
    return BillRestoResponse(
      state: json['state'], 
      message: json['message'], 
      data: BillRestoModel.fromJson(json['data'])
    );
  }
}

class BillRestoModel{
  OutletModel outlet;
  List<OrderRestoModel> order;
  InvoiceRestoModel invoice;
  ReceptionRestoModel rcp;

  BillRestoModel({
    required this.outlet,
    required this.order,
    required this.invoice,
    required this.rcp
  });

  factory BillRestoModel.fromJson(Map<String, dynamic>json){
    return BillRestoModel(
      outlet: OutletModel.fromJson(json['outlet']), 
      invoice: InvoiceRestoModel.fromJson(json['invoice']), 
      rcp: ReceptionRestoModel.fromJson(json['reception']),
      order: List<OrderRestoModel>.from(
        (json['order'] as List).map((x) => OrderRestoModel.fromJson(x))
      )
    );
  }
}

class OrderRestoModel{
  String inventory;
  String name;
  int qty;
  int price;
  int? promo;
  String? promoName;
  String typeFnb;

  OrderRestoModel({
    required this.inventory,
    required this.name,
    required this.qty,
    required this.price,
    this.promo,
    this.promoName,
    required this.typeFnb
  });

  factory OrderRestoModel.fromJson(Map<String, dynamic>json){
    return OrderRestoModel(
      inventory: json['inventory'], 
      name: json['name'], 
      qty: json['qty'], 
      price: json['price'], 
      promo: json['promo'],
      promoName: json['promo_name'],
      typeFnb: json['type_fnb']
    );
  }
}

class InvoiceRestoModel{
  int service;
  int tax;
  int servicePercent;
  int taxPercent;
  int total;
  String statusPrint;

  InvoiceRestoModel({
    required this.service,
    required this.tax,
    required this.servicePercent,
    required this.taxPercent,
    required this.total,
    required this.statusPrint
  });

  factory InvoiceRestoModel.fromJson(Map<String, dynamic>json){
    return InvoiceRestoModel(
      service: json['service'], 
      tax: json['tax'], 
      servicePercent: json['service_percent'], 
      taxPercent: json['tax_percent'], 
      total: json['total_all'],
      statusPrint: json['status_print']??''
    );
  }
}

class ReceptionRestoModel{
  String invoice;
  String reception;
  String user;
  String room;
  int pax;
  String custName;
  String date;

  ReceptionRestoModel({
    required this.invoice,
    required this.reception,
    required this.user,
    required this.room,
    required this.pax,
    required this.custName,
    required this.date
  });

  factory ReceptionRestoModel.fromJson(Map<String, dynamic>json){
    return ReceptionRestoModel(
      invoice: json['invoice'], 
      reception: json['reception'], 
      user: json['user'], 
      room: json['room'],
      pax: json['pax']??0,
      custName: json['cust_name'],
      date: json['date']

    );
  }
}