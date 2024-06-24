import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/model/invoice_response.dart';
import 'package:front_office_2/tools/preferences.dart';

class JsonConverter{
  static Map<String, dynamic> outlet(OutletModel data){
    return {
            'namaOutlet': data.namaOutlet,
            'alamatOutlet': data.alamatOutlet,
            'telepon': data.telepon,
            'kota': data.kota,
    };
  }

  static Map<String, dynamic> invoice(InvoiceModel data){
    return {
      'memberName': data.memberName,
      'memberCode': data.memberCode,
      'invoice': data.invoice,
      'sewaRuangan': data.sewaRuangan,
      'promo': data.promo,
      'jumlahRuangan': data.jumlahRuangan,
      'jumlahPenjualan': data.jumlahPenjualan,
      'jumlah': data.jumlah,
      'jumlahService': data.jumlahService,
      'jumlahPajak': data.jumlahPajak,
      'roomService': data.roomService,
      'roomTax': data.roomTax,
      'fnbService': data.fnbService,
      'fnbTax': data.fnbTax,
      'transfer': data.transfer,
      'statusPrint': data.statusPrint,
      'overpax': data.overpax,
      'diskonKamar': data.diskonKamar,
      'surchargeKamar': data.surchargeKamar,
      'diskonPenjualan': data.diskonPenjualan,
      'voucher': data.voucher,
      'chargeLain': data.chargeLain,
      'jumlahTotal': data.jumlahTotal,
      'uangMuka': data.uangMuka,
      'jumlahBersih': data.jumlahBersih,
      };
  }

  static Map<String, dynamic> room(RoomModel data){
    return {
      'tanggal': data.tanggal,
      'nama': data.nama,
      'roomCode': data.roomCode,
      'ruangan': data.ruangan,
      'checkin': data.checkin,
      'checkout': data.checkout,
    };
  }

  static Map<String, dynamic> serviceTax(ServiceTaxPercentModel data){
    return{
      'serviceRoomPercent' : data.serviceRoomPercent,
      'taxRoomPercent' : data.taxRoomPercent,
      'serviceFnbPercent' : data.serviceFnbPercent,
      'taxFnbPercent' : data.taxFnbPercent,
    };
  }

  static Map<String, dynamic> paymentDetail(PaymentDetail data){
    return{
      'pay_value' : data.payValue,
      'pay_change' : data.payChange,
    };
  }

  static List<Map<String, dynamic>> paymentData(List<PaymentData> data){
    final List<Map<String, dynamic>> paymentList = List.empty(growable: true);

    for(var element in data){
      paymentList.add({
        'payment_name':element.paymentName,
        'value': element.value
      });
    }

    return paymentList;
  }

  static List<Map<String, dynamic>> order(List<OrderModel> data){
    final List<Map<String, dynamic>> orderData = List.empty(growable: true);
    
    for (var element in data) {
      orderData.add({
        'orderCode': element.orderCode,
        'inventoryCode': element.inventoryCode,
        'namaItem': element.namaItem,
        'jumlah': element.jumlah,
        'harga': element.harga,
        'total': element.total
      }
      );
    }
    return orderData;
  }

  static List<Map<String, dynamic>> cancelOrder(List<CancelOrderModel> data){
    final List<Map<String, dynamic>> cancelOrderData = List.empty(growable: true);

    for(var element in data){
      cancelOrderData.add({
        'cancelOrderCode': element.cancelOrderCode,
        'orderCode': element.orderCode,
        'harga': element.harga,
        'namaItem': element.namaItem,
        'inventoryCode': element.inventoryCode,
        'jumlah': element.jumlah,
        'total': element.total
      });
    }
    return cancelOrderData;
  }

  static List<Map<String, dynamic>> promoOrder(List<PromoOrderModel> data){
    final List<Map<String, dynamic>> cancelOrderData = List.empty(growable: true);
    for(var element in data){
      cancelOrderData.add({
        'orderCode': element.orderCode,
        'inventoryCode': element.inventoryCode,
        'promoName': element.promoName,
        'promoPrice': element.promoPrice
      });
    }

    return cancelOrderData;
  }

  static List<Map<String, dynamic>> promoCancelOrder(List<PromoCancelOrderModel> data){
    final List<Map<String, dynamic>> cancelOrderData = List.empty(growable: true);

    for(var element in data){
      cancelOrderData.add({
        'orderCancelCode': element.orderCancelCode,
        'orderCode': element.orderCode,
        'inventoryCode': element.inventoryCode,
        'promoName': element.promoName,
        'promoPrice': element.promoPrice,
      });
    }

    return cancelOrderData;
  }

  static List<Map<String, dynamic>> transferList(List<TransferModel> data){
    final List<Map<String, dynamic>> transferList = List.empty(growable: true);

    for(var element in data){
      transferList.add({
        'dataOutlet': outlet(element.dataOutlet),
        'dataInvoice': invoice(element.dataInvoice),
        'dataRoom': room(element.dataRoom),
        'dataOrder': order(element.dataOrder),
        'dataCancelOrder': cancelOrder(element.dataCancelOrder),
        'dataPromoOrder': promoOrder(element.dataPromoOrder),
        'dataPromoCancelOrder': promoCancelOrder(element.dataPromoCancelOrder),
        'dataServiceTaxPercent': serviceTax(element.dataServiceTaxPercent)
      });
    }

    return transferList;
  }

  static Map<String, dynamic> generateBillJson(PreviewBillModel data){
    return {
      'dataOutlet': outlet(data.dataOutlet),
      'dataInvoice':invoice(data.dataInvoice),
      'dataRoom': room(data.dataRoom),
      'orderData': order(data.dataOrder),
      'cancelOrderData': cancelOrder(data.dataCancelOrder),
      'promoOrderData': promoOrder(data.dataPromoOrder),
      'promoOrderCancel': promoCancelOrder(data.dataPromoCancelOrder),
      'transferBillData': transferList(data.transferData),
      'service_percent': serviceTax(data.dataServiceTaxPercent)
    };
  }

  static Map<String, dynamic> generateInvoiceJson(PrintInvoiceModel data){
    return {
      'dataOutlet': outlet(data.dataOutlet),
      'dataInvoice':invoice(data.dataInvoice),
      'dataRoom': room(data.dataRoom),
      'orderData': order(data.dataOrder),
      'cancelOrderData': cancelOrder(data.dataCancelOrder),
      'promoOrderData': promoOrder(data.dataPromoOrder),
      'promoOrderCancel': promoCancelOrder(data.dataPromoCancelOrder),
      'transferBillData': transferList(data.transferData),
      'service_percent': serviceTax(data.dataServiceTaxPercent),
      'payment_detail': paymentDetail(data.payment),
      'payment_list': paymentData(data.paymentList)
    };
  }

  static Map<String, dynamic> generateTransferParams(String destinationRoom, bool isCheckinRoom, String roomType, int capacity, String oldRoom, String reason){
    final chusr = PreferencesData.getUser().userId;
    return {
      "checkin_room":{
        "kamar": destinationRoom
      },
      "checkin_room_type":{
        "kamar_untuk_checkin": isCheckinRoom,
        "jenis_kamar": roomType,
        "kapasitas": capacity,
      },
      "chusr": chusr,
      "old_room_before_transfer":{
        "kamar": oldRoom
      },
      "transfer_reason": reason
    };
  }
}