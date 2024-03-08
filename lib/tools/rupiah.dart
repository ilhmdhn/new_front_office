import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Menghapus seluruh karakter selain angka
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Menangani kasus nilai yang tidak valid
    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Menambahkan titik sebagai separator ribuan
    final formatter = NumberFormat('#,###');
    String formattedValue = formatter.format(int.parse(newText));

    return newValue.copyWith(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length));
  }
}
