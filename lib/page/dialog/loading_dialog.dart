import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/di.dart';

class LoadingDialog {
  static bool _isShowing = false;

  static BuildContext? get _context => navigatorKey.currentContext;

  /// Tampilkan loading dialog. Opsional [message] untuk teks di bawah spinner.
  static void show({String message = 'Memuat...'}) {
    final ctx = _context;
    if (_isShowing || ctx == null || !ctx.mounted) return;
    _isShowing = true;

    showDialog<void>(
      context: ctx,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (ctxDialog) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: CustomColorStyle.appBarBackground(),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    message,
                    style: CustomTextStyle.blackSize(14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() => _isShowing = false);
  }

  /// Tutup loading dialog.
  static void hide() {
    if (!_isShowing) return;
    _isShowing = false;
    navigatorKey.currentState?.pop();
  }

  static bool get isShowing => _isShowing;
}
