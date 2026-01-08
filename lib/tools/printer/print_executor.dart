import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/printer/esc_pos_generator.dart';
import 'package:front_office_2/tools/printer/sender/ble_print_service.dart';
import 'package:front_office_2/tools/printer/sender/lan_print_service.dart';
import 'package:front_office_2/tools/printer/sender/tcp_print_service.dart';
import 'package:front_office_2/tools/toast.dart';

class PrintExecutor {
  /// Test print untuk semua jenis printer
  /// Returns true jika berhasil, false jika gagal
  static Future<bool> testPrint() async {
    try {
      final printer = GlobalProviders.read(printerProvider);

      if (printer.name.isEmpty) {
        showToastWarning('Printer belum dikonfigurasi');
        return false;
      }

      final profile = await CapabilityProfile.load();
      Generator generator;

      // Fix: Kondisi yang benar untuk paper size
      if (printer.printerModel == PrinterModelType.bluetooth80mm ||
          printer.printerModel == PrinterModelType.tm82x) {
        generator = Generator(PaperSize.mm80, profile);
      } else if (printer.printerModel == PrinterModelType.tmu220u) {
        // TMU-220 dot matrix: 72mm paper = 42 chars/line
        // Note: Alignment commands might not work properly on dot matrix
        generator = Generator(PaperSize.mm72, profile, spaceBetweenRows: 0);
      } else {
        generator = Generator(PaperSize.mm58, profile);
      }

      final posContent = EscPosGenerator.testPrint(generator);

      bool success = false;

      // Send berdasarkan connection type dengan await
      if (printer.connectionType == PrinterConnectionType.printerDriver) {
        success = await TcpPrinterService.printOnce(
          ip: printer.address,
          port: printer.port!,
          data: posContent,
        );
      } else if (printer.connectionType == PrinterConnectionType.bluetooth) {
        success = await BlePrintService.printOnce(
          deviceId: printer.address,
          deviceName: printer.name,
          data: posContent,
        );
      } else if (printer.connectionType == PrinterConnectionType.lan) {
        success = await LanPrintService.printOnce(
          ip: printer.address,
          port: printer.port ?? 9100,
          data: posContent,
        );
      }

      if (success) {
        showToastSuccess('Test print berhasil');
      } else {
        showToastError('Test print gagal');
      }

      return success;
    } catch (e) {
      showToastError('Error test print: $e');
      return false;
    }
  }
}