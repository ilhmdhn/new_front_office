import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';

class FnBDialog{
  
  static Future<bool?> order(BuildContext ctx, List<OrderModel> orderlist, String outlet)async{
    final user = PreferencesData.getUser();

    Completer<bool?> completer = Completer<bool?>();

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext ctxDialog){
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (ctxWidget, StateSetter setState){
              return AlertDialog(
                backgroundColor: Colors.white,
                actionsPadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.all(0),
                titlePadding: const EdgeInsets.only(left: 12, right: 12, top: 6),
                buttonPadding: const EdgeInsets.all(0),
                content: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: CustomColorStyle.background(),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        itemCount: orderlist.length,
                        shrinkWrap: true,
                        itemBuilder: (ctxList, index){
                          final order = orderlist[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: CustomContainerStyle.whiteList(),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(child: AutoSizeText(order.name, maxLines: 2, minFontSize: 9,)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: ()async{
                                                if(order.qty>1){
                                                  order.qty = order.qty - 1;
                                                }else{
                                                  final state = await ConfirmationDialog.confirmation(ctxList, 'Hapus ${order.name}?');
                                                    if(state == true){
                                                      orderlist.removeAt(index);
                                                    }
                                                }
                                                setState((){
                                                  orderlist;
                                                  }
                                                );
                                              },
                                              child: SizedBox(
                                                height: 32,
                                                width: 32,
                                                child: Image.asset(
                                                  'assets/icon/minus.png'),
                                              )
                                            ),
                                            const SizedBox(width: 9,),
                                            AutoSizeText(order.qty.toString(), style: CustomTextStyle.blackMediumSize(21), maxLines: 1, minFontSize: 11,),
                                            const SizedBox(width: 9,),
                                            InkWell(
                                              onTap: (){
                                                setState((){
                                                  order.qty = order.qty + 1;
                                                });
                                              },
                                              child: SizedBox(
                                                height: 32,
                                                width: 32,
                                                child: Image.asset(
                                                  'assets/icon/plus.png'),
                                              )
                                            ),
                                          ]
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(height: 6,),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: (){
                      
                                              },
                                              child: const Icon(Icons.notes),
                                            ),
                                            const SizedBox(width: 2,),
                                            AutoSizeText(order.note, style: CustomTextStyle.blackStandard(), maxLines: 3,)
                                          ],
                                        )
                                        ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6,)
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 6,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(ctx, false);
                              },
                              child: Container(
                                decoration: CustomContainerStyle.cancelButton(),
                                padding: const  EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                child: AutoSizeText('CANCEL', style: CustomTextStyle.whiteSize(16), maxLines: 1,),
                              ),
                            ),
                          ),
                          const SizedBox(width: 19,),
                          Flexible(
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(ctx, false);
                              },
                              child: Container(
                                decoration: CustomContainerStyle.confirmButton(),
                                padding: const  EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                child: AutoSizeText('CONFIRM', style: CustomTextStyle.whiteSize(16), maxLines: 1,),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6,)
                    ],
                  ),
                ),
              );
            },
          ));
      }).then((value) => completer.complete(value));
      return completer.future;
  }
}