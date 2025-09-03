import 'package:intl/intl.dart';

class Formatter{

  static String formatRupiah(num value) {
    // final number = int.tryParse(value) ?? 0;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
    return formatter.format(value);
  }
}