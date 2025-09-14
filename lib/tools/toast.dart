// Toast functionality replaced with SnackBar to avoid plugin compatibility issues
import 'package:flutter/material.dart';
import 'package:front_office_2/tools/di.dart';

void showToastWarning(String text) {
  final context = navigatorKey.currentContext;
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.yellow.shade800,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

void showToastWarningLong(String text) {
  final context = navigatorKey.currentContext;
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.yellow.shade800,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

void showToastError(String text) {
  final context = navigatorKey.currentContext;
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.red.shade400,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}