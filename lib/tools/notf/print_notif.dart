import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/tools/di.dart';

class PrintNotification {
  static BuildContext? get context => navigatorKey.currentContext;
  static void showSuccess() {
    ElegantNotification.success(
      title: const Text('Berhasil'),
      description: const Text('Struk berhasil dicetak'),
      animation: AnimationType.fromRight,
      position: Alignment.topRight,
      toastDuration: const Duration(seconds: 2),
    ).show(context!);
  }

  static void showError() {
    ElegantNotification.error(
      title: const Text('Gagal'),
      description: const Text('Printer tidak terhubung'),
      animation: AnimationType.fromRight,
      position: Alignment.topRight,
      toastDuration: const Duration(seconds: 3),
    ).show(context!);
  }
}