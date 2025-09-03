import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';
import 'dart:async';

import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/toast.dart';

class PromoDialog {
  Future<PromoRoomModel?> setPromoRoom(
    BuildContext ctx, String roomType) async {
    bool isProcess = false;
    // final heightSize = MediaQuery.of(ctx).size.height * 0.7;
    final widthSize = MediaQuery.of(ctx).size.width * 1;
    Completer<PromoRoomModel?> completer = Completer<PromoRoomModel?>();
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          PromoRoomResponse promoRoomResponse = PromoRoomResponse();
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              void getPromoRoomData(roomType) async {
                promoRoomResponse = await ApiRequest().getPromoRoom(roomType);

                if (context.mounted) {
                  if (promoRoomResponse.state == true) {
                    setState(() {
                      promoRoomResponse;
                    });
                  } else {
                    showToastError(promoRoomResponse.message ??
                        'Error get Promo Room Data');
                    Navigator.pop(context);
                  }
                }
              }

              if (isProcess == false) {
                getPromoRoomData(roomType);
                isProcess = true;
              }
              List<PromoRoomModel> promoRoomList = promoRoomResponse.data;
              return AlertDialog(
                surfaceTintColor: CustomColorStyle.background(),
                contentPadding: const EdgeInsets.all(15),
                insetPadding: const EdgeInsets.all(20),  
                backgroundColor: Colors.white,
                
                title: Center(
                    child: Text(
                  'Promo Room',
                  style: CustomTextStyle.titleAlertDialogSize(21),
                )),
                content: promoRoomResponse.isLoading == true
                    ? SizedBox(
                      width: widthSize,
                      child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                    )
                    : SizedBox(
                        // height: heightSize,
                        width: widthSize,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: promoRoomList.length,
                          itemBuilder: (context, index) {
                            final dataPromo = promoRoomList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context, promoRoomList[index]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey, // Warna border
                                        width: 1, // Lebar border dalam pixel
                                      ),
                                      borderRadius: BorderRadius.circular(6)
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          dataPromo.promoName!,
                                          style:
                                              CustomTextStyle.blackMediumSize(
                                                  14),
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            (dataPromo.promoPercent ?? 0) > 0
                                                ? AutoSizeText(
                                                    'Promo Percent ${dataPromo.promoPercent.toString()}%',
                                                    style: CustomTextStyle.blackMediumSize(14),
                                                    minFontSize: 9,
                                                  )
                                                : const SizedBox(),
                                            (dataPromo.promoIdr ?? 0) > 0 ? 
                                              AutoSizeText('Promo idr ${Formatter.formatRupiah(dataPromo.promoIdr ?? 0)})',
                                                style: CustomTextStyle.blackMediumSize(14),
                                                  minFontSize: 9,
                                              ) : const SizedBox()
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: AutoSizeText('Masa berlaku ${dataPromo.timeStart} - ${dataPromo.timeFinish}',
                                                  style:CustomTextStyle.blackMediumSize(14),
                                                  minFontSize: 9
                                                 ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          },
                        ),
                      ),
              );
            },
          );
        }).then((value) => completer.complete(value));
        return completer.future;
  }

Future<PromoFnbModel?> setPromoFnb(
  BuildContext ctx, String roomType, String roomCode) async {
  bool isProcess = false;
  final widthSize = MediaQuery.of(ctx).size.width * 1;
  Completer<PromoFnbModel?> completer = Completer<PromoFnbModel?>();
  PromoFnbResponse promoFnbResponse = PromoFnbResponse();
  List<PromoFnbModel> listPromoFnb = [];
  showDialog(
    context: ctx,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void getPromoFnbData(String roomType, String roomCode) async {
            promoFnbResponse = await ApiRequest().getPromoFnB(roomType, roomCode);
            if (context.mounted) {
              if (promoFnbResponse.state == true) {
                listPromoFnb = promoFnbResponse.data;
                setState(() {
                  listPromoFnb;
                });
              } else {
                showToastError(promoFnbResponse.message ?? 'Error get promo fnb');
                Navigator.pop(context);
              }
            }
          }

          if (!isProcess) {
            getPromoFnbData('PR A', 'PR A');
            isProcess = true;
          }
          return AlertDialog(
            surfaceTintColor: CustomColorStyle.background(),
            contentPadding: const EdgeInsets.all(15),
            insetPadding: const EdgeInsets.all(20),  
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                'Promo FnB',
                style: CustomTextStyle.titleAlertDialogSize(23),
              )
            ),
            content: promoFnbResponse.isLoading == true
              ? SizedBox(
                width: widthSize,
                child: Center(
                  child: CircularProgressIndicator(
                    color: CustomColorStyle.appBarBackground(),
                  ),
                ),
              )
              : SizedBox(
                width: widthSize,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listPromoFnb.length,
                  itemBuilder: (context, index){
                    final promoData = listPromoFnb[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context, promoData);
                          },
                          child: Container(
                            width: widthSize,
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  promoData.promoName!,
                                  style: CustomTextStyle.blackMediumSize(14),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (promoData.promoPercent ?? 0) > 0? 
                                      AutoSizeText('Promo Percent ${promoData.promoPercent.toString()}%',
                                        style: CustomTextStyle.blackMediumSize(14), minFontSize: 9,
                                          )
                                    : const SizedBox(),
                                    (promoData.promoIdr ?? 0) > 0 ? 
                                      AutoSizeText('Promo idr ${Formatter.formatRupiah(promoData.promoIdr ?? 0)})',
                                        style: CustomTextStyle.blackMediumSize(14), minFontSize: 9,
                                        ) 
                                    : const SizedBox()
                                  ],
                                ),
                                Text(
                                  'Masa berlaku ${promoData.timeStart} - ${promoData.timeFinish}',
                                  style: CustomTextStyle.blackMediumSize(14),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ),
          );
        },
      );
    },
  ).then((value) => completer.complete(value));
  return completer.future;
}
}
