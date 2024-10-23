import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class DisplayNotif{
  static void doInstruction(BuildContext ctx ,String description){
    ElegantNotification.success(
      title: Text('Delivery Order', style: CustomTextStyle.blackMedium()),
      description: const Text('Item Aaa siap diantarkan'),
      icon: const Icon(Icons.fastfood, color: Colors.green,),
      toastDuration: const Duration(seconds: 5),
      ).show(ctx);
  }

    static void approvalRequest(BuildContext ctx, String description) {
      ElegantNotification.success(
        title: Text('Permintaan Persetujuan', style: CustomTextStyle.blackMedium()),
        description: Text(description, style: CustomTextStyle.blackStandard(),),
        icon: const Icon(
          Icons.verified,
          color: Colors.yellow,
        ),
        progressIndicatorBackground: Colors.yellow,
        toastDuration: const Duration(seconds: 5),
      ).show(ctx);
    }
}