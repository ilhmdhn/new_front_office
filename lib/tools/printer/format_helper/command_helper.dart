import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/other_model.dart';

class CommandHelper {
  final Generator generator;
  final PrinterModelType? printerModel;

  CommandHelper(this.generator, {this.printerModel});

  /// Get max characters per line for current printer
  int get maxCharsPerLine {
    if (printerModel == PrinterModelType.tmu220u) {
      return 40; // TMU-220 dot matrix: 72mm = 40 chars
    }
    return 48; // Default for thermal printers (80mm)
  }

  /// Initialize printer with correct settings for TMU-220
  /// Call this at the start of every document
  List<int> initializePrinter() {
    // Just initialize printer (reset to defaults)
    // Library generator will handle font sizing for normal text
    return [0x1B, 0x40];
  }

  /// Manual alignment for printers that don't support ESC a commands
  String _alignText(String text, PosAlign align) {
    if (text.length >= maxCharsPerLine) {
      return text.substring(0, maxCharsPerLine);
    }

    switch (align) {
      case PosAlign.center:
        final padding = (maxCharsPerLine - text.length) ~/ 2;
        return '${' ' * padding}$text';
      case PosAlign.right:
        final padding = maxCharsPerLine - text.length;
        return '${' ' * padding}$text';
      case PosAlign.left:
        return text;
    }
  }

  /// Generate ESC ! command for TMU-220 dot matrix printer
  /// ESC ! n - Master select character font
  /// bit 0: Font B (12 cpi) - NEVER SET! Use Font A (10 cpi) for 40 chars
  /// bit 3: Bold/Emphasized
  /// bit 4: Double height
  /// bit 5: Double width
  /// bit 7: Underline
  int _getTmu220FontFlag(bool bold, PosTextSize width, PosTextSize height) {
    int flag = 0x00; // Start with Font A (bit 0 = 0)

    // IMPORTANT: Never set bit 0 (Font B)!
    // Font B only fits 33 chars, we need Font A for 40 chars

    // Bold
    if (bold) flag |= 0x08; // bit 3

    // Double height
    if (height == PosTextSize.size2) flag |= 0x10; // bit 4

    // Double width
    if (width == PosTextSize.size2) flag |= 0x20; // bit 5

    return flag;
  }

  List<int> text(
    String value, {
    bool bold = false,
    PosAlign align = PosAlign.left,
    PosTextSize width = PosTextSize.size1,
    PosTextSize height = PosTextSize.size1,
  }) {
    // For TMU-220, only use custom commands for double width/height
    if (printerModel == PrinterModelType.tmu220u &&
        (width == PosTextSize.size2 || height == PosTextSize.size2)) {
      List<int> bytes = [];

      // ESC ! n - Set font style for dot matrix (double width/height)
      final fontFlag = _getTmu220FontFlag(bold, width, height);
      bytes += [0x1B, 0x21, fontFlag];

      // Manual alignment for TMU-220
      final alignedText = _alignText(value, align);

      // Adjust max chars based on font size
      int effectiveMaxChars = maxCharsPerLine;
      if (width == PosTextSize.size2) effectiveMaxChars = maxCharsPerLine ~/ 2;

      final finalText = alignedText.length > effectiveMaxChars
          ? alignedText.substring(0, effectiveMaxChars)
          : alignedText;

      bytes += finalText.codeUnits;
      bytes += [0x0A];

      // Reset font to normal
      bytes += [0x1B, 0x21, 0x00];

      return bytes;
    }

    // For normal size or non-TMU-220, use library generator
    // Manual alignment for TMU-220 even on normal text
    if (printerModel == PrinterModelType.tmu220u) {
      final alignedText = _alignText(value, align);
      return generator.text(
        alignedText,
        styles: PosStyles(
          bold: bold,
          align: PosAlign.left, // Already manually aligned
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
    // For TMU-220, use library generator with exact char count
    if (printerModel == PrinterModelType.tmu220u) {
      final dividerLine = '-' * maxCharsPerLine;
      return generator.text(dividerLine);
    }
    return generator.hr();
  }

  List<int> feed([int lines = 1]) => generator.feed(lines);

  List<int> row(String left, String right, {bool bold = false, int leftWidth = 6, int rightWidth = 6}) {
    // For TMU-220, format manually then use library generator
    if (printerModel == PrinterModelType.tmu220u) {
      // Calculate character widths based on total 40 chars
      final leftChars = (maxCharsPerLine * leftWidth / 12).floor();
      final rightChars = maxCharsPerLine - leftChars;

      final leftPart = left.length > leftChars
          ? left.substring(0, leftChars)
          : left.padRight(leftChars);

      final rightPart = right.length > rightChars
          ? right.substring(0, rightChars)
          : right.padLeft(rightChars);

      final finalText = leftPart + rightPart;

      debugPrint('TMU-220 Row: left="$left" right="$right" finalLength=${finalText.length}');

      // Use library generator for better font handling
      return generator.text(finalText, styles: PosStyles(bold: bold));
    }

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
    // For TMU-220, use text() method with center alignment
    if (printerModel == PrinterModelType.tmu220u) {
      return text(
        value,
        bold: bold ?? false,
        align: PosAlign.center,
        width: width ?? PosTextSize.size1,
        height: height ?? PosTextSize.size1,
      );
    }

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
    // For TMU-220, format manually then use library generator
    if (printerModel == PrinterModelType.tmu220u) {
      // Calculate character widths based on total 40 chars and grid widths
      final totalGridWidth = leftColWidth + centerColWidth + rightColWidth;
      final leftChars = (maxCharsPerLine * leftColWidth / totalGridWidth).floor();
      final centerChars = (maxCharsPerLine * centerColWidth / totalGridWidth).floor();
      final rightChars = maxCharsPerLine - leftChars - centerChars;

      // Helper to align text within column
      String alignInColumn(String text, int width, PosAlign align) {
        if (text.length > width) {
          return text.substring(0, width);
        }
        switch (align) {
          case PosAlign.center:
            final padding = (width - text.length) ~/ 2;
            return '${' ' * padding}$text${' ' * (width - text.length - padding)}';
          case PosAlign.right:
            return text.padLeft(width);
          case PosAlign.left:
            return text.padRight(width);
        }
      }

      final leftPart = alignInColumn(leftText, leftChars, leftAlign);
      final centerPart = alignInColumn(centerText, centerChars, centerAlign);
      final rightPart = alignInColumn(rightText, rightChars, rightAlign);

      final finalText = leftPart + centerPart + rightPart;
      final isBold = leftBold ?? centerBold ?? rightBold ?? false;

      // Use library generator for better font handling
      return generator.text(finalText, styles: PosStyles(bold: isBold));
    }

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