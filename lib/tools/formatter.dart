import 'package:intl/intl.dart';

class Formatter{
  static String formatRupiah(num value) {
    // final number = int.tryParse(value) ?? 0;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
    return formatter.format(value);
  }


  static const List<String> _bulan = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  static String formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = _bulan[dt.month];
    final year = dt.year;

    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');

    return "$day $month $year, $hour:$minute";
  }

}