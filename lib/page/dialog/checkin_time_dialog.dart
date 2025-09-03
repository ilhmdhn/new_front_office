import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/time_pax_model.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'dart:async';

class CheckinDurationDialog {
  Future<TimePaxModel?> setCheckinTime(BuildContext ctx, String roomCode, bool? isRoomCheckin) async {
    Completer<TimePaxModel?> completer = Completer<TimePaxModel?>();
    int checkinTime = 2;
    int pax = 5;
    showDialog<TimePaxModel>(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 23, left: 23, right: 23, bottom: 0),
          contentPadding: const EdgeInsets.only(top: 0, left: 23, right: 23, bottom: 12),
          title: Center(
            child: Text(
              roomCode,
              style: CustomTextStyle.titleAlertDialogSize(21),
            ),
          ),
          backgroundColor: Colors.white,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                    const SizedBox(height: 16,),
                    isRoomCheckin == true?
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText('Durasi Jam', style: CustomTextStyle.blackMediumSize(19), maxLines: 1, minFontSize: 11,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){
                                    setState((){
                                      if(checkinTime>1){
                                        --checkinTime;
                                      }
                                    });
                                  },
                                  child: SizedBox(
                                    height: 43,
                                    width: 43,
                                    child: Image.asset('assets/icon/minus.png'),
                                  )
                                ),
                                const SizedBox(width: 9,),
                                AutoSizeText(checkinTime.toString(), style: CustomTextStyle.blackMediumSize(26), maxLines: 1, minFontSize: 11,),
                                const SizedBox(width: 9,),
                                InkWell(
                                  onTap: (){
                                    setState((){
                                      if(checkinTime < 24){
                                        ++checkinTime;
                                      }
                                    });
                                  },
                                  child: SizedBox(
                                    height: 43,
                                    width: 43,
                                    child: Image.asset('assets/icon/plus.png'),
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ):Container(color: Colors.amber,),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('PAX', style: CustomTextStyle.blackMediumSize(19),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                setState((){
                                  if(pax>1){
                                    --pax;
                                  }
                                });
                              },
                              child: SizedBox(
                                height: 43,
                                width: 43,
                                child: Image.asset(
                                  'assets/icon/minus.png'),
                              )
                            ),
                            const SizedBox(width: 9,),
                            AutoSizeText(pax.toString(), style: CustomTextStyle.blackMediumSize(26), maxLines: 1, minFontSize: 11,),
                            const SizedBox(width: 9,),
                            InkWell(
                              onTap: (){
                                setState((){
                                    ++pax;
                                });
                              },
                              child: SizedBox(
                                height: 43,
                                width: 43,
                                child: Image.asset(
                                  'assets/icon/plus.png'),
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                              Navigator.pop(context, TimePaxModel(duration: checkinTime, pax: pax));
                            },
                            style: CustomButtonStyle.confirm(),
                            child: Text('Checkin', style: CustomTextStyle.whiteStandard()),
                          ),
                        ),
                      ],
                    ),
                  ],
              );
            }
            ),
        );
      },
    ).then((value) {
      completer.complete(value);
    });
    return completer.future;
  }
}
