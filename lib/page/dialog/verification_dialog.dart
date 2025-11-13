import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/data/model/base_response.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/bloc/send_approval_bloc.dart';
import 'package:front_office_2/page/dialog/textfield_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/event_bus.dart';
import 'package:front_office_2/tools/fingerprint.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/orientation.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_countdown/slide_countdown.dart';

class VerificationDialog{
  static Future<bool?> requestVerification(BuildContext ctx, String reception, String room, String note)async{

    final user = PreferencesData.getUser();
    final isPotrait = isVertical(ctx);

    bool isLoading = true;
    bool isConfirmed = false;
    bool loadingCheck = false;

    Completer<bool?> completer = Completer<bool?>();
    String uniqueTime = DateTime.now().microsecondsSinceEpoch.toString();
    ApprovalCubit approvalCubit = ApprovalCubit();
    StreamSubscription? eventSubscription;
    StateSetter? dialogSetState;

    if(!['ACCOUNTING', 'KAPTEN', 'SUPERVISOR'].contains(user.level)){
      approvalCubit.sendApproval(uniqueTime, reception, room, note);
    }


    Widget animation(){
      return SizedBox(
        width: isPotrait == true? ScreenSize.getSizePercent(ctx, 50): ScreenSize.getSizePercent(ctx, 25),
        child: AspectRatio(
          aspectRatio: 1/1,
          child: isLoading == true?
          Lottie.asset('assets/animation/waiting_verification.json'):
          isConfirmed == true?
          Lottie.asset('assets/animation/confirmed.json'):
          Lottie.asset('assets/animation/reject.json')
          ),
      );
    }

    Widget countdown(){
      return 
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                isPotrait == true?
                AutoSizeText('Batal otomatis', style: CustomTextStyle.blackStandard(), maxLines: 2, minFontSize: 5, textAlign: TextAlign.center,):
                Text('Batal otomatis', style: CustomTextStyle.blackStandard(), maxLines: 2, textAlign: TextAlign.center,),

                SlideCountdown(
                duration: const Duration(minutes: 2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: CustomColorStyle.appBarBackground(),
                ),
                onDone: ()async{
                  final timeOutState = await  CloudRequest.timeoutApproval(uniqueTime);
                  if(timeOutState.state == true && ctx.mounted){
                    CloudRequest.cancelApproval(uniqueTime);
                    showToastWarning('Permintaan Dibatalkan');
                    Navigator.pop(ctx, false);
                  }
                },
                ),
              ],
            ),
          );
    }

    if(['ACCOUNTING', 'KAPTEN', 'SUPERVISOR'].contains(user.level)){
      final biometricResult = await FingerpintAuth().requestFingerprintAuth();
      return biometricResult;
    }
    showDialog(
      context: ctx, 
      barrierDismissible: false,
      builder: (BuildContext ctxDialog){
        String reason = '';

        return PopScope(
          canPop: true,
          child: StatefulBuilder(
            builder: (BuildContext ctxWidget, StateSetter setState){
              // Simpan setState reference hanya sekali
              dialogSetState ??= setState;

              // Setup event listener hanya sekali
              eventSubscription ??= eventBus.on<ConfirmationSignalModel>().listen((event) {
                if(uniqueTime == event.code){
                  if(ctxWidget.mounted && ctx.mounted && ctxDialog.mounted){
                    dialogSetState?.call(() {
                      if(event.state == true){
                        isLoading = false;
                        isConfirmed = true;
                      }else{
                        isLoading = false;
                        isConfirmed = false;
                      }
                    });
                  }
                }
              });
              Widget buttonCancel(){
                return InkWell(
                  onTap: (){
                    setState(() {
                      CloudRequest.cancelApproval(uniqueTime);
                      Navigator.pop(ctx, false);
                    });
                  }, 
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.shade400,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: AutoSizeText('CANCEL', style: CustomTextStyle.whiteStandard(), minFontSize: 9, maxLines: 1,)
                  )
                );
              }

              Widget buttonPositive(){
                return InkWell(
                  onTap: ()async{
                  if(isLoading == true){
                      final checkState = await CloudRequest.approvalState(uniqueTime);
                      if(loadingCheck == true){
                        return;
                      }
                      loadingCheck = true;
                      if(checkState.state != true){
                        showToastError(checkState.message??'Error Check Approval State');
                      }else{
                        if(checkState.message == "1"){
                          showToastWarning("Verifikasi belum disetujui");
                        }else if(checkState.message == "2"){
                          setState(() {
                            isLoading = false;
                            isConfirmed = true;
                          });
                        }else if(checkState.message == "3"){
                          setState((){
                            isLoading = false;
                            isConfirmed = false;
                          });
                        }
                      }
                      loadingCheck = false;
                  }else if(isConfirmed == true){
                    CloudRequest.finishApproval(uniqueTime);
                    Navigator.pop(ctx, true);
                  }else if(isConfirmed == false){
                    CloudRequest.finishApproval(uniqueTime);
                    Navigator.pop(ctx, false);
                  }
                  }, 
                            child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: AutoSizeText( isLoading == true? 'CHECK': isConfirmed==true? 'CONFIRM':'KEMBALI', style: CustomTextStyle.whiteStandard(), minFontSize: 9, maxLines: 1,)));
              }

              return AlertDialog(
                actionsPadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.all(0),
                titlePadding: const EdgeInsets.only(left: 12, right: 12, top: 6),
                buttonPadding: const EdgeInsets.all(0),
                // insetPadding: const EdgeInsets.all(0),
                title:
                isLoading == true?
                Center(
                  child: isPotrait == true?
                  AutoSizeText('Menunggu Verifikasi Kapten/ Spv', style: CustomTextStyle.titleAlertDialogSize(16), minFontSize: 9,maxLines: 1,):
                  Text('Menunggu Verifikasi Kapten/ Spv', style: CustomTextStyle.titleAlertDialogSize(16), maxLines: 1,)                
                ):
                isConfirmed == true?
                Center(
                  child: isPotrait == true? 
                    AutoSizeText('Confirmed', style: CustomTextStyle.titleAlertDialogSize(16), minFontSize: 9,maxLines: 1,):
                    Text('Confirmed', style: CustomTextStyle.titleAlertDialogSize(16),maxLines: 1,)
                ):
                Center(
                  child: isPotrait == true? 
                    AutoSizeText('Ditolak', style: CustomTextStyle.titleAlertDialogSize(16), minFontSize: 9,maxLines: 1,):
                    Text('Ditolak', style: CustomTextStyle.titleAlertDialogSize(16) ,maxLines: 1,)
                  ),
                content: BlocBuilder<ApprovalCubit, BaseResponse>(
                  bloc: approvalCubit,
                  builder: (ctx, response){
                    return response.isLoading == true?
                    SizedBox(
                      height: ScreenSize.getHeightPercent(ctx, 25),
                      width: ScreenSize.getSizePercent(ctx, 25),
                      child: AddOnWidget.loading(),
                    ):
                    response.state != true?
                    SizedBox(
                      height: isPotrait? ScreenSize.getHeightPercent(ctx, 50): ScreenSize.getHeightPercent(ctx, 30),
                      width: isPotrait? ScreenSize.getSizePercent(ctx, 50): ScreenSize.getSizePercent(ctx, 55),
                      child: Center(
                        child: Text(response.message??'Error request Verification'),
                      ),
                    ):

                    isPotrait == true?
                    Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      animation(),
                      const SizedBox(height: 20,),
                      countdown(),
                      const SizedBox(height: 20,),
                      InkWell(
                        child: Row( mainAxisAlignment: MainAxisAlignment.center, children: [AutoSizeText(isNullOrEmpty(reason)?'isi catatan': reason, style: CustomTextStyle.blackStandard(), minFontSize: 12), const SizedBox(width: 12,),Image.asset('assets/icon/pencil.png', width: 16, height: 16,)],),
                        onTap: ()async{
                          final note = await TextFieldDialog().inputText(ctx);
                          setState(() {
                            reason = 'loading';
                          });
                          if(note!=null){
                            final state = await CloudRequest.approvalReason(uniqueTime, note);
                            if(state.state == true){
                              setState((){
                                reason = note;
                              });
                            }else{
                              showToastError('Gagal menambahkan alasan otorisasi ${state.message}');
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: buttonCancel(),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Flexible(
                            child: buttonPositive()
                          ),
                        ],
                      ),
                      const SizedBox(height: 12,)
                    ],
                  ):
                  Container(
                    width: ScreenSize.getSizePercent(ctx, 55),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        animation(),
                        const SizedBox(width: 10,),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            countdown(),
                            const SizedBox(height: 12,),
                            Row(
                              children: [
                                buttonCancel(),
                                const SizedBox(width: 12,),
                                buttonPositive(),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  );
                  }),
              );
            },
          ),
        );
      }).then((value) {
        // Cleanup: cancel subscription saat dialog ditutup
        eventSubscription?.cancel();
        approvalCubit.close();
        completer.complete(value);
      });
      return completer.future;
  }
}