import 'package:flutter/services.dart';

class IPAddressInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String formattedText = _formatIPAddress(newValue.text);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatIPAddress(String text) {
    // Batasi panjang input
    if (text.length > 15) {
      return text.substring(0, 15);
    }

    // Pisahkan input menjadi bagian-bagian
    final parts = text.split('.');

    // Buat daftar string yang terdiri dari bagian-bagian yang diformat
    final formattedParts = parts.map<String>((part) {
      if (int.tryParse(part) == null || int.parse(part) > 255) {
        // Jika bagian tidak valid, kembalikan bagian kosong
        return '';
      } else {
        // Jika bagian valid, kembalikan bagian yang diformat
        return part;
      }
    }).toList();

    // Gabungkan bagian-bagian yang diformat dengan tanda titik sebagai pemisah
    return formattedParts.join('.');
  }
}