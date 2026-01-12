

import 'package:collection/collection.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/model/checkin_slip_response.dart';
import 'package:front_office_2/data/model/invoice_response.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/data/model/sol_response.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/printer/format_helper/command_helper.dart';
import 'package:intl/intl.dart';

class EscPosGenerator {
  

  static List<int> testPrint(CommandHelper helper){
    List<int> bytes = [];
    bytes += [0x1B, 0x40];
    bytes += helper.feed(1);
    bytes += helper.text("PRINT TEST", bold: true, align: PosAlign.center);
    bytes += helper.divider();
    bytes += helper.text("Normal Text", align: PosAlign.left);
    bytes += helper.text("Bold Text Center", bold: true, align: PosAlign.center);
    bytes += helper.text("Double Width", width: PosTextSize.size2);
    bytes += helper.text("Double Width bold", width: PosTextSize.size2, bold: true);
    bytes += helper.text("Double Height", height: PosTextSize.size2, align: PosAlign.center);
    bytes += helper.text("Double Height bold", height: PosTextSize.size2, align: PosAlign.center, bold: true);
    bytes += helper.text("Normal Text", align: PosAlign.left);
    bytes += helper.feed(1);
    bytes += helper.divider();
    bytes += helper.textCenter("Test Complete", bold: true);
    bytes += helper.feed(3);
    bytes += helper.cut();

    return bytes;
  }

  List<int> printSlipCheckin(CheckinSlipModel data, CommandHelper helper){
    List<int> bytes = [];
    bytes += [0x1B, 0x40];
    bytes += helper.textCenter(data.outlet.namaOutlet);
    bytes += helper.textCenter(data.outlet.alamatOutlet);
    bytes += helper.textCenter(data.outlet.kota);
    bytes += helper.textCenter(data.outlet.telepon);
    bytes += helper.feed(1);
    bytes += helper.textCenter('SLIP CHECK IN', bold: true);
    bytes += helper.feed(1);
    bytes += helper.text('Ruangan           : ${data.detail.roomName}');
    bytes += helper.text('Nama              : ${data.detail.name}');
    bytes += helper.text('Jumlah Tamu       : ${data.detail.pax}');
    bytes += helper.text('Jenis Kamar       : ${data.detail.roomType}');
    bytes += helper.text('Jam Checkin       : ${data.detail.checkinTime}');
    bytes += helper.text('Lama Sewa         : ${data.detail.checkinDuration}');
    bytes += helper.text('Jumlah Biaya Sewa : ${Formatter.formatRupiah(data.detail.checkinFee)}');
    bytes += helper.text('Jam Checkout      : ${data.detail.checkoutTime}');
    bytes += helper.divider();
    bytes += helper.textCenter('PERNYATAAN', bold: true);
    bytes += helper.feed(3);
    bytes += helper.text('Saya&rekan tidak akan membawa masuk dan');
    bytes += helper.text('mengkonsumsi makanan/minuman yang bukan');
    bytes += helper.text('berasal  dari  outlet  ini apabila saya');
    bytes += helper.text('terbukti, saya bersedia dikenakan denda');
    bytes += helper.text('sesuai daftar yang berlaku', align: PosAlign.center);
    bytes += helper.feed(2);
    bytes += helper.text('Tanda tangan tamu:', align: PosAlign.left);
    bytes += helper.feed(2);
    bytes += helper.text(data.detail.name, align: PosAlign.left);
    bytes += helper.text(data.detail.phone, align: PosAlign.left);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);
    bytes += helper.row('', formattedDate);
    bytes += helper.feed(3);
    bytes += helper.cut();
    return bytes;
  }

  List<int> printBillGenerator(PreviewBillModel data, CommandHelper helper){
    final user = GlobalProviders.read(userProvider).userId;
    final printer = GlobalProviders.read(printerProvider);
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
          promo = data.dataPromoOrder.where((element) =>
            element.orderCode == orderCode &&
            element.inventoryCode == inventoryCode).toList();
          if (isNotNullOrEmpty(promo)) {
            promoName = promo[0].promoName;
            hargaPromo += promo[0].promoPrice;
          }
        }

        if (isNotNullOrEmpty(data.dataCancelOrder)) {
          cancel = data.dataCancelOrder.where((element) => element.orderCode == orderCode &&
            element.inventoryCode == inventoryCode).toList();
          if (isNotNullOrEmpty(cancel)) {
            jumlahCancel = cancel[0].jumlah;
            hargaCancel = cancel[0].harga;
            jumlah -= cancel[0].jumlah;
            totalSemua -= cancel[0].total;

            if (isNotNullOrEmpty(data.dataPromoCancelOrder)) {
              promoCancel = data.dataPromoCancelOrder.where((element) =>
                element.orderCode == orderCode &&
                element.inventoryCode == inventoryCode &&
                element.orderCancelCode == cancel![0].cancelOrderCode).toList();
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
    List<int> bytes = [];
    bytes += [0x1B, 0x40];
    bytes += helper.feed(2);
    bytes += helper.textCenter(data.dataOutlet.namaOutlet);
    bytes += helper.textCenter(data.dataOutlet.alamatOutlet);
    bytes += helper.textCenter(data.dataOutlet.kota);
    bytes += helper.textCenter(data.dataOutlet.telepon);
    bytes += helper.feed(1);
    bytes += helper.textCenter('TAGIHAN', bold: true);
    bytes += helper.feed(1);
    //Checkin Info
    bytes += helper.text('Ruangan : ${data.dataRoom.roomCode}');
    bytes += helper.text('Nama    : ${data.dataRoom.nama}');
    bytes += helper.text('Tanggal : ${data.dataRoom.tanggal}');
    bytes += helper.feed(1);
    bytes += helper.table('Sewa Ruangan', '', Formatter.formatRupiah(data.dataInvoice.sewaRuangan), rightAlign: PosAlign.right);
    if (data.dataInvoice.promo > 0) {
      bytes += helper.table('Promo', '', '(${Formatter.formatRupiah(data.dataInvoice.promo)})', rightAlign: PosAlign.right);
    }
    if ((data.voucherValue?.roomPrice ?? 0) > 0) {
      bytes += helper.table('Voucher Room', '', '(${Formatter.formatRupiah(data.voucherValue!.roomPrice)})', rightAlign: PosAlign.right);
    }
          if (isNotNullOrEmpty(orderFix)) {
        bytes += _printFnB(orderFix, helper);
        if (data.voucherValue != null && (data.voucherValue?.fnbPrice ?? 0) > 0) {
          bytes += helper.table('Voucher FnB', '', '(${Formatter.formatRupiah((data.voucherValue?.fnbPrice ?? 0))})', rightAlign: PosAlign.right);
        }
        num totalPromo = 0;
        for (var element in orderFix) {
          totalPromo += element.hargaPromo;
        }
      if ((GlobalProviders.read(showTotalItemPromoProvider) || GlobalProviders.read(showPromoBelowItemProvider) == false) == true && totalPromo > 0) {
          bytes += helper.feed(1);
          bytes += helper.row('Total Promo Item', Formatter.formatRupiah(totalPromo));
        }
      }
      bytes += helper.divider();
      bytes += helper.row('Jumlah Ruangan', Formatter.formatRupiah(data.dataInvoice.jumlahRuangan));
      bytes += helper.row('Jumlah Penjualan', Formatter.formatRupiah(data.dataInvoice.jumlahPenjualan));
      bytes += helper.divider();
      bytes += _printFooter(helper, data.dataInvoice, data.dataServiceTaxPercent, (data.footerStyle??1));
      if (data.voucherValue != null && (data.voucherValue?.price ?? 0) > 0) {
        bytes += helper.table('Voucher', '', '(${Formatter.formatRupiah((data.voucherValue?.price ?? 0))})', rightAlign: PosAlign.right);
      }
      if (isNotNullOrEmpty(data.transferList)) {
        bytes += helper.feed(1);
        bytes += helper.row('','Transfer Room');
        for (var teep in data.transferList) {
          bytes += helper.tableWithMaxChars('', teep.room, Formatter.formatRupiah(teep.transferTotal), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
        }
        bytes += helper.feed(1);
      }
      bytes += helper.tableWithMaxChars('', 'Jumlah Bersih', Formatter.formatRupiah(data.dataInvoice.jumlahBersih), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.feed(1);
      bytes += helper.text(Formatter.formatRupiah(data.dataInvoice.jumlahBersih),
        bold: true,
        height: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size2: PosTextSize.size1, 
        width: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size1: PosTextSize.size2
      );
      bytes += helper.feed(1);
      bytes += helper.row('', '$formattedDate $user');
      
      bytes += helper.feed(3);
      if(isNotNullOrEmpty(data.transferData)){
        for (var element in data.transferData) {
          bytes += _printTransfer(helper, element, data.footerStyle ?? 1);
        }
      }
    return bytes;
  }

  List<int> printInvoice(PrintInvoiceModel data, CommandHelper helper){
    List<int> bytes = [];
    bytes += [0x1B, 0x40];

    final user = GlobalProviders.read(userProvider).userId;
    final printer = GlobalProviders.read(printerProvider);
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
          promo = data.dataPromoOrder.where((element) =>
            element.orderCode == orderCode &&
            element.inventoryCode == inventoryCode).toList();
            if (isNotNullOrEmpty(promo)) {
              promoName = promo[0].promoName;
              hargaPromo += promo[0].promoPrice;
            }
          }

          if (isNotNullOrEmpty(data.dataCancelOrder)) {
            cancel = data.dataCancelOrder.where((element) => element.orderCode == orderCode &&
              element.inventoryCode == inventoryCode).toList();
            if (isNotNullOrEmpty(cancel)) {
              jumlahCancel = cancel[0].jumlah;
              hargaCancel = cancel[0].harga;
              jumlah -= cancel[0].jumlah;
              totalSemua -= cancel[0].total;

              if (isNotNullOrEmpty(data.dataPromoCancelOrder)) {
                promoCancel = data.dataPromoCancelOrder.where((element) =>
                  element.orderCode == orderCode && element.inventoryCode == inventoryCode && element.orderCancelCode == cancel![0].cancelOrderCode).toList();
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
      bytes += helper.feed(1);
      //Checkin Info
      bytes += helper.text('Ruangan : ${data.dataRoom.roomCode}');
      bytes += helper.text('Nama    : ${data.dataRoom.nama}');
      bytes += helper.text('Tanggal : ${data.dataRoom.tanggal}');
      bytes += helper.feed(1);
      bytes += helper.table('Sewa Ruangan', '', Formatter.formatRupiah(data.dataInvoice.sewaRuangan), rightAlign: PosAlign.right);
      if (data.dataInvoice.promo > 0) {
        bytes += helper.table('Promo', '', '(${Formatter.formatRupiah(data.dataInvoice.promo)})', rightAlign: PosAlign.right);
      }
      if ((data.voucherValue?.roomPrice ?? 0) > 0) {
        bytes += helper.table('Voucher Room', '', '(${Formatter.formatRupiah(data.voucherValue!.roomPrice)})', rightAlign: PosAlign.right);
      }
      //FnB
      if (isNotNullOrEmpty(orderFix)) {
        bytes += _printFnB(orderFix, helper);
        if (data.voucherValue != null && (data.voucherValue?.fnbPrice ?? 0) > 0) {
          bytes += helper.table('Voucher FnB', '', '(${Formatter.formatRupiah((data.voucherValue?.fnbPrice ?? 0))})', rightAlign: PosAlign.right);
        }
        num totalPromo = 0;
        for (var element in orderFix) {
          totalPromo += element.hargaPromo;
        }
      if ((GlobalProviders.read(showTotalItemPromoProvider) || GlobalProviders.read(showPromoBelowItemProvider) == false) == true && totalPromo > 0) {
          bytes += helper.feed(1);
          bytes += helper.row('Total Promo Item', Formatter.formatRupiah(totalPromo));
        }
      }
      bytes += helper.divider();
      bytes += helper.row('Jumlah Ruangan', Formatter.formatRupiah(data.dataInvoice.jumlahRuangan));
      bytes += helper.row('Jumlah Penjualan', Formatter.formatRupiah(data.dataInvoice.jumlahPenjualan));
      bytes += helper.divider();
      bytes += _printFooter(helper, data.dataInvoice, data.dataServiceTaxPercent, (data.footerStyle??1));
      if (data.voucherValue != null && (data.voucherValue?.price ?? 0) > 0) {
        bytes += helper.table('Voucher', '', '(${Formatter.formatRupiah((data.voucherValue?.price ?? 0))})', rightAlign: PosAlign.right);
      }
      if (isNotNullOrEmpty(data.transferList)) {
        bytes += helper.feed(1);
        bytes += helper.row('','Transfer Room');
        for (var teep in data.transferList) {
          bytes += helper.tableWithMaxChars('', teep.room, Formatter.formatRupiah(teep.transferTotal), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
        }
        bytes += helper.feed(1);
      }

      bytes += helper.tableWithMaxChars('', 'Jumlah Bersih', Formatter.formatRupiah(data.dataInvoice.jumlahBersih), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      if (isNotNullOrEmpty(data.paymentList)) {
        for (var payment in data.paymentList) {
          bytes += helper.tableWithMaxChars('', payment.paymentName, Formatter.formatRupiah(payment.value), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15, centerBold: true);
        }
      } else {
        bytes += helper.row('', 'Data Pembayaran Tidak Ditemukan');
      }
      bytes += helper.row('', '----------------');
      bytes += helper.row('', Formatter.formatRupiah(data.payment.payValue));
      bytes += helper.feed(1);
      bytes += helper.text('Kembali: ${Formatter.formatRupiah(data.payment.payChange)}', bold: true, align: PosAlign.center, 
        height: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size2: PosTextSize.size1, 
        width: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size1: PosTextSize.size2
      );
      bytes += helper.feed(1);
      bytes += helper.row('', '$formattedDate $user');
      bytes += helper.feed(3);
      if(isNotNullOrEmpty(data.transferData)){
        for (var element in data.transferData) {
          bytes += _printTransfer(helper, element, data.footerStyle ?? 1);
        }
      }
      bytes += helper.cut();
      return bytes;
  }

  List<int> printSo(SolPrintModel data, String roomCode, String guestName, int pax,CommandHelper helper){
    List<int> bytes = [];
    bytes += [0x1B, 0x40];

    final user = GlobalProviders.read(userProvider).userId;
    final printer = GlobalProviders.read(printerProvider);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('HH:mm').format(now);

    // bytes += helper.textCenter(data.outlet.namaOutlet);
    // bytes += helper.textCenter(data.outlet.alamatOutlet);
    // bytes += helper.textCenter(data.outlet.kota);
    // bytes += helper.textCenter(data.outlet.telepon);
    // bytes += helper.feed(1);
    // bytes += helper.textCenter(data.outlet.telepon, bold: true);
    // bytes += helper.feed(1);
    bytes += helper.textCenter('SLIP ORDER', bold: true);
    bytes += helper.feed(1);

    bytes += helper.tableWithMaxChars('Ruangan  : ', roomCode, '',
      centerTextWidth: PosTextSize.size2,
      centerAlign: PosAlign.left,
      maxLeftChars: 13
    );
    bytes += helper.tableWithMaxChars('Jam      : ',  formattedDate,'',
      centerTextWidth: PosTextSize.size2,
      centerAlign: PosAlign.left,
      maxLeftChars: 13
    );
    bytes += helper.tableWithMaxChars('Nama     : ', guestName, '',
      centerAlign: PosAlign.left,
      maxLeftChars: 13);
    bytes += helper.tableWithMaxChars('Pax      : ', pax.toString(), '',
      centerAlign: PosAlign.left,
      maxLeftChars: 13);
    bytes += helper.tableWithMaxChars('No Bukti : ', roomCode, '',
      centerAlign: PosAlign.left,
      maxLeftChars: 13);
    bytes += helper.divider();

    for (var order in data.solList) {
      bytes += helper.text('${order.qty} ${order.name}',
        width: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size1: PosTextSize.size2,
        height: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size2: PosTextSize.size1
      );
      if(isNotNullOrEmpty(order.note)){
        bytes += helper.text('  ${order.note}');
        bytes += helper.feed(1);
      }
    }

    bytes += helper.divider();
    bytes += helper.text('Dibuat Oleh: $user', align: PosAlign.right);
    bytes += helper.feed(1);
    bytes += helper.cut();
    return bytes;
  }

  List<int> printDo(OrderedModel order, String roomCode, CommandHelper helper){
    List<int> bytes = [];
    bytes += [0x1B, 0x40];

    final user = GlobalProviders.read(userProvider).userId;
    final printer = GlobalProviders.read(printerProvider);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('HH:mm').format(now);

    // bytes += helper.textCenter(data.outlet.namaOutlet);
    // bytes += helper.textCenter(data.outlet.alamatOutlet);
    // bytes += helper.textCenter(data.outlet.kota);
    // bytes += helper.textCenter(data.outlet.telepon);
    // bytes += helper.feed(1);
    // bytes += helper.textCenter(data.outlet.telepon, bold: true);
    // bytes += helper.feed(1);
    bytes += helper.textCenter('DELIVERY ORDER', bold: true);
    bytes += helper.feed(1);

    bytes += helper.tableWithMaxChars('Ruangan  : ', roomCode, '',
      centerTextWidth: PosTextSize.size2,
      centerAlign: PosAlign.left,
      maxLeftChars: 13
    );
    bytes += helper.tableWithMaxChars('Jam      : ',  formattedDate,'',
      centerTextWidth: PosTextSize.size2,
      centerAlign: PosAlign.left,
      maxLeftChars: 13
    );
    bytes += helper.tableWithMaxChars('No Bukti : ', order.sol??'', '',
      centerAlign: PosAlign.left,
      maxLeftChars: 13);
    bytes += helper.divider();

    // for (var order in data.solList) {
    //   bytes += helper.text('${order.qty} ${order.name}',
    //     width: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size1: PosTextSize.size2,
    //     height: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size2: PosTextSize.size1
    //   );
    //   if(isNotNullOrEmpty(order.note)){
    //     bytes += helper.text('  ${order.note}'??'');
    //     bytes += helper.feed(1);
    //   }
    // }

    bytes += helper.text('${order.qty} ${order.name}',
        width: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size1: PosTextSize.size2,
        height: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size2: PosTextSize.size1
    );
    if(isNotNullOrEmpty(order.notes)){
      bytes += helper.text('  ${order.notes}');
      bytes += helper.feed(1);
    }

    bytes += helper.divider();
    bytes += helper.text('Dibuat Oleh: $user', align: PosAlign.right);
    bytes += helper.feed(1);
    bytes += helper.cut();
    return bytes;
  }


  List<int> _printFnB(List<OrderFinalModel> orderFix, helper) {
    List<int> bytes = [];
    final fnbList = _mergeItems(orderFix);
    bytes += helper.feed(1);
    bytes += helper.text('Rincian Penjualan');
    bytes += helper.feed(1);

    for (var fnb in fnbList) {
      if (GlobalProviders.read(showReturProvider) == true) {
        bytes += helper.text(fnb.namaItem);
        bytes += helper.row(
            '${fnb.jumlah + fnb.jumlahCancel} x ${Formatter.formatRupiah(fnb.hargaSatuan)}',
            Formatter.formatRupiah(fnb.totalSemua + fnb.hargaCancel));
        if (fnb.jumlahCancel > 0) {
          bytes += helper.row(
            '  RETUR ${fnb.namaItem} x ${fnb.jumlahCancel}',
            '(${Formatter.formatRupiah(fnb.hargaCancel)})',
          );
        }
        if (fnb.hargaPromo > 0 &&
            GlobalProviders.read(showPromoBelowItemProvider) == true) {
          bytes += helper.row(
            fnb.promoName,
            '(${Formatter.formatRupiah(fnb.hargaPromo)})',
          );
        }
      } else {
        if (fnb.jumlah > 0) {
          bytes += helper.text(fnb.namaItem);
          bytes += helper.row(
            ' ${fnb.jumlah} x ${Formatter.formatRupiah(fnb.hargaSatuan)}',
            Formatter.formatRupiah(fnb.totalSemua),
          );
          if (fnb.hargaPromo > 0 &&
              GlobalProviders.read(showPromoBelowItemProvider) == true) {
            bytes += helper.row(
              fnb.promoName,
              '(${Formatter.formatRupiah(fnb.hargaPromo)})',
            );
          }
        }
      }
    }
    return bytes;
  }

  List<int> _printFooter(CommandHelper helper, InvoiceModel ivc, ServiceTaxPercentModel tns, int style) {
    List<int> bytes = [];
    if (style == 1) {
      bytes += helper.tableWithMaxChars('', 'Jumlah', Formatter.formatRupiah(ivc.jumlah), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.tableWithMaxChars('', 'Service FnB ${tns.serviceFnbPercent}%', Formatter.formatRupiah(ivc.fnbService), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.tableWithMaxChars('', 'Service Room ${tns.serviceRoomPercent}%', Formatter.formatRupiah(ivc.roomService), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.tableWithMaxChars('', 'Pajak FnB ${tns.taxFnbPercent}%', Formatter.formatRupiah(ivc.fnbTax), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.tableWithMaxChars('', 'Pajak Room ${tns.taxRoomPercent}%', Formatter.formatRupiah(ivc.roomTax), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.row('','----------------');
      bytes += helper.tableWithMaxChars('', 'Total', Formatter.formatRupiah(ivc.jumlahTotal), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.row('','----------------');
   } else if (style == 2) {
      bytes += helper.tableWithMaxChars('', 'Jumlah', Formatter.formatRupiah(ivc.jumlah), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.tableWithMaxChars('', 'Jumlah Service ${(tns.serviceFnbPercent + tns.serviceRoomPercent) / 2}%', Formatter.formatRupiah(ivc.fnbService + ivc.roomService), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.tableWithMaxChars('', 'Jumlah pajak ${(tns.taxFnbPercent + tns.taxRoomPercent) / 2}%', Formatter.formatRupiah(ivc.fnbTax + ivc.roomTax), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.row('','----------------');
      bytes += helper.tableWithMaxChars('', 'Total', Formatter.formatRupiah(ivc.jumlahTotal), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.row('','----------------');
    } else if (style == 3) {
      bytes += helper.text('Harga Tertera sudah termasuk service dan pajak', align: PosAlign.center);
    } else if (style == 4) {
    } else if (style == 5) {
      // await bt.write(formatTableRow('Jumlah', Formatter.formatRupiah(ivc.jumlah), 48, leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
      bytes += helper.tableWithMaxChars('', 'Jumlah', Formatter.formatRupiah(ivc.jumlah), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      // await bt.write(formatTableRow('Jumlah Service', Formatter.formatRupiah(ivc.fnbService + ivc.roomService), 48, leftSize: 33, rightSize: 15, alignRight: true, alignLeft: true));
      bytes += helper.tableWithMaxChars('', 'Jumlah Service', Formatter.formatRupiah(ivc.fnbService + ivc.roomService), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.tableWithMaxChars('', 'Jumlah Pajak', Formatter.formatRupiah(ivc.fnbTax + ivc.roomTax), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.row('','----------------');
      bytes += helper.tableWithMaxChars('', 'Total', Formatter.formatRupiah(ivc.jumlahTotal), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.row('','----------------');
    } else if (style == 6) {
      bytes += helper.tableWithMaxChars('', 'Jumlah', Formatter.formatRupiah(ivc.jumlah), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.tableWithMaxChars('', 'Service FnB', Formatter.formatRupiah(ivc.fnbService), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.tableWithMaxChars('', 'Service Room', Formatter.formatRupiah(ivc.roomService), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.row('','----------------');
      bytes += helper.tableWithMaxChars('', 'Total', Formatter.formatRupiah(ivc.jumlahTotal), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.row('','----------------');
    } else if (style == 7) {
      bytes += helper.tableWithMaxChars('', 'Jumlah', Formatter.formatRupiah(ivc.jumlah), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.tableWithMaxChars('', 'Pajak FnB', Formatter.formatRupiah(ivc.fnbTax), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.tableWithMaxChars('', 'Pajak Room', Formatter.formatRupiah(ivc.roomTax), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.row('','----------------');
      bytes += helper.tableWithMaxChars('', 'Total', Formatter.formatRupiah(ivc.jumlahTotal), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
      bytes += helper.row('','----------------');
    } else {}
    return bytes;
  }

  List<int> _printTransfer(CommandHelper helper, TransferModel data, int footerStyle) {
    final printer = GlobalProviders.read(printerProvider);
    List<OrderFinalModel> orderFix = List.empty(growable: true);
    List<int> bytes = [];
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
          promo = data.dataPromoOrder.where((element) =>
            element.orderCode == orderCode &&
            element.inventoryCode == inventoryCode).toList();
          if (isNotNullOrEmpty(promo)) {
            promoName = promo[0].promoName;
            hargaPromo += promo[0].promoPrice;
          }
        }

        if (isNotNullOrEmpty(data.dataCancelOrder)) {
          cancel = data.dataCancelOrder.where((element) =>
            element.orderCode == orderCode &&
            element.inventoryCode == inventoryCode).toList();
          if (isNotNullOrEmpty(cancel)) {
            jumlahCancel = cancel[0].jumlah;
            hargaCancel = cancel[0].harga;
            jumlah -= cancel[0].jumlah;
            totalSemua -= cancel[0].total;

            if (isNotNullOrEmpty(data.dataPromoCancelOrder)) {
              promoCancel = data.dataPromoCancelOrder.where((element) =>
                element.orderCode == orderCode &&
                element.inventoryCode == inventoryCode &&
                element.orderCancelCode == cancel![0].cancelOrderCode).toList();
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
    bytes += helper.textCenter('Transfer Room', bold: true);
    bytes += helper.feed(1);
    //Checkin Info
    bytes += helper.text('Ruangan : ${data.dataRoom.roomCode}');
    bytes += helper.text('Nama    : ${data.dataRoom.nama}');
    bytes += helper.text('Tanggal : ${data.dataRoom.tanggal}');
    bytes += helper.feed(1);

    //Room Info
    bytes += helper.table('Sewa Ruangan', '', Formatter.formatRupiah(data.dataInvoice.sewaRuangan), rightAlign: PosAlign.right);
    if (data.dataInvoice.promo > 0) {
      bytes += helper.table('Promo', '', '(${Formatter.formatRupiah(data.dataInvoice.promo)})', rightAlign: PosAlign.right);
    }
    if ((data.voucherValue?.roomPrice ?? 0) > 0) {
      bytes += helper.table('Voucher Room', '', '(${Formatter.formatRupiah(data.voucherValue!.roomPrice)})', rightAlign: PosAlign.right);
    }

    if (isNotNullOrEmpty(orderFix)) {
      bytes += _printFnB(orderFix, helper);
      if (data.voucherValue != null && (data.voucherValue?.fnbPrice ?? 0) > 0) {
        bytes += helper.table('Voucher FnB', '', '(${Formatter.formatRupiah((data.voucherValue?.fnbPrice ?? 0))})', rightAlign: PosAlign.right);
      }
      num totalPromo = 0;
      for (var element in orderFix) {
        totalPromo += element.hargaPromo;
      }
      if ((GlobalProviders.read(showTotalItemPromoProvider) || GlobalProviders.read(showPromoBelowItemProvider) == false) == true && totalPromo > 0) {
        bytes += helper.feed(1);
        bytes += helper.row('Total Promo Item', Formatter.formatRupiah(totalPromo));
      }
    }
    bytes += helper.divider();

    bytes += helper.row('Jumlah Ruangan', Formatter.formatRupiah(data.dataInvoice.jumlahRuangan));
    bytes += helper.row('Jumlah Penjualan', Formatter.formatRupiah(data.dataInvoice.jumlahPenjualan));
    bytes += helper.divider();
    bytes += _printFooter(helper, data.dataInvoice, data.dataServiceTaxPercent, footerStyle);
    if (data.voucherValue != null && (data.voucherValue?.price ?? 0) > 0) {
      bytes += helper.table('Voucher', '', '(${Formatter.formatRupiah((data.voucherValue?.price ?? 0))})', rightAlign: PosAlign.right);
    }



    bytes += helper.tableWithMaxChars('', 'Jumlah Bersih', Formatter.formatRupiah(data.dataInvoice.jumlahBersih), centerAlign: PosAlign.right, rightAlign: PosAlign.right, maxRightChars: 15);
    bytes += helper.feed(1);
    bytes += helper.text(Formatter.formatRupiah(data.dataInvoice.jumlahBersih),
      bold: true,
      height: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size2: PosTextSize.size1, 
      width: printer.printerModel == PrinterModelType.tmu220u? PosTextSize.size1: PosTextSize.size2
    );
    bytes += helper.feed(2);
    return bytes;
  }

  List<OrderFinalModel> _mergeItems(List<OrderFinalModel> orderList) {
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
}