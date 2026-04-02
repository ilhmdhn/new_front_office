import 'package:front_office_2/data/model/bill_resto_response.dart';
import 'package:front_office_2/data/model/model_helper/grouped_promo_model.dart';
import 'package:front_office_2/data/model/voucher_model.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/data.dart';
import 'package:intl/intl.dart';

class Calculate{
  VoucherModel calculateCashbackVoucher(String invoice, num value){

    final user = GlobalProviders.read(userProvider);
    final voucherCode = 'V${user.outlet}-${invoice.split('-')[1]}';
    int voucherValue = 0;
    List<String> snk = List.empty(growable: true);

    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, now.day, 8, 0, 0);
    DateTime futureDate = now.add(const Duration(days: 30));
    DateTime finishDate = DateTime(futureDate.year, futureDate.month, futureDate.day, 5, 0, 0);

    if(value > 249999 && value < 500000){
      voucherValue = 25000;
    }else if(value > 499999 && value < 1000000){
      voucherValue = 50000;
    }else if(value > 999999 && value < 1999999){
      voucherValue = 100000;
    }else if(value > 1999999){
      voucherValue = 150000;
    }

    snk.add('Berlaku di ${Data.getOutletName(user.outlet)}');

    return VoucherModel(
      code: voucherCode, 
      value: voucherValue, 
      timeStart: DateFormat('dd/MM/yyyy HH:mm:ss').format(startDate),
      timeEnd: DateFormat('dd/MM/yyyy HH:mm:ss').format(finishDate), 
      snk: snk);
  }

  static int calculateFnbTotalRestoNoPromo(List<OrderRestoModel> data){
    return data.fold(0, (sum, item) => sum + (item.qty * item.price)).round();
  }

  static int calculateFnbTotalResto(List<OrderRestoModel> data){
    return data.fold(0, (sum, item) => sum + ((item.qty * item.price) - (item.promo??0))).round();
  }

  static int totalQtyResto(List<OrderRestoModel> data){
    return data.fold(0, (sum, item) => sum + item.qty);
  }

  static List<OrderRestoModel> groupingOrderResto(List<OrderRestoModel> listOrder){
    Map<String, OrderRestoModel> grouped = {};
    for (var item in listOrder) {
      if (grouped.containsKey(item.inventory)) {
        grouped[item.inventory]!.qty += item.qty;
        grouped[item.inventory]!.promo = (grouped[item.inventory]!.promo ?? 0) + (item.promo ?? 0);
      } else {
        grouped[item.inventory] = OrderRestoModel(
          inventory: item.inventory,
          name: item.name,
          qty: item.qty,
          price: item.price,
          promo: item.promo,
          promoName: item.promoName,
          typeFnb: item.typeFnb
        );
      }
    }

    List<OrderRestoModel> result = grouped.values.toList();
    return result;
  }

  static List<GroupedPromoModel> groupingPromo(List<OrderRestoModel> dataOrder) {
    Map<String, GroupedPromoModel> grouped = {};

    for (final item in dataOrder) {
      if ((item.promo ?? 0) > 0) {
        final key = item.promoName ?? 'promo';

        if (grouped.containsKey(key)) {
          grouped[key]!.value += (item.promo ?? 0);
        } else {
          grouped[key] = GroupedPromoModel(
            promoName: key,
            value: item.promo ?? 0,
          );
        }
      }
    }

    return grouped.values.toList();
  }
}

//IVC-2406090001