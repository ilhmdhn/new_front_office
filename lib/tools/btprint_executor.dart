import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:front_office_2/page/setting/printer/printerenum.dart';
import 'package:front_office_2/tools/toast.dart';

class BtprintExecutor{
    BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
    void testPrint(){
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printNewLine();
        bluetooth.printCustom("HEADER", Size.boldMedium.val, Align.center.val);
        bluetooth
            .paperCut(); //some printer not supported (sometime making image not centered)
        bluetooth.drawerPin2(); // or you can use bluetooth.drawerPin5();
      }else{
        showToastWarning('Sambungkan printer di pengaturan');
      }
    });
  }
  }