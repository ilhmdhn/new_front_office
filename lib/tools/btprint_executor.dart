import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/printerenum.dart';
import 'package:front_office_2/tools/toast.dart';

class BtprintExecutor{
    
    void testPrint()async{
      final bluetooth = await BtPrint().getInstance();
      bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printNewLine();
        bluetooth.printCustom("Test Print Successfully", Size.boldMedium.val, Align.center.val);
        bluetooth.paperCut(); //some printer not supported (sometime making image not centered)

      }else{
        showToastWarning('Sambungkan printer di pengaturan');
      }
    });
  }
  }