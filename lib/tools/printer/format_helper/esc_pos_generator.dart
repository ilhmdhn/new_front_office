

import 'package:collection/collection.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/printer/format_helper/command_helper.dart';

class EscPosGenerator {
  
  static List<int> testPrint(Generator printerGenerator){
      final printerConfig = GlobalProviders.read(printerProvider);

      final helper = CommandHelper(
        printerGenerator,
        printerModel: printerConfig.printerModel,
      );
      List<int> bytes = [];

      bytes += [0x1B, 0x40];
      bytes += helper.feed(2);
      bytes +=helper.text("TEST PRINT LAN", bold: true, align: PosAlign.center);
      bytes += helper.divider();
      bytes +=helper.text("Happy Puppy POS", bold: true, align: PosAlign.center);
      bytes += helper.feed(1);
      bytes += helper.text("Printer : ${printerConfig.name}");
      bytes += helper.text("IP      : ${printerConfig.address}");
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
          "kiri", "tengah", "kanan",
          leftAlign: PosAlign.left,
          centerAlign: PosAlign.right,
          rightAlign: PosAlign.right);
      bytes += helper.feed(3);
      bytes += helper.cut();
      
      return bytes;
  }

    List<int> printFnB(List<OrderFinalModel> orderFix, helper) {
    List<int> bytes = [];
    final fnbList = _mergeItems(orderFix);
    bytes += helper.feed(1);
    bytes += helper.text('Rincian Penjualan');
    bytes += helper.feed(1);

    for (var fnb in fnbList) {
      if (PreferencesData.getShowReturState() == true) {
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
            PreferencesData.getShowPromoBelowItem() == true) {
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
              PreferencesData.getShowPromoBelowItem() == true) {
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
      bytes += printFnB(orderFix, helper);
      if (data.voucherValue != null && (data.voucherValue?.fnbPrice ?? 0) > 0) {
        bytes += helper.table('Voucher FnB', '', '(${Formatter.formatRupiah((data.voucherValue?.fnbPrice ?? 0))})', rightAlign: PosAlign.right);
      }
      num totalPromo = 0;
      for (var element in orderFix) {
        totalPromo += element.hargaPromo;
      }
      if ((PreferencesData.getShowTotalItemPromo() ||PreferencesData.getShowPromoBelowItem() == false) ==true && totalPromo > 0) {
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
    bytes += helper.tableWithMaxChars('', Formatter.formatRupiah(data.dataInvoice.jumlahBersih), '', centerBold: true, centerTextHeight: PosTextSize.size1, centerTextWidth: PosTextSize.size2, maxCenterChars: 48);
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