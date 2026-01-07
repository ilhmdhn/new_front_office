import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/tools/preferences.dart';

// Provider untuk Printer Settings
final printerProvider = StateNotifierProvider<PrinterNotifier, PrinterModel>((ref) {
  return PrinterNotifier();
});

class PrinterNotifier extends StateNotifier<PrinterModel> {
  PrinterNotifier() : super(_initialPrinter()) {
    _loadPrinter();
  }

  static PrinterModel _initialPrinter() {
    return PreferencesData.getPrinter();
  }

  void _loadPrinter() {
    state = PreferencesData.getPrinter();
  }

  void setPrinter(PrinterModel printer) {
    PreferencesData.setPrinter(printer);
    state = printer;
  }

  void refresh() {
    _loadPrinter();
  }
}
