import 'package:intl/intl.dart';

class Formatter{

  String formatRupiah(String value) {
    final number = int.tryParse(value) ?? 0;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: '');
    return formatter.format(number);
  }
}