import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:get_it/get_it.dart';

  bool isNullOrEmpty(value){
    return value == null || value.isEmpty;
  }

  bool isNotNullOrEmpty(value) {
    return value != null && value.isNotEmpty;
  }

  bool _isRoomCallDialogOpen = false;

void showRoomCallDialog(RemoteMessage message) {
  if (_isRoomCallDialogOpen) return;

  final context = GetIt.instance<NavigationService>().navigatorKey.currentContext;

  if (context == null) return;

  String messageContent = message.data['title'] ?? 'Unknown';

  _isRoomCallDialogOpen = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(Icons.notification_important, color: Colors.orange, size: 28),
              const SizedBox(width: 8),
              Flexible(
                fit: FlexFit.loose,
                child: Text(messageContent, maxLines: 2, style: CustomTextStyle.blackMedium())),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanggapi panggilan kamar',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _isRoomCallDialogOpen = false;
              Navigator.of(context).pop();
            },
            child: const Text('Dismiss'),
          ),
          ElevatedButton(
            onPressed: () {
              
              _isRoomCallDialogOpen = false;
              Navigator.of(context).pop();
            },
            child: const Text('Handle'),
          ),
        ],
      );
    },
  ).then((_) {
    _isRoomCallDialogOpen = false;
  });
}
