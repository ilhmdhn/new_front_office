class BillModel{

}

class DataOutlet{
  String namaOutlet;
  String alamatOutlet;
  String telepon;
  String kota;

  DataOutlet({
    required this.namaOutlet,
    required this.alamatOutlet,
    required this.telepon,
    required this.kota,
  });

  factory DataOutlet.fromJson(Map<String, dynamic>json){
    return DataOutlet(
      namaOutlet: json['nama_outlet'], 
      alamatOutlet: json['alamat_outlet'], 
      telepon: json['telepon'], 
      kota: json['kota']);
  }
}

class InvoiceData{
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

  InvoiceData({
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

  factory InvoiceData.fromJson(Map<String, dynamic>json){
    return InvoiceData(
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

class DataRoom{
  String tanggal;
  String nama;
  String roomCode;
  String ruangan;
  String checkin;
  String checkout;

  DataRoom({
    required this.tanggal,
    required this.nama,
    required this.roomCode,
    required this.ruangan,
    required this.checkin,
    required this.checkout,
  });

  factory DataRoom.fromJson(Map<String, dynamic>json){
    return DataRoom(
      tanggal: json['tanggal'],
      nama: json['nama'],
      roomCode: json['room_code'],
      ruangan: json['ruangan'],
      checkin: json['Checkin'],
      checkout: json['Checkout']
    );
  }
}

class OrderData{
  String orderCode;
  String inventoryCode;
  String namaItem;
  int jumlah;
  num harga;
  num total;

  OrderData({
  required this.orderCode,
  required this.inventoryCode,
  required this.namaItem,
  required this.jumlah,
  required this.harga,
  required this.total,
  });

  factory OrderData.fromJson(Map<String, dynamic>json){
    return OrderData(
      orderCode: json['order_code'], 
      inventoryCode: json['inventory_code'], 
      namaItem: json['nama_item'], 
      jumlah: json['jumlah'], 
      harga: json['harga'], 
      total: json['total']
    );
  }
}

class CancelOrderData{
  String cancelOrderCode;
  String orderCode;
  num harga;
  String namaItem;
  String inventoryCode;
  int jumlah;
  num total;

  CancelOrderData({
    required this.cancelOrderCode,
    required this.orderCode,
    required this.harga,
    required this.namaItem,
    required this.inventoryCode,
    required this.jumlah,
    required this.total
  });

  factory CancelOrderData.fromJson(Map<String, dynamic>json){
    return CancelOrderData(
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

class PromoOrderData{
  String orderCode;
  String inventoryCode;
  String promoName;
  String promoPrice;

  PromoOrderData({
    required this.orderCode,
    required this.inventoryCode,
    required this.promoName,
    required this.promoPrice,
  });

  factory PromoOrderData.fromJson(Map<String, dynamic>json){
    return PromoOrderData(
      orderCode: json['order_code'], 
      inventoryCode: json['inventory_code'], 
      promoName: json['promo_name'], 
      promoPrice: json['promo_price']
    );
  }
}

class PromoCancelOrder{
  String orderCancelCode;
  String orderCode;
  String inventoryCode;
  String promoName;
  num promoPrice;

  PromoCancelOrder({
    required this.orderCancelCode,
    required this.orderCode,
    required this.inventoryCode,
    required this.promoName,
    required this.promoPrice,
  });

  factory PromoCancelOrder.fromJson(Map<String, dynamic>json){
    return PromoCancelOrder(
      orderCancelCode: json['order_cancel_code'],
      orderCode: json['order_code'],
      inventoryCode: json['inventory_code'],
      promoName: json['promo_name'],
      promoPrice: json['promo_price'],
    );
  }
}

class ServiceTaxPercent{
  int serviceRoomPercent;
  int taxRoomPercent;
  int serviceFnbPercent;
  int taxFnbPercent;

  ServiceTaxPercent({
    required this.serviceRoomPercent,
    required this.taxRoomPercent,
    required this.serviceFnbPercent,
    required this.taxFnbPercent,
  });

  factory ServiceTaxPercent.fromJson(Map<String, dynamic>json){
    return ServiceTaxPercent(
      serviceRoomPercent: json['service_room_percent'],
      taxRoomPercent: json['tax_room_percent'],
      serviceFnbPercent: json['service_fnb_percent'],
      taxFnbPercent: json['tax_fnb_percent'],
    );
  }
}