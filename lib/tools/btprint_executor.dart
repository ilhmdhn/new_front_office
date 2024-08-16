import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/printerenum.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

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
    final user = PreferencesData.getUser().userId;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);
    
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
        await bluetooth.writeBytes(normal);

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

        if((data.voucherValue?.roomPrice ?? 0) > 0){
          await bluetooth.write(formatTable('Voucher Room', '(${Formatter.formatRupiah((data.voucherValue?.roomPrice ?? 0))})', 48));
        }
        
        //FnB
        if(isNotNullOrEmpty(orderFix)){
          await printFnB(orderFix, bluetooth);
        }

        await bluetooth.write('------------------------------------------------\n');
        await bluetooth.write(formatTable('Jumlah Ruangan', Formatter.formatRupiah(data.dataInvoice.jumlahRuangan), 48));
        await bluetooth.write(formatTable('Jumlah Penjualan', Formatter.formatRupiah(data.dataInvoice.jumlahPenjualan), 48));
        await bluetooth.write('------------------------------------------------\n\n');
        //Tax And Service
        await printFooter(bluetooth, data.dataInvoice, data.dataServiceTaxPercent, 1);

        if(isNotNullOrEmpty(data.transferList)){
          for(var teep in data.transferList){
            await bluetooth.write(formatTableRow(teep.room, Formatter.formatRupiah(teep.transferTotal), 48, leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
          }
        }
        
        await bluetooth.write(formatTableRow('Jumlah Bersih', Formatter.formatRupiah(data.dataInvoice.jumlahBersih), 48, leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
        await bluetooth.writeBytes(center);
        await bluetooth.printNewLine();
        await bluetooth.printCustom('Rp ${Formatter.formatRupiah(data.dataInvoice.jumlahBersih)}', Size.boldMedium.val, Align.center.val);
        await bluetooth.writeBytes(normal);
        await bluetooth.printNewLine();
        await bluetooth.writeBytes(right);
        await bluetooth.write('$formattedDate $user');
        await bluetooth.printNewLine();
        if(isNotNullOrEmpty(data.transferData)){
          for(var teepData in data.transferData){
            await printTransfer(bluetooth, teepData); 
          }
        }
      }else{
        showToastError('Cetak bill gagal');
      }
    });
  }

  Future<void> printTransfer(BlueThermalPrinter bluetooth, TransferModel data)async{

    List<OrderFinalModel> orderFix = List.empty(growable: true);

    if (isNotNullOrEmpty(data.dataOrder)) {
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

        if (isNotNullOrEmpty(data.dataPromoOrder)) {
          promo = data.dataPromoOrder
              .where((element) =>
                  element.orderCode == orderCode &&
                  element.inventoryCode == inventoryCode)
              .toList();
          if (isNotNullOrEmpty(promo)) {
            promoName = promo[0].promoName;
            hargaPromo += promo[0].promoPrice;
          }
        }

        if (isNotNullOrEmpty(data.dataCancelOrder)) {
          cancel = data.dataCancelOrder
              .where((element) =>
                  element.orderCode == orderCode &&
                  element.inventoryCode == inventoryCode)
              .toList();
          if (isNotNullOrEmpty(cancel)) {
            jumlahCancel = cancel[0].jumlah;
            hargaCancel = cancel[0].harga;
            jumlah -= cancel[0].jumlah;
            totalSemua -= cancel[0].total;

            if (isNotNullOrEmpty(data.dataPromoCancelOrder)) {
              promoCancel = data.dataPromoCancelOrder
                  .where((element) =>
                      element.orderCode == orderCode &&
                      element.inventoryCode == inventoryCode &&
                      element.orderCancelCode == cancel![0].cancelOrderCode)
                  .toList();
              if (isNotNullOrEmpty(promoCancel)) {
                hargaPromo -= promoCancel[0].promoPrice;
              }
            }
          }
        }
        orderFix.add(OrderFinalModel(
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
        ));
      }
    }

    //HEADER
    await bluetooth.writeBytes(center);
    await bluetooth.write('${data.dataOutlet.namaOutlet}\n');
    await bluetooth.write('${data.dataOutlet.alamatOutlet}\n');
    await bluetooth.write('${data.dataOutlet.kota}\n');
    await bluetooth.write('${data.dataOutlet.telepon}\n');
    await bluetooth.printNewLine();
    await bluetooth.writeBytes(bold);
    await bluetooth.write('Transfer Room');
    await bluetooth.printNewLine();
    await bluetooth.printNewLine();
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
    await bluetooth.write(formatTable('Sewa Ruangan',
        Formatter.formatRupiah(data.dataInvoice.sewaRuangan), 48));
    if (data.dataInvoice.promo > 0) {
      await bluetooth.write(formatTable(
          'Promo', '(${Formatter.formatRupiah(data.dataInvoice.promo)})', 48));
    }
/*
    if ((data.voucherValue?.roomPrice ?? 0) > 0) {
      await bluetooth.write(formatTable(
          'Voucher Room',
          '(${Formatter.formatRupiah((data.voucherValue?.roomPrice ?? 0))})',
          48));
    }
    */

    //FnB
    if (isNotNullOrEmpty(orderFix)) {
      await printFnB(orderFix, bluetooth);
    }

            await bluetooth.write('------------------------------------------------\n');
    await bluetooth.write(formatTable('Jumlah Ruangan',
        Formatter.formatRupiah(data.dataInvoice.jumlahRuangan), 48));
    await bluetooth.write(formatTable('Jumlah Penjualan',
        Formatter.formatRupiah(data.dataInvoice.jumlahPenjualan), 48));
    await bluetooth
        .write('------------------------------------------------\n\n');
    //Tax And Service
    await printFooter(
        bluetooth, data.dataInvoice, data.dataServiceTaxPercent, 1);

    await bluetooth.write(formatTableRow('Jumlah Bersih',
        Formatter.formatRupiah(data.dataInvoice.jumlahBersih), 48,
        leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));

    await bluetooth.printNewLine();
    await bluetooth.printNewLine();

    return;
  }

  Future<void> printFooter(BlueThermalPrinter bt, InvoiceModel ivc,
      ServiceTaxPercentModel tns, int style) async {
    if (style == 1) {
      await bt.write(formatTableRow(
          'Jumlah', Formatter.formatRupiah(ivc.jumlah), 48,
          leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
      await bt.write(formatTableRow('Service FnB ${tns.serviceFnbPercent}%',
          Formatter.formatRupiah(ivc.fnbService), 48,
          leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
      await bt.write(formatTableRow('Service Room ${tns.serviceRoomPercent}%',
          Formatter.formatRupiah(ivc.roomService), 48,
          leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
      await bt.write(formatTableRow('Pajak FnB ${tns.taxFnbPercent}%',
          Formatter.formatRupiah(ivc.fnbTax), 48,
          leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
      await bt.write(formatTableRow('Pajak Room ${tns.taxRoomPercent}%',
          Formatter.formatRupiah(ivc.roomTax), 48,
          leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
      await bt.writeBytes(right);
      await bt.write('----------------\n');
      await bt.writeBytes(normal);
      await bt.write(formatTableRow(
          'Total', Formatter.formatRupiah(ivc.jumlahTotal), 48,
          leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
      await bt.write('----------------\n');
    } else if (style == 2) {
      await bt.write(formatTableRow(
          'Jumlah', Formatter.formatRupiah(ivc.jumlah), 48,
          leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
    } else {
      await bt.write(formatTableRow(
          'Jumlah', Formatter.formatRupiah(ivc.jumlah), 48,
          leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
    }
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

String formatTableRow(String leftText, String rightText, int totalWidth,
      {int leftSize = 0,
      int rightSize = 0,
      bool alignRight = false,
      bool alignLeft = false}) {
    // Use the actual text length if size is not provided
    int leftTextLength = leftSize > 0 ? leftSize : leftText.length;
    int rightTextLength = rightSize > 0 ? rightSize : rightText.length;

    // Adjust the left text based on alignment
    String leftPart = alignLeft
        ? leftText.padLeft(leftTextLength)
        : leftText.padRight(leftTextLength);
    if (leftTextLength > 0 && leftText.length > leftTextLength) {
      leftPart = leftText.substring(0, leftTextLength);
    }

    // Adjust the right text based on alignment
    String rightPart = alignRight
        ? rightText.padLeft(rightTextLength)
        : rightText.padRight(rightTextLength);
    if (rightTextLength > 0 && rightText.length > rightTextLength) {
      rightPart = rightText.substring(0, rightTextLength);
    }

    // Calculate space needed between left and right parts
    int spaceBetween = totalWidth - (leftPart.length + rightPart.length);
    spaceBetween = spaceBetween > 0 ? spaceBetween : 0;

    // Combine the parts with spacing
    return '$leftPart${' ' * spaceBetween}$rightPart\n';
  }

}