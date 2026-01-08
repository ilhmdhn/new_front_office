import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:front_office_2/data/model/other_model.dart';

class CommandHelper {
  final Generator generator;
  final PrinterModelType? printerModel;

  CommandHelper(this.generator, {this.printerModel});

  /// Get max characters per line for current printer
  int get maxCharsPerLine {
    if (printerModel == PrinterModelType.tmu220u) {
      return 42; // TMU-220 dot matrix: 72mm = 42 chars
    }
    return 48; // Default for thermal printers (80mm)
  }

  /// Manual center alignment for printers that don't support ESC a commands
  String _centerText(String text) {
    if (text.length >= maxCharsPerLine) {
      return text.substring(0, maxCharsPerLine);
    }
    final padding = (maxCharsPerLine - text.length) ~/ 2;
    return '${' ' * padding}$text';
  }

  List<int> text(
    String value, {
    bool bold = false,
    PosAlign align = PosAlign.left,
    PosTextSize width = PosTextSize.size1,
    PosTextSize height = PosTextSize.size1,
  }) {
    // For TMU-220, use manual center alignment instead of ESC a commands
    if (printerModel == PrinterModelType.tmu220u && align == PosAlign.center) {
      return generator.text(
        _centerText(value),
        styles: PosStyles(
          bold: bold,
          align: PosAlign.left, // Force left, padding already added
          width: width,
          height: height,
        ),
      );
    }

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

  List<int> divider() {
    // For TMU-220, use manual divider with correct width
    if (printerModel == PrinterModelType.tmu220u) {
      return generator.text('-' * maxCharsPerLine);
    }
    return generator.hr();
  }

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

  /// Table dengan lebar karakter maksimal yang dapat ditentukan
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// helper.tableWithMaxChars(
  ///   'Nama Item Panjang Sekali',
  ///   '10',
  ///   'Rp 100.000',
  ///   maxLeftChars: 10,   // Kiri maksimal 10 karakter
  ///   maxCenterChars: 18, // Tengah maksimal 18 karakter
  ///   maxRightChars: 20,  // Kanan maksimal 20 karakter
  /// );
  /// ```
  List<int> tableWithMaxChars(
    String leftText,
    String centerText,
    String rightText, {
    int maxLeftChars = 10,
    int maxCenterChars = 18,
    int maxRightChars = 20,
    PosAlign leftAlign = PosAlign.left,
    PosAlign centerAlign = PosAlign.center,
    PosAlign rightAlign = PosAlign.right,
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
    // Truncate text jika melebihi maksimal karakter
    String truncatedLeft = leftText.length > maxLeftChars
        ? leftText.substring(0, maxLeftChars)
        : leftText;

    String truncatedCenter = centerText.length > maxCenterChars
        ? centerText.substring(0, maxCenterChars)
        : centerText;

    String truncatedRight = rightText.length > maxRightChars
        ? rightText.substring(0, maxRightChars)
        : rightText;

    // Total paper width depends on printer model
    // TMU-220: 42 chars, Thermal 80mm: 48 chars
    // Hitung proporsi width berdasarkan maxChars
    int totalChars = maxLeftChars + maxCenterChars + maxRightChars;
    const int totalWidth = 12; // Total width dalam grid system (12 kolom)

    // Hitung width kolom berdasarkan proporsi karakter
    int leftColWidth = ((maxLeftChars / totalChars) * totalWidth).round();
    int centerColWidth = ((maxCenterChars / totalChars) * totalWidth).round();
    int rightColWidth = totalWidth - leftColWidth - centerColWidth;

    return generator.row([
      PosColumn(
        text: truncatedLeft,
        width: leftColWidth,
        styles: PosStyles(
          align: leftAlign,
          bold: leftBold ?? false,
          width: leftTextWidth ?? PosTextSize.size1,
          height: leftTextHeight ?? PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: truncatedCenter,
        width: centerColWidth,
        styles: PosStyles(
          align: centerAlign,
          bold: centerBold ?? false,
          width: centerTextWidth ?? PosTextSize.size1,
          height: centerTextHeight ?? PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: truncatedRight,
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