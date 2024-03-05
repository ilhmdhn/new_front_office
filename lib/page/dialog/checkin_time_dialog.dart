import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class CheckinDurationDialog{
  void setCheckinTime(ctx ,roomCode){
    showDialog(
      context: ctx, 
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: Center(
                child: Text(roomCode, style: CustomTextStyle.titleAlertDialog(),),
              ),
              backgroundColor: Colors.white,
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [],
                    )
                  ],
                ),
              ),
            );
          });
      });
  }
}