import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/model/invoice_response.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/printer_helper.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:intl/intl.dart';

class LanprintExecutor {
  Future<void> testPrint() async {
    PrinterModel printerConfig = PreferencesData.getPrinter();
    // Validasi printer config
    if (printerConfig.address.isEmpty) {
      showToastError('IP Address LAN Printer belum diset');
      return;
    }

    // Port configuration untuk ESC/POS printer
    // Port umum: 9100 (default), 9101, 9102, 515 (LPD)
    const int defaultPort = 9100;

    // Parse IP dan Port
    String ip;
    int port;

    if (printerConfig.address.contains(':')) {
      // Format: 192.168.1.222:9100
      final parts = printerConfig.address.split(':');
      ip = parts[0];
      port = int.tryParse(parts[1]) ?? defaultPort;
    } else {
      // Format: 192.168.1.222 (tanpa port)
      ip = printerConfig.address;
      port = defaultPort;
    }

    // SESUAI DOKUMENTASI: Gunakan FlutterThermalPrinterNetwork
    final service = FlutterThermalPrinterNetwork(ip, port: port);

    try {
      // Connect ke printer
      await service.connect();

      // Load capability profile
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      final helper = ReceiptPrinterHelper(generator);

      // Generate test print data
      List<int> bytes = [];

      // IMPORTANT: Tambah ESC @ (Initialize printer)
      bytes += [0x1B, 0x40];

      bytes += helper.feed(2);
      bytes +=
          helper.text("TEST PRINT LAN", bold: true, align: PosAlign.center);
      bytes += helper.divider();
      bytes +=
          helper.text("Happy Puppy POS", bold: true, align: PosAlign.center);
      bytes += helper.feed(1);
      bytes += helper.text("Printer : ${printerConfig.name}");
      bytes += helper.text("IP      : $ip:$port");
      bytes += helper.text("Type    : LAN Network");
      bytes += helper.feed(1);
      bytes += helper.divider();
      bytes += helper.text("Test print berhasil!",
          bold: true, align: PosAlign.center);
      bytes += helper.divider();
      bytes += helper.feed(1);
      bytes += helper.row("Kiri", "Kanan");
      bytes += helper.feed(1);
      bytes += helper.table(
          "kirikirikirikiri", "tengahtengahtengah1", "kanankanankanan1",
          leftAlign: PosAlign.left,
          centerAlign: PosAlign.left,
          rightAlign: PosAlign.left);
      bytes += helper.feed(3);

      // CRITICAL: Tambah CUT command (GS V)
      bytes += helper.cut();
      // Print data - SESUAI DOKUMENTASI: gunakan printTicket()
      await service.printTicket(bytes);

      showToastSuccess('Test print LAN berhasil!');
    } catch (e) {
      debugPrint('Error during LAN print: $e');
      showToastError('Gagal test print LAN: ${e.toString()}');
      rethrow;
    } finally {
      // Disconnect - SESUAI DOKUMENTASI: gunakan service.disconnect()
      try {
        debugPrint('Disconnecting from LAN printer...');
        await service.disconnect();
        debugPrint('Disconnected successfully');
      } catch (e) {
        debugPrint('Error during disconnect: $e');
        // Tidak perlu show toast untuk disconnect error
      }
      debugPrint('END PRINT TEST LAN PRINTER');
    }
  }

  void printInvoice(PrintInvoiceModel data) async {
    final service = getService();
    try {
      await service.connect();
      // Load capability profile
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      final helper = ReceiptPrinterHelper(generator);

      // Generate test print data
      List<int> bytes = [];
      // IMPORTANT: Tambah ESC @ (Initialize printer)
      bytes += [0x1B, 0x40];

      final user = PreferencesData.getUser().userId;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);

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
      bytes += [0x1B, 0x40];
      bytes += helper.feed(2);
      bytes += helper.textCenter(data.dataOutlet.namaOutlet);
      bytes += helper.textCenter(data.dataOutlet.alamatOutlet);
      bytes += helper.textCenter(data.dataOutlet.kota);
      bytes += helper.textCenter(data.dataOutlet.telepon);
      bytes += helper.feed(1);
      bytes += helper.textCenter('INVOICE', bold: true);
      bytes += helper.feed(2);
      //Checkin Info
      bytes += helper.text('Ruangan : ${data.dataRoom.roomCode}');
      bytes += helper.text('Nama    : ${data.dataRoom.nama}');
      bytes += helper.text('Tanggal : ${data.dataRoom.tanggal}');
      bytes += helper.feed(1);
      bytes += helper.table('Sewa Ruangan', '',
          Formatter.formatRupiah(data.dataInvoice.sewaRuangan),
          rightAlign: PosAlign.right);
      if (data.dataInvoice.promo > 0) {
        bytes += helper.table(
            'Promo', '', '(${Formatter.formatRupiah(data.dataInvoice.promo)})',
            rightAlign: PosAlign.right);
      }
      if ((data.voucherValue?.roomPrice ?? 0) > 0) {
        bytes += helper.table('Voucher Room', '',
            '(${Formatter.formatRupiah(data.voucherValue!.roomPrice)})',
            rightAlign: PosAlign.right);
      }
      //FnB
      if (isNotNullOrEmpty(orderFix)) {}
      bytes += helper.feed(3);
      bytes += helper.cut();
      await service.printTicket(bytes);
      showToastSuccess('Cetak Invoice berhasil!');
    } catch (e) {
      showToastError('Error Print Invoice LAN ${e.toString()}');
    } finally {
      try {
        await service.disconnect();
      } catch (e) {
        //ignore disconnect error
      }
    }
/*
    bluetooth.isConnected.then((isConnected) async{
      if(isConnected != true){
        showToastError('Gagal Print Invoice');
        return;
      }

      await bluetooth.writeBytes(normal);

      //HEADER
      await bluetooth.writeBytes(center);
      await bluetooth.write('${data.dataOutlet.namaOutlet}\n');
      await bluetooth.write('${data.dataOutlet.alamatOutlet}\n');
      await bluetooth.write('${data.dataOutlet.kota}\n');
      await bluetooth.write('${data.dataOutlet.telepon}\n');
      await bluetooth.printNewLine();
      await bluetooth.writeBytes(bold);
      await bluetooth.write('INVOICE');
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
      await bluetooth.printNewLine();
      await bluetooth.writeBytes(left);

      //Room Info
      await bluetooth.write(formatTable('Sewa Ruangan', Formatter.formatRupiah(data.dataInvoice.sewaRuangan), 48));
      if (data.dataInvoice.promo > 0) {
        await bluetooth.write(formatTable('Promo', '(${Formatter.formatRupiah(data.dataInvoice.promo)})', 48));
      }

      if((data.voucherValue?.roomPrice ?? 0) > 0) {
        await bluetooth.write(formatTable('Voucher Room', '(${Formatter.formatRupiah((data.voucherValue?.roomPrice ?? 0))})', 48));
      }

      //FnB
      if (isNotNullOrEmpty(orderFix)) {
        await printFnB(orderFix, bluetooth);
        if (data.voucherValue != null && (data.voucherValue?.fnbPrice ?? 0) > 0) {
          await bluetooth.write(formatTable('Voucher FnB', '(${Formatter.formatRupiah((data.voucherValue?.fnbPrice ?? 0))})',48));
        }

        num totalPromo = 0;
        for (var element in orderFix) {
          totalPromo += element.hargaPromo;
        }

        if((PreferencesData.getShowTotalItemPromo() || PreferencesData.getShowPromoBelowItem() == false ) == true && totalPromo >0){
          await bluetooth.printNewLine();
          await bluetooth.write(formatTable('Total Promo Item', '(${Formatter.formatRupiah(totalPromo)})', 48));
        }
      }

      await bluetooth.write('------------------------------------------------\n');
      await bluetooth.write(formatTable('Jumlah Ruangan', Formatter.formatRupiah(data.dataInvoice.jumlahRuangan), 48));
      await bluetooth.write(formatTable('Jumlah Penjualan', Formatter.formatRupiah(data.dataInvoice.jumlahPenjualan), 48));
      await bluetooth.write('------------------------------------------------\n\n');
      //Tax And Service
      await printFooter( bluetooth, data.dataInvoice, data.dataServiceTaxPercent, (data.footerStyle ?? 1));

      if (data.voucherValue != null && (data.voucherValue?.price ?? 0) > 0) {
        await bluetooth.write(formatTable('Voucher', '(${Formatter.formatRupiah((data.voucherValue?.price ?? 0))})',48));
      }

      if (isNotNullOrEmpty(data.transferList)) {
        await bluetooth.writeBytes(right);
        await bluetooth.write('Transfer Room\n');
        await bluetooth.writeBytes(normal);
        for (var teep in data.transferList) {
          await bluetooth.write(formatTableRow( teep.room, Formatter.formatRupiah(teep.transferTotal), 48, leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
        }
        await bluetooth.printNewLine();
      }

      await bluetooth.write(formatTableRow('Jumlah Bersih', Formatter.formatRupiah(data.dataInvoice.jumlahBersih), 48, leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));

      if(isNotNullOrEmpty(data.paymentList)){
        for(var payment in data.paymentList){
          await bluetooth.write(formatTableRow(payment.paymentName, Formatter.formatRupiah(payment.value), 48, leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
        }
      }else{
        await bluetooth.write('Data Pembayaran Tidak Ditemukan');
      }
      await bluetooth.writeBytes(right);
      await bluetooth.write('----------------\n');
      await bluetooth.write(Formatter.formatRupiah(data.payment.payValue));
      await bluetooth.printNewLine();
      await bluetooth.printCustom('Kembali ${Formatter.formatRupiah(data.payment.payChange)}', Size.boldMedium.val, Align.right.val);
      await bluetooth.printNewLine();
      await bluetooth.printNewLine();
      await bluetooth.writeBytes(right);
      await bluetooth.writeBytes(normal);
      await bluetooth.write('$formattedDate $user');
      await bluetooth.printNewLine();
    if (isNotNullOrEmpty(data.transferData)) {
        for (var teepData in data.transferData) {
          await bluetooth.printNewLine();
          await bluetooth.printNewLine();
          await printTransfer(bluetooth, teepData, (data.footerStyle??1));
        }
    }
    });
*/
    ApiRequest().updatePrintState(data.dataInvoice.reception, '2');
  }

  List<int> printFnB(
      List<OrderFinalModel> orderFix, ReceiptPrinterHelper helper) {
    List<int> bytes = [];
    final fnbList = mergeItems(orderFix);

    bytes += helper.text('Rincian Penjualan');
    for (var fnb in fnbList) {
      bytes += helper.text(fnb.namaItem);
      bytes += helper.table(
          '${fnb.jumlah + fnb.jumlahCancel} x ${Formatter.formatRupiah(fnb.hargaSatuan)}',
          '',
          Formatter.formatRupiah(fnb.totalSemua + fnb.hargaCancel),
          rightAlign: PosAlign.right);
      if (PreferencesData.getShowPromoBelowItem() == true && fnb.hargaPromo > 0) {
        bytes += helper.table(
            fnb.promoName, '', '(${Formatter.formatRupiah(fnb.hargaPromo)})',
            rightAlign: PosAlign.right);
      }
    }
    return bytes;
  }

  List<OrderFinalModel> mergeItems(List<OrderFinalModel> orderList) {
    var groupedOrders = groupBy<OrderFinalModel, String>(
        orderList,
        (order) =>
            '${order.inventoryCode}-${order.namaItem}-${order.hargaSatuan}');

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

  FlutterThermalPrinterNetwork getService() {
    PrinterModel printerConfig = PreferencesData.getPrinter();
    // Validasi printer config
    if (printerConfig.address.isEmpty) {
      showToastError('IP Address LAN Printer belum diset');
      throw Exception('IP Address LAN Printer belum diset');
    }

    // Port configuration untuk ESC/POS printer
    // Port umum: 9100 (default), 9101, 9102, 515 (LPD)
    const int defaultPort = 9100;

    // Parse IP dan Port
    String ip;
    int port;

    if (printerConfig.address.contains(':')) {
      // Format: 192.168.1.222:9100
      final parts = printerConfig.address.split(':');
      ip = parts[0];
      port = int.tryParse(parts[1]) ?? defaultPort;
    } else {
      // Format: 192.168.1.222 (tanpa port)
      ip = printerConfig.address;
      port = defaultPort;
    }

    // SESUAI DOKUMENTASI: Gunakan FlutterThermalPrinterNetwork
    return FlutterThermalPrinterNetwork(ip, port: port);
  }
}
