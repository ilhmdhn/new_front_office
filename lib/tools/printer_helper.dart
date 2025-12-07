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

  List<int> textCenter(
    String value, {
    bool? bold,
    PosTextSize? width,
    PosTextSize? height,
  }) {
    return generator.row([
      PosColumn(
        text: '',
        width: 3,
        styles: PosStyles(),
      ),
      PosColumn(
        text: value,
        width: 6,
        styles: PosStyles(
          align: PosAlign.center,
          bold: bold ?? false,
          width: width ?? PosTextSize.size1,
          height: height ?? PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: '',
        width: 3,
        styles: PosStyles(),
      ),
    ]);
  }

  List<int> table(
    String leftText,
    String centerText,
    String rightText, {
    PosAlign leftAlign = PosAlign.left,
    PosAlign centerAlign = PosAlign.center,
    PosAlign rightAlign = PosAlign.right,
    int leftColWidth = 4,
    int centerColWidth = 4,
    int rightColWidth = 4,
    bool? leftBold,
    bool? centerBold,
    bool? rightBold,
    PosTextSize? leftTextWidth,
    PosTextSize? centerTextWidth,
    PosTextSize? rightTextWidth,
    PosTextSize? leftTextHeight,
    PosTextSize? centerTextHeight,
    PosTextSize? rightTextHeight,
  }) {
    return generator.row([
      PosColumn(
        text: leftText,
        width: leftColWidth,
        styles: PosStyles(
          align: leftAlign,
          bold: leftBold ?? false,
          width: leftTextWidth ?? PosTextSize.size1,
          height: leftTextHeight ?? PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: centerText,
        width: centerColWidth,
        styles: PosStyles(
          align: centerAlign,
          bold: centerBold ?? false,
          width: centerTextWidth ?? PosTextSize.size1,
          height: centerTextHeight ?? PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: rightText,
        width: rightColWidth,
        styles: PosStyles(
          align: rightAlign,
          bold: rightBold ?? false,
          width: rightTextWidth ?? PosTextSize.size1,
          height: rightTextHeight ?? PosTextSize.size1,
        ),
      ),
    ]);
  }

  List<int> barcode(String data) => generator.barcode(Barcode.upcA(data as List),
      );

  List<int> qr(String data) => generator.qrcode(data);

  List<int> cut() => generator.cut();
}