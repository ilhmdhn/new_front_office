import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/tools/preferences.dart';

// Provider untuk Print Slip Checkin
final printSlipCheckinProvider = StateNotifierProvider<PrintSlipCheckinNotifier, bool>((ref) {
  return PrintSlipCheckinNotifier();
});

class PrintSlipCheckinNotifier extends StateNotifier<bool> {
  PrintSlipCheckinNotifier() : super(_initialState()) {
    _loadState();
  }

  static bool _initialState() {
    return PreferencesData.getPrintSlipCheckin();
  }

  void _loadState() {
    state = PreferencesData.getPrintSlipCheckin();
  }

  void setPrintSlipCheckin(bool value) {
    PreferencesData.setPrintSlipCheckin(value);
    state = value;
  }

  void refresh() {
    _loadState();
  }
}

// Provider untuk Print Slip Order
final printSlipOrderProvider = StateNotifierProvider<PrintSlipOrderNotifier, bool>((ref) {
  return PrintSlipOrderNotifier();
});

class PrintSlipOrderNotifier extends StateNotifier<bool> {
  PrintSlipOrderNotifier() : super(_initialState()) {
    _loadState();
  }

  static bool _initialState() {
    return PreferencesData.getPrintSlipOrder();
  }

  void _loadState() {
    state = PreferencesData.getPrintSlipOrder();
  }

  void setPrintSlipOrder(bool value) {
    PreferencesData.setPrintSlipOrder(value);
    state = value;
  }

  void refresh() {
    _loadState();
  }
}

// Provider untuk Print Slip Delivery Order
final printSlipDeliveryOrderProvider = StateNotifierProvider<PrintSlipDeliveryOrderNotifier, bool>((ref) {
  return PrintSlipDeliveryOrderNotifier();
});

class PrintSlipDeliveryOrderNotifier extends StateNotifier<bool> {
  PrintSlipDeliveryOrderNotifier() : super(_initialState()) {
    _loadState();
  }

  static bool _initialState() {
    return PreferencesData.getPrintSlipDeliveryOrder();
  }

  void _loadState() {
    state = PreferencesData.getPrintSlipDeliveryOrder();
  }

  void setPrintSlipDeliveryOrder(bool value) {
    PreferencesData.setPrintSlipDeliveryOrder(value);
    state = value;
  }

  void refresh() {
    _loadState();
  }
}

// Provider untuk Print Bill
final printBillProvider = StateNotifierProvider<PrintBillNotifier, bool>((ref) {
  return PrintBillNotifier();
});

class PrintBillNotifier extends StateNotifier<bool> {
  PrintBillNotifier() : super(_initialState()) {
    _loadState();
  }

  static bool _initialState() {
    return PreferencesData.getPrintBill();
  }

  void _loadState() {
    state = PreferencesData.getPrintBill();
  }

  void setPrintBill(bool value) {
    PreferencesData.setPrintBill(value);
    state = value;
  }

  void refresh() {
    _loadState();
  }
}

// Provider untuk Print Invoice
final printInvoiceProvider = StateNotifierProvider<PrintInvoiceNotifier, bool>((ref) {
  return PrintInvoiceNotifier();
});

class PrintInvoiceNotifier extends StateNotifier<bool> {
  PrintInvoiceNotifier() : super(_initialState()) {
    _loadState();
  }

  static bool _initialState() {
    return PreferencesData.getPrintInvoice();
  }

  void _loadState() {
    state = PreferencesData.getPrintInvoice();
  }

  void setPrintInvoice(bool value) {
    PreferencesData.setPrintInvoice(value);
    state = value;
  }

  void refresh() {
    _loadState();
  }
}
