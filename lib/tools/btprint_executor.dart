import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:collection/collection.dart';

class BtprintExecutor{
    
    final bold = Uint8List.fromList([0x1B, 0x21, 0x08]);
    final offBold = Uint8List.fromList([0x1B, 0x21, 0x00]);
    final normal = Uint8List.fromList([0x1B, 0x21, 0x00]);
    final left = Uint8List.fromList([0x1B, 0x61, 0x00]);
    final center = Uint8List.fromList([0x1B, 0x61, 0x01]);
    final right = Uint8List.fromList([0x1B, 0x61, 0x02]);

  void testPrint()async{
    final bluetooth = await BtPrint().getInstance();
    bluetooth.isConnected.then((isConnected) async{
      if (isConnected == true) {
        bluetooth.printNewLine();
        // await bluetooth.writeBytes(Uint8List.fromList([0x1B, 0x4C, 0x00]));
        await bluetooth.writeBytes(Uint8List.fromList([0x1B, 0x4C, 0x01])).then((value) async=> await bluetooth.write('\nAYAM CABE GARAM 1'));
        await bluetooth.write('\nAYAM CABE GARAM 2');
        await bluetooth.writeBytes(Uint8List.fromList([0x1B, 0x21, 0x00]))
            .then((value) async=> await bluetooth.write('\nAYAM CABE GARAM 3'));
        // bluetooth.printCustom("Test Print Successfully 2", 2, Align.center.val);
        // bluetooth.printCustom("Test Print Successfully 3", 3, Align.center.val);
        // bluetooth.printCustom("Test Print Successfully 4", 4, Align.center.val);
        // bluetooth.printCustom("Test Print Successfully 5", 5, Align.center.val);
        // bluetooth.printCustom("Test Print Successfully 6", 6, Align.center.val);
        // bluetooth.printCustom("Test Print Successfully 7", 7, Align.center.val);
        // bluetooth.printCustom("Test Print Successfully 8", 8, Align.center.val);
        // bluetooth.printCustom("Test Print Successfully 9", 9, Align.center.val);
        // bluetooth.printCustom("Test Print Successfully 10", 10, Align.center.val);
          await bluetooth.writeBytes(Uint8List.fromList([0x1B, 0x21, 0x00]));

        // Print with Font A
        await bluetooth.writeBytes(Uint8List.fromList([0x1B, 0x4D, 0x00]));
        await bluetooth.write('\nThis is Font A\n');

        // Print with Font B
        await bluetooth.writeBytes(Uint8List.fromList([0x1B, 0x4D, 0x01]));
        await bluetooth.write('\nThis is Font B\n');

        // Double height and width, no bold
        await bluetooth.writeBytes(Uint8List.fromList([0x1D, 0x21, 0x22]));
        await bluetooth.write('\nDouble Height and Width, Non-Bold\n');

        // Reset to normal size
        await bluetooth.writeBytes(Uint8List.fromList([0x1B, 0x21, 0x00]));
        bluetooth.printNewLine();
        bluetooth.printNewLine();
      }else{
        showToastWarning('Sambungkan printer di pengaturan');
      }
    });
  }

  void printBill(PreviewBillModel data)async{
    
    final bluetooth = await BtPrint().getInstance();
    
    List<OrderFinalModel> orderFix = List.empty(growable: true);

    if(isNotNullOrEmpty(data.dataOrder)){
      for (var order in data.dataOrder) {

        String orderCode = order.orderCode;
        String inventoryCode = order.inventoryCode;
        String namaItem = order.namaItem;
        String promoName = '';
        int jumlah = order.jumlah;
        num hargaSatuan = order.harga;
        num totalSemua = order.total;

        num hargaPromo = 0;
        int jumlahCancel = 0;
        num hargaCancel = 0;
        num hargaPromoCancel = 0;


        List<PromoOrderModel>? promo;
        List<CancelOrderModel>? cancel;
        List<PromoCancelOrderModel>? promoCancel;

        if(isNotNullOrEmpty(data.dataPromoOrder)) {
          promo = data.dataPromoOrder.where((element) => element.orderCode == orderCode && element.inventoryCode == inventoryCode).toList();
          if (isNotNullOrEmpty(promo)) {
            promoName = promo[0].promoName;
            hargaPromo += promo[0].promoPrice;
          }
        }

        if (isNotNullOrEmpty(data.dataCancelOrder)) {
          cancel = data.dataCancelOrder.where((element) => element.orderCode == orderCode && element.inventoryCode == inventoryCode).toList();
          if(isNotNullOrEmpty(cancel)){
            jumlahCancel = cancel[0].jumlah;
            hargaCancel = cancel[0].harga;
            jumlah -= cancel[0].jumlah;
            totalSemua -= cancel[0].total;

            if (isNotNullOrEmpty(data.dataPromoCancelOrder)) {
              promoCancel = data.dataPromoCancelOrder.where((element) => element.orderCode == orderCode && element.inventoryCode == inventoryCode && element.orderCancelCode == cancel![0].cancelOrderCode).toList();
              if(isNotNullOrEmpty(promoCancel)){
                hargaPromo -= promoCancel[0].promoPrice;
              }
            }

          }
        }
        orderFix.add(
          OrderFinalModel(
            orderCode: orderCode,
            inventoryCode: inventoryCode,
            namaItem: namaItem,
            jumlah: jumlah,
            hargaSatuan: hargaSatuan,
            hargaPromo: hargaPromo,
            promoName: promoName,
            jumlahCancel: jumlahCancel,
            hargaCancel: hargaCancel,
            hargaPromoCancel: hargaPromoCancel,
            totalSemua: totalSemua,
          )
        );
      }
    }

    bluetooth.isConnected.then((isConnected) async{
      if (isConnected == true) {
        //HEADER
        await bluetooth.writeBytes(center);
        await bluetooth.write('${data.dataOutlet.namaOutlet}\n');
        await bluetooth.write('${data.dataOutlet.alamatOutlet}\n');
        await bluetooth.write('${data.dataOutlet.kota}\n');
        await bluetooth.write('${data.dataOutlet.telepon}\n');
        bluetooth.printNewLine();
        await bluetooth.writeBytes(bold);
        await bluetooth.write('TAGIHAN\n');
        bluetooth.printNewLine();
        await bluetooth.writeBytes(offBold);
        
        //Checkin Info
        await bluetooth.writeBytes(left);
        await bluetooth.write('Ruangan : ');
        await bluetooth.write('${data.dataRoom.roomCode}\n');
        await bluetooth.write('Nama    : ');
        await bluetooth.write('${data.dataRoom.nama}\n');
        await bluetooth.write('Tanggal : ');
        await bluetooth.write('${data.dataRoom.tanggal}\n');
        bluetooth.printNewLine();
        await bluetooth.writeBytes(left);
        
        //Room Info
        await bluetooth.write(formatTable('Sewa Ruangan', Formatter.formatRupiah(data.dataInvoice.sewaRuangan), 48));
        if(data.dataInvoice.promo >0){
          await bluetooth.write(formatTable('Promo', '(${Formatter.formatRupiah(data.dataInvoice.promo)})', 48));
        }
        
        //FnB

        if(isNotNullOrEmpty(orderFix)){
          printFnB(orderFix, bluetooth);
        }


        bluetooth.printNewLine();
      }else{
        showToastWarning('Sambungkan printer di pengaturan');
      }
    });
  }

  String formatTable(String leftText, String rightText, int totalWidth) {
    int leftWidth = leftText.length;
    int rightWidth = rightText.length;

    // Calculate the space needed to align the right text to the end
    int spaces = totalWidth - (leftWidth + rightWidth);

    // Ensure there are enough spaces to pad the left text
    if (spaces < 0) spaces = 0;

    return '$leftText${' ' * spaces}$rightText\n';
  }

  Future<void> printFnB(List<OrderFinalModel> data, BlueThermalPrinter bt)async{
    final fnbList = mergeItems(data);
    
    await bt.printNewLine();
    await bt.write('Rincian Penjualan\n');
    await bt.printNewLine();
    
    for(var fnb in fnbList ){
      if(fnb.jumlah > 0){
        await bt.write('${fnb.namaItem}\n');
        await bt.write(formatTable('  ${fnb.jumlah} x ${Formatter.formatRupiah(fnb.hargaSatuan)}',Formatter.formatRupiah(fnb.totalSemua),48));
        if (fnb.hargaPromo > 0) {
          await bt.write(formatTable(fnb.promoName,'(${Formatter.formatRupiah(fnb.hargaPromo)})', 48));
        }
      }
    }
    return;
  }

  List<OrderFinalModel> mergeItems(List<OrderFinalModel> orderList) {
    var groupedOrders = groupBy<OrderFinalModel, String>(orderList, (order) => '${order.inventoryCode}-${order.namaItem}-${order.hargaSatuan}');

    List<OrderFinalModel> mergedList = [];

    for (var entry in groupedOrders.entries) {
      var orders = entry.value;
      if (orders.length == 1) {
        mergedList.add(orders.first);
      } else {
        var combinedOrder = orders.reduce((a, b) => OrderFinalModel(
              orderCode:
                  a.orderCode, // Assuming you want to keep the first orderCode
              inventoryCode: a.inventoryCode,
              namaItem: a.namaItem,
              jumlah: a.jumlah + b.jumlah,
              hargaSatuan: a.hargaSatuan, // hargaSatuan should be the same
              hargaPromo: a.hargaPromo + b.hargaPromo,
              promoName:
                  a.promoName, // Assuming you want to keep the first promoName
              jumlahCancel: a.jumlahCancel + b.jumlahCancel,
              hargaCancel: a.hargaCancel + b.hargaCancel,
              hargaPromoCancel: a.hargaPromoCancel + b.hargaPromoCancel,
              totalSemua: a.totalSemua + b.totalSemua,
            ));

        mergedList.add(combinedOrder);
      }
    }

    return mergedList;
  }
}