import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/data/model/post_so_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/printer/print_executor.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';

class FnBDialog{
  
  static Future<String?> note(BuildContext ctx, String name, String note){
    Completer<String?> completer = Completer<String?>();
    showDialog(
      context: ctx,
      builder: (ctxDialog){
        TextEditingController tfNoteController = TextEditingController();
        tfNoteController.text = note;
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            width: ScreenSize.getSizePercent(ctxDialog, 80),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText('Tulis Catatan Pesanan', style: CustomTextStyle.blackStandard(), maxLines: 2, minFontSize: 12, textAlign: TextAlign.center,),
                AutoSizeText(name, style: CustomTextStyle.titleAlertDialogSize(16), maxLines: 2, minFontSize: 12, textAlign: TextAlign.center,),
                const SizedBox(height: 12,),
                TextField(
                  decoration: CustomTextfieldStyle.characterNormal(),
                  minLines: 1,
                  maxLines: 3,
                  controller: tfNoteController,
                ),
                const SizedBox(height: 6,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(ctx, null);
                        },
                        child: Container(
                          decoration: CustomContainerStyle.cancelButton(),
                          padding: const  EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          child: AutoSizeText('CANCEL', style: CustomTextStyle.whiteSize(16), maxLines: 1, textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                    const SizedBox(width: 19,),
                    Flexible(
                      fit: FlexFit.tight,
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(ctx, tfNoteController.text);
                        },
                        child: Container(
                          decoration: CustomContainerStyle.confirmButton(),
                          padding: const  EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          child: AutoSizeText('CONFIRM', style: CustomTextStyle.whiteSize(16), maxLines: 1, textAlign: TextAlign.center,),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).then((value) => completer.complete(value));
      return completer.future;
  }

  static Future<bool?> order(BuildContext ctx, List<SendOrderModel> orderlist, String roomCode)async{
    Completer<bool?> completer = Completer<bool?>();
    bool isLoading = false;
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext ctxDialog){
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (ctxWidget, StateSetter setState){
              if(orderlist.isEmpty){
                Navigator.pop(ctx, true);
              }
              return Dialog(
                backgroundColor: Colors.white,
                child: Container(
                  width: ScreenSize.getSizePercent(ctxDialog, 85),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: CustomColorStyle.background(),
                  ),
                  child: StatefulBuilder(
                    builder: (ctxStfl, setState){
                      
                      return
                      
                      isLoading == true?
                      SizedBox(
                        height: ScreenSize.getHeightPercent(ctx, 50),
                        child: Center(child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground(),),)):
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText('Konfirmasi Pesanan', style: CustomTextStyle.blackMediumSize(18), maxLines: 2, minFontSize: 12, textAlign: TextAlign.center,),
                          const SizedBox(height: 12,),
                        // Membungkus ListView.builder dengan Expanded
                          Flexible(
      fit: FlexFit.loose,
      child: ListView.builder(
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
                    const SizedBox(height: 6,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: ()async{
                            final noteResult = await note(ctx, order.name, order.note);
                            if(noteResult != null){
                              setState((){
                                orderlist[index].note = noteResult;
                              });
                            }
                          },
                          child: const Icon(Icons.notes),
                        ),
                        const SizedBox(width: 2,),
                        AutoSizeText(order.note, style: CustomTextStyle.blackStandard(), maxLines: 3,)
                      ],
                    ),
                   /* const SizedBox(height: 6,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            value: order.dineIn,
                            fillColor: order.dineIn? WidgetStateProperty.all(CustomColorStyle.bluePrimary()): WidgetStateProperty.all(Colors.white),
                            onChanged: (value){
                              setState((){
                                orderlist[index].dineIn = value ?? true;
                              });
                            }
                          ),
                        ),
                        AutoSizeText('Dine in', style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 10,),
                      ],
                    ),*/
                  ],
                ),
              ),
              const SizedBox(height: 6,)
            ],
          );
        },
      ),
    ),
    const SizedBox(height: 6,),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: InkWell(
            onTap: (){
              Navigator.pop(ctx, false);
            },
            child: Container(
              decoration: CustomContainerStyle.cancelButton(),
              padding: const  EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              child: AutoSizeText('CANCEL', style: CustomTextStyle.whiteSize(16), maxLines: 1, textAlign: TextAlign.center,),
            ),
          ),
        ),
        const SizedBox(width: 9,),
        Flexible(
          fit: FlexFit.tight,
          child: InkWell(
            onTap: ()async{
              setState((){
                isLoading = true;
              });
              final checkinDetail = await ApiRequest().getDetailRoomCheckin(roomCode);

              if(checkinDetail.state != true){
                setState((){
                  isLoading = false;
                });
                showToastError(checkinDetail.message);
                if(ctx.mounted){
                  Navigator.pop(ctx, false);
                }else{
                  showToastWarning('Gagal karena berpindah halaman');
                  return;
                }
              }

              final rcp = checkinDetail.data?.reception??'';
              final roomType = checkinDetail.data?.roomType??'';
              final checkinMinute = checkinDetail.data?.checkinMinute??0;
              bool finalState = false;
              
              final PostSoResponse orderState = await ApiRequest().sendOrder(roomCode, rcp, roomType, checkinMinute, orderlist);
              if(!orderState.state){
                showToastError('SO error ${orderState.message}');
              }
              finalState = orderState.state;
              final user = GlobalProviders.read(userProvider);

              //fix before compile
              //hilangkan opsi hp
              if (user.outlet.contains('CB') || user.outlet.contains('TB')) {
                if(isNotNullOrEmpty(orderState.data)){
                  final lastSoState = await ApiRequest().latestSo(rcp);
                  
                  if (lastSoState.state == true) {
                    final soCode = lastSoState.data;
                    final filteredData = (orderState.data ?? [])
                        .where((dataSo) => dataSo.sol == soCode)
                        .toList();
                    final doState = await ApiRequest().confirmDo(roomCode, filteredData);
                    finalState = doState.state ?? false;

                    if (doState.state != true) {
                      showToastError('DO error ${doState.message}');
                    }
                  }
                }
              }else{
                PrintExecutor.printLastSo(rcp, roomCode, checkinDetail.data?.memberName??'Guest', checkinDetail.data?.pax??1);
              }

              setState((){
                isLoading = false;
              });
              
              if(finalState != true){
                if(ctx.mounted){
                 Navigator.pop(ctx, false);
                }else{
                  showToastWarning('Gagal berpindah halaman');
                }
              }

              if(ctx.mounted){
                Navigator.pop(ctx, true);
              }else{
                showToastWarning('Gagal berpindah halaman');
              }
            },
            child: Container(
              decoration: CustomContainerStyle.confirmButton(),
              padding: const  EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              child: AutoSizeText('SEND SO', style: CustomTextStyle.whiteSize(16), maxLines: 1, textAlign: TextAlign.center),
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 6,)
  ],
);

                      /*Column(
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
                                                onTap: ()async{
                                                  final noteResult = await note(ctx, order.name, order.note);
                                                  if(noteResult != null){
                                                    setState((){
                                                      orderlist[index].note = noteResult;
                                                    });
                                                  }
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
                                onTap: ()async{
                                  setState((){
                                    isLoading = true;
                                  });
                                  final checkinDetail = await ApiRequest().getDetailRoomCheckin(roomCode);
                    
                                  if(checkinDetail.state != true){
                                    setState((){
                                      isLoading = false;
                                    });
                                    showToastError(checkinDetail.message);
                                    if(ctx.mounted){
                                      Navigator.pop(ctx, false);
                                    }else{
                                      showToastWarning('Gagal karena berpindah halaman');
                                      return;
                                    }
                                  }

                                  final rcp = checkinDetail.data?.reception??'';
                                  final roomType = checkinDetail.data?.roomType??'';
                                  final checkinMinute = checkinDetail.data?.checkinMinute??0;
                    
                                  final orderState = await ApiRequest().sendOrder(roomCode, rcp, roomType, checkinMinute, orderlist);
                                  DoPrint.lastSo(rcp, roomCode, checkinDetail.data?.memberName??'Guest', checkinDetail.data?.pax??1);
                                  setState((){
                                    isLoading = false;
                                  });
                                  
                                  if(orderState.state != true){
                                    showToastError(orderState.message.toString());
                                    if(ctx.mounted){
                                     Navigator.pop(ctx, false);
                                    }else{
                                      showToastWarning('Gagal berpindah halaman');
                                    }
                                  }
                    
                                  if(ctx.mounted){
                                    Navigator.pop(ctx, true);
                                  }else{
                                    showToastWarning('Gagal berpindah halaman');
                                  }
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
                    );*/
                    }
                  ),
                ),
              );
            },
          ));
      }).then((value) => completer.complete(value));
      return completer.future;
  }
}