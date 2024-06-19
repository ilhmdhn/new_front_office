import 'package:front_office_2/data/model/voucher_model.dart';
import 'package:front_office_2/tools/preferences.dart';

class Calculate{
  VoucherModel calculateCashbackVoucher(String invoice, num value){

    final outletCode = PreferencesData.getOutlet();
    final voucherCode = 'V${outletCode}-${invoice.split('-')[1]}';
    int voucherValue = 0;
    List<String> snk = List.empty(growable: true);

    if(value > 249999 && value < 500000){
      voucherValue = 25000;
    }else if(value > 499999 && value < 1000000){
      voucherValue = 50000;
    }else if(value > 999999 && value < 1999999){
      voucherValue = 100000;
    }else if(value > 1999999){
      voucherValue = 150000;
    }

    snk.add('Berlaku di ');
  }
}

//IVC-2406090001