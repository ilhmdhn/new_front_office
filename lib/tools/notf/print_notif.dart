import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';

class PrintNotification {

  static final navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? get context => navigatorKey.currentContext;


  static void showPrinting() {
    ElegantNotification(
      title: const Text(
        'Mencetak...',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Row(
        children: const [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Sedang mengirim data ke printer'),
        ],
      ),
      background: Colors.white,
      showProgressIndicator: false,
      autoDismiss: false,
      animation: AnimationType.fromTop,
      animationDuration: const Duration(milliseconds: 400),
      position: Alignment.topCenter,
      isDismissable: false,
      shadow: BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ).show(context!);
  }

  static void showSuccess() {
    ElegantNotification.success(
      title: const Text('Berhasil'),
      description: const Text('Struk berhasil dicetak'),
      animation: AnimationType.fromTop,
      position: Alignment.topCenter,
      toastDuration: const Duration(seconds: 2),
    ).show(context!);
  }

  static void showError() {
    ElegantNotification.error(
      title: const Text('Gagal'),
      description: const Text('Printer tidak terhubung'),
      animation: AnimationType.fromTop,
      position: Alignment.topCenter,
      toastDuration: const Duration(seconds: 3),
    ).show(context!);
  }
}