import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';

class ReceiptPrinterHelper {
  final Generator generator;
  ReceiptPrinterHelper(this.generator);

  List<int> text(
    String value, {
    bool bold = false,
    PosAlign align = PosAlign.left,
    PosTextSize width = PosTextSize.size1,
    PosTextSize height = PosTextSize.size1,
  }) {
    return generator.text(
      value,
      styles: PosStyles(
        bold: bold,
        align: align,
        width: width,
        height: height,
      ),
    );
  }

  List<int> divider() => generator.hr();

  List<int> feed([int lines = 1]) => generator.feed(lines);

  List<int> row(String left, String right,
      {bool bold = false, int leftWidth = 6, int rightWidth = 6}) {
    return generator.row([
      PosColumn(text: left, width: leftWidth, styles: PosStyles(bold: bold)),
      PosColumn(
        text: right,
        width: rightWidth,
        styles: PosStyles(
          bold: bold,
          align: PosAlign.right,
        ),
      ),
    ]);
  }

  List<int> barcode(String data) => generator.barcode(
        Barcode.upcA(data as List),
      );

  List<int> qr(String data) => generator.qrcode(data);

  List<int> cut() => generator.cut();
}
