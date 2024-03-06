import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'dart:async';

class CheckinDurationDialog {
  Future<int?> setCheckinTime(BuildContext ctx, String roomCode) async {
    Completer<int?> completer = Completer<int?>();
    int checkinTime = 2;
    showDialog<int>(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              roomCode,
              style: CustomTextStyle.titleAlertDialog(),
            ),
          ),
          backgroundColor: Colors.white,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
                return SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            setState((){
                              if(checkinTime>0){
                                --checkinTime;
                              }
                            });
                          },
                          child: SizedBox(
                            height: 46,
                            width: 46,
                            child: Image.asset(
                              'assets/icon/minus.png'),
                          )
                        ),
                        const SizedBox(width: 12,),
                        Text(checkinTime.toString(), style: CustomTextStyle.blackMediumSize(29),),
                        const SizedBox(width: 12,),
                        InkWell(
                          onTap: (){
                            setState((){
                              if(checkinTime < 24){
                                ++checkinTime;
                              }
                            });
                          },
                          child: SizedBox(
                            height: 46,
                            width: 46,
                            child: Image.asset(
                              'assets/icon/plus.png'),
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: CustomButtonStyle.cancel(),
                            child: Text('Cancel', style: CustomTextStyle.whiteStandard(),),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, checkinTime);
                            },
                            style: CustomButtonStyle.confirm(),
                            child: Text('Checkin', style: CustomTextStyle.whiteStandard()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            ),
        );
      },
    ).then((value) {
      completer.complete(value); // Menyelesaikan future dengan nilai yang diterima dari dialog
    });
    return completer.future; // Mengembalikan future untuk mendapatkan nilai int dari dialog
  }
}
