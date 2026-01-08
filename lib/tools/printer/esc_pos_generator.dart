

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/printer/command_helper.dart';

class EscPosGenerator {
  
  static List<int> testPrint(Generator printerGenerator){
      final printerConfig = GlobalProviders.read(printerProvider);

      final helper = CommandHelper(printerGenerator);
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
          "kirikirikirikiri", "tengahtengahtengah1", "kanankanankanan1",
          leftAlign: PosAlign.left,
          centerAlign: PosAlign.left,
          rightAlign: PosAlign.left);
      bytes += helper.feed(3);
      bytes += helper.cut();
      
      return bytes;
  }
}