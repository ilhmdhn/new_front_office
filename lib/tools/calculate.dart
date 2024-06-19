import 'package:front_office_2/data/model/voucher_model.dart';
import 'package:front_office_2/tools/data.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:intl/intl.dart';

class Calculate{
  VoucherModel calculateCashbackVoucher(String invoice, num value){

    final outletCode = PreferencesData.getOutlet();
    final voucherCode = 'V$outletCode-${invoice.split('-')[1]}';
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

    snk.add('Berlaku di ${Data.getOutletName(outletCode)}');

    return VoucherModel(
      code: voucherCode, 
      value: voucherValue, 
      timeStart: DateFormat('dd/MM/yyyy HH:mm:ss').format(startDate),
      timeEnd: DateFormat('dd/MM/yyyy HH:mm:ss').format(finishDate), 
      snk: snk);
  }
}

//IVC-2406090001