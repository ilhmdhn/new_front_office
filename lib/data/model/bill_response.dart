class PreviewBillResponse{
  bool state;
  String message;
  PreviewBillModel? data;

  PreviewBillResponse({
    required this.state,
    required this.message,
    this.data,
  });

  factory PreviewBillResponse.fromJson(Map<String, dynamic>json){
    if(json['state'] != true){
      throw json['message'];
    }
    return PreviewBillResponse(
      state: json['state'],
      message: json['message'],
      data: PreviewBillModel.fromJson(json['data'])
    );
  }
}
class PreviewBillModel{
  OutletModel dataOutlet;
  InvoiceModel dataInvoice;
  RoomModel dataRoom;
  ServiceTaxPercentModel dataServiceTaxPercent;

  List<OrderModel> dataOrder;
  List<CancelOrderModel> dataCancelOrder;
  List<PromoOrderModel> dataPromoOrder;
  List<PromoCancelOrderModel> dataPromoCancelOrder;
  List<TransferListModel> transferList;

  PreviewBillModel({
    required this.dataOutlet,
    required this.dataInvoice,
    required this.dataRoom,
    required this.dataOrder,
    required this.dataCancelOrder,
    required this.dataPromoOrder,
    required this.dataPromoCancelOrder,
    required this.dataServiceTaxPercent,
    required this.transferList
  });

  factory PreviewBillModel.fromJson(Map<String, dynamic>json){
    return PreviewBillModel(
      dataOutlet: OutletModel.fromJson(json['dataOutlet']), 
      dataInvoice: InvoiceModel.fromJson( json['dataInvoice']), 
      dataRoom: RoomModel.fromJson(json['dataRoom']), 
      dataOrder: List<OrderModel>.from((json['orderData'] as List).map((x) => OrderModel.fromJson(x))), 
      dataCancelOrder: List<CancelOrderModel>.from((json['cancelOrderData'] as List).map((x) => CancelOrderModel.fromJson(x))), 
      dataPromoOrder: List<PromoOrderModel>.from((json['promoOrderData'] as List).map((x) => PromoOrderModel.fromJson(x))), 
      dataPromoCancelOrder: List<PromoCancelOrderModel>.from((json['promoOrderCancel'] as List).map((x) => PromoCancelOrderModel.fromJson(x))), 
      dataServiceTaxPercent: ServiceTaxPercentModel.fromJson(json['service_percent']),
      transferList: List<TransferListModel>.from((json['transferListData'] as List).map((x) => TransferListModel.fromJson(x)))
    );
  }
}

class OutletModel{
  String namaOutlet;
  String alamatOutlet;
  String telepon;
  String kota;

  OutletModel({
    required this.namaOutlet,
    required this.alamatOutlet,
    required this.telepon,
    required this.kota,
  });

  factory OutletModel.fromJson(Map<String, dynamic>json){
    return OutletModel(
      namaOutlet: json['nama_outlet'], 
      alamatOutlet: json['alamat_outlet'], 
      telepon: json['telepon'], 
      kota: json['kota']);
  }
}

class InvoiceModel{
  String memberName;
  String memberCode;
  String invoice;
  num sewaRuangan;
  num promo;
  num jumlahRuangan;
  num jumlahPenjualan;
  num jumlah;
  num jumlahService;
  num jumlahPajak;
  num roomService;
  num roomTax;
  num fnbService;
  num fnbTax;
  String transfer;
  String statusPrint;
  num overpax;
  num diskonKamar;
  num surchargeKamar;
  num diskonPenjualan;
  num voucher;
  num chargeLain;
  num jumlahTotal;
  num uangMuka;
  num jumlahBersih;

  InvoiceModel({
    required this.memberName,
    required this.memberCode,
    required this.invoice,
    required this.sewaRuangan,
    required this.promo,
    required this.jumlahRuangan,
    required this.jumlahPenjualan,
    required this.jumlah,
    required this.jumlahService,
    required this.jumlahPajak,
    required this.roomService,
    required this.roomTax,
    required this.fnbService,
    required this.fnbTax,
    required this.transfer,
    required this.statusPrint,
    required this.overpax,
    required this.diskonKamar,
    required this.surchargeKamar,
    required this.diskonPenjualan,
    required this.voucher,
    required this.chargeLain,
    required this.jumlahTotal,
    required this.uangMuka,
    required this.jumlahBersih,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic>json){
    return InvoiceModel(
      memberName: json['member_name'],
      memberCode: json['member_code'],
      invoice: json['invoice'],
      sewaRuangan: json['sewa_ruangan'],
      promo: json['promo'],
      jumlahRuangan: json['jumlah_ruangan'],
      jumlahPenjualan: json['jumlah_penjualan'],
      jumlah: json['jumlah'],
      jumlahService: json['jumlah_service'],
      jumlahPajak: json['jumlah_pajak'],
      roomService: json['room_service'],
      roomTax: json['room_tax'],
      fnbService: json['fnb_service'],
      fnbTax: json['fnb_tax'],
      transfer: json['transfer'],
      statusPrint: json['status_print'],
      overpax: json['overpax'],
      diskonKamar: json['diskon_kamar'],
      surchargeKamar: json['surcharge_kamar'],
      diskonPenjualan: json['diskon_penjualan'],
      voucher: json['voucher'],
      chargeLain: json['charge_lain'],
      jumlahTotal: json['jumlah_total'],
      uangMuka: json['uang_muka'],
      jumlahBersih: json['jumlah_bersih'],
    );
  }
}

class RoomModel{
  String tanggal;
  String nama;
  String roomCode;
  String ruangan;
  String checkin;
  String checkout;

  RoomModel({
    required this.tanggal,
    required this.nama,
    required this.roomCode,
    required this.ruangan,
    required this.checkin,
    required this.checkout,
  });

  factory RoomModel.fromJson(Map<String, dynamic>json){
    return RoomModel(
      tanggal: json['tanggal'],
      nama: json['nama'],
      roomCode: json['room_code'],
      ruangan: json['ruangan'],
      checkin: json['Checkin'],
      checkout: json['Checkout']
    );
  }
}

class OrderModel{
  String orderCode;
  String inventoryCode;
  String namaItem;
  int jumlah;
  num harga;
  num total;

  OrderModel({
  required this.orderCode,
  required this.inventoryCode,
  required this.namaItem,
  required this.jumlah,
  required this.harga,
  required this.total,
  });

  factory OrderModel.fromJson(Map<String, dynamic>json){
    return OrderModel(
      orderCode: json['order_code'], 
      inventoryCode: json['inventory_code'], 
      namaItem: json['nama_item'], 
      jumlah: json['jumlah'], 
      harga: json['harga'], 
      total: json['total']
    );
  }
}

class CancelOrderModel{
  String cancelOrderCode;
  String orderCode;
  num harga;
  String namaItem;
  String inventoryCode;
  int jumlah;
  num total;

  CancelOrderModel({
    required this.cancelOrderCode,
    required this.orderCode,
    required this.harga,
    required this.namaItem,
    required this.inventoryCode,
    required this.jumlah,
    required this.total
  });

  factory CancelOrderModel.fromJson(Map<String, dynamic>json){
    return CancelOrderModel
    (
      cancelOrderCode: json['cancel_order_code'], 
      orderCode: json['order_code'], 
      harga: json['harga'], 
      namaItem: json['nama_item'], 
      inventoryCode: json['inventory_code'], 
      jumlah: json['jumlah'], 
      total: json['total']
    );
  }
}

class PromoOrderModel{
  String orderCode;
  String inventoryCode;
  String promoName;
  num promoPrice;

  PromoOrderModel({
    required this.orderCode,
    required this.inventoryCode,
    required this.promoName,
    required this.promoPrice,
  });

  factory PromoOrderModel.fromJson(Map<String, dynamic>json){
    return PromoOrderModel
    (
      orderCode: json['order_code'], 
      inventoryCode: json['inventory_code'], 
      promoName: json['promo_name'], 
      promoPrice: json['promo_price']
    );
  }
}

class PromoCancelOrderModel{
  String orderCancelCode;
  String orderCode;
  String inventoryCode;
  String promoName;
  num promoPrice;

  PromoCancelOrderModel({
    required this.orderCancelCode,
    required this.orderCode,
    required this.inventoryCode,
    required this.promoName,
    required this.promoPrice,
  });

  factory PromoCancelOrderModel.fromJson(Map<String, dynamic>json){
    return PromoCancelOrderModel(
      orderCancelCode: json['order_cancel_code'],
      orderCode: json['order_code'],
      inventoryCode: json['inventory_code'],
      promoName: json['promo_name'],
      promoPrice: json['promo_price'],
    );
  }
}

class ServiceTaxPercentModel{
  int serviceRoomPercent;
  int taxRoomPercent;
  int serviceFnbPercent;
  int taxFnbPercent;

  ServiceTaxPercentModel({
    required this.serviceRoomPercent,
    required this.taxRoomPercent,
    required this.serviceFnbPercent,
    required this.taxFnbPercent,
  });

  factory ServiceTaxPercentModel.fromJson(Map<String, dynamic>json){
    return ServiceTaxPercentModel(
      serviceRoomPercent: json['service_room_percent'],
      taxRoomPercent: json['tax_room_percent'],
      serviceFnbPercent: json['service_fnb_percent'],
      taxFnbPercent: json['tax_fnb_percent'],
    );
  }
}

class TransferListModel{
  String room;
  num transferTotal;

  TransferListModel({
    required this.room,
    required this.transferTotal,
  });

  factory TransferListModel.fromJson(Map<String ,dynamic>json){
    return TransferListModel(
      room: json['room'], 
      transferTotal: json['transferTotal']);
  }
}

class TransferModel{
  OutletModel dataOutlet;
  InvoiceModel dataInvoice;
  RoomModel dataRoom;
  List<OrderModel> dataOrder;
  List<CancelOrderModel> dataCancelOrder;
  List<PromoOrderModel> dataPromoOrder;
  List<PromoCancelOrderModel> dataPromoCancelOrder;
  ServiceTaxPercentModel dataServiceTaxPercent;

  TransferModel({
    required this.dataOutlet,
    required this.dataInvoice,
    required this.dataRoom,
    required this.dataOrder,
    required this.dataCancelOrder,
    required this.dataPromoOrder,
    required this.dataPromoCancelOrder,
    required this.dataServiceTaxPercent,
  });

  factory TransferModel.fromJson(Map<String, dynamic>json){
    return TransferModel(
      dataOutlet: OutletModel.fromJson(json['dataOutlet']), 
      dataInvoice: InvoiceModel.fromJson( json['dataInvoice']), 
      dataRoom: RoomModel.fromJson(json['dataRoom']), 
      dataOrder: List<OrderModel>.from((json['orderData'] as List).map((x) => OrderModel.fromJson(x))), 
      dataCancelOrder: List<CancelOrderModel>.from((json['cancelOrderData'] as List).map((x) => CancelOrderModel.fromJson(x))), 
      dataPromoOrder: List<PromoOrderModel>.from((json['promoOrderCancel'] as List).map((x) => PromoOrderModel.fromJson(x))), 
      dataPromoCancelOrder: List<PromoCancelOrderModel>.from((json['promoOrderData'] as List).map((x) => PromoCancelOrderModel.fromJson(x))), 
      dataServiceTaxPercent: ServiceTaxPercentModel.fromJson(json['service_percent'])
    );
  }
}