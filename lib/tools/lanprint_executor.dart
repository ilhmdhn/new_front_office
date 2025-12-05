import 'package:flutter/foundation.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/printer_helper.dart';
import 'package:front_office_2/tools/toast.dart';

class LanprintExecutor {
  Future<void> testPrint() async {
    debugPrint('START PRINT TEST LAN PRINTER');

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

    debugPrint('LAN Printer IP: $ip, Port: $port');

    // SESUAI DOKUMENTASI: Gunakan FlutterThermalPrinterNetwork
    final service = FlutterThermalPrinterNetwork(ip, port: port);

    try {
      // Connect ke printer
      debugPrint('Connecting to LAN printer: $ip:$port');
      await service.connect();
      debugPrint('Connected successfully');

      // Load capability profile
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      final helper = ReceiptPrinterHelper(generator);

      // Generate test print data
      List<int> bytes = [];

      // IMPORTANT: Tambah ESC @ (Initialize printer)
      bytes += [0x1B, 0x40];

      bytes += helper.feed(2);
      bytes += helper.text("TEST PRINT LAN", bold: true, align: PosAlign.center);
      bytes += helper.divider();
      bytes += helper.text("Happy Puppy POS", bold: true, align: PosAlign.center);
      bytes += helper.feed(1);
      bytes += helper.text("Printer : ${printerConfig.name}");
      bytes += helper.text("IP      : $ip:$port");
      bytes += helper.text("Type    : LAN Network");
      bytes += helper.feed(1);
      bytes += helper.divider();
      bytes += helper.text("Test print berhasil!", bold: true, align: PosAlign.center);
      bytes += helper.divider();
      bytes += helper.feed(1);
      bytes += helper.row("Kiri", "Kanan");
      bytes += helper.feed(3);

      // CRITICAL: Tambah CUT command (GS V)
      bytes += helper.cut();

      // Print data - SESUAI DOKUMENTASI: gunakan printTicket()
      debugPrint('Printing ${bytes.length} bytes...');
      debugPrint('Data preview: ${bytes.take(50)}...'); // Preview data

      await service.printTicket(bytes);

      debugPrint('Print completed successfully');
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
}
