import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/data/model/base_response.dart';
import 'package:front_office_2/data/model/verification_result_model.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/bloc/send_approval_bloc.dart';
import 'package:front_office_2/page/dialog/textfield_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/provider_container.dart';
import 'package:front_office_2/riverpod/user_provider.dart';
import 'package:front_office_2/tools/event_bus.dart';
import 'package:front_office_2/tools/fingerprint.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/orientation.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_countdown/slide_countdown.dart';

class VerificationDialog{

  static Future<VerificationResultModel> requestVerification(
    BuildContext ctx,
    String reception,
    String room,
    String note,
  ) async {
    final user = GlobalProviders.read(userProvider);
    final isPotrait = isVertical(ctx);

    bool isLoading = true;
    bool isConfirmed = false;
    String approver = '';
    bool loadingCheck = false;
    bool onEditText = false;

    String uniqueTime = DateTime.now().microsecondsSinceEpoch.toString();
    ApprovalCubit approvalCubit = ApprovalCubit();
    StreamSubscription? eventSubscription;
    StateSetter? dialogSetState;

    if (!['ACCOUNTING', 'KAPTEN', 'SUPERVISOR'].contains(user.level)) {
      approvalCubit.sendApproval(uniqueTime, reception, room, note);
    }

    // 🔐 bypass pakai fingerprint
    if (['ACCOUNTING', 'KAPTEN', 'SUPERVISOR'].contains(user.level)) {
      final biometricResult = await FingerpintAuth().requestFingerprintAuth();
      approver = user.userId;
      return VerificationResultModel(
        state: biometricResult,
        message: 'Disetujui melalui otentikasi biometrik',
        approver: approver,
      );
    }

    final result = await showDialog<VerificationResultModel>(
      context: ctx,
      barrierDismissible: true,
      builder: (BuildContext ctxDialog) {
        String reason = '';

        Widget animation() {
          return SizedBox(
            width: isPotrait
                ? ScreenSize.getSizePercent(ctx, 50)
                : ScreenSize.getSizePercent(ctx, 25),
            child: AspectRatio(
              aspectRatio: 1,
              child: isLoading
                  ? Lottie.asset('assets/animation/waiting_verification.json')
                  : isConfirmed
                      ? Lottie.asset('assets/animation/confirmed.json')
                      : Lottie.asset('assets/animation/reject.json'),
            ),
          );
        }

        Widget countdown() {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Batal otomatis',
                  style: CustomTextStyle.blackStandard(),
                  textAlign: TextAlign.center,
                ),
                SlideCountdown(
                  duration: const Duration(minutes: 2),
                  replacement: Text(
                    'Waktu Habis, ulangi proses verifikasi',
                    style: GoogleFonts.poppins(
                        color: Colors.deepOrange.shade900, fontSize: 14),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: CustomColorStyle.appBarBackground(),
                  ),
                  onDone: () async {
                    final timeOutState =
                        await CloudRequest.timeoutApproval(uniqueTime);
                    if (timeOutState.state == true &&
                        ctx.mounted &&
                        !onEditText) {
                      CloudRequest.cancelApproval(uniqueTime);
                      showToastWarning('Permintaan Dibatalkan');

                      if (ctxDialog.mounted) {
                        Navigator.pop(
                          ctxDialog,
                          VerificationResultModel(
                            state: false,
                            message: 'Waktu habis',
                            approver: user.userId,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          );
        }

        return PopScope(
          canPop: true,
          child: StatefulBuilder(
            builder: (ctxWidget, setState) {
              dialogSetState ??= setState;

              eventSubscription ??= eventBus.on<ConfirmationSignalModel>().listen((event) {
                if (uniqueTime == event.code &&
                    ctxWidget.mounted &&
                    ctxDialog.mounted) {
                  dialogSetState?.call(() {
                    isLoading = false;
                    isConfirmed = event.state;
                    approver = event.approver;
                  });
                }
              });

              Widget buttonCancel() {
                return ElevatedButton(
                  onPressed: () {
                    CloudRequest.cancelApproval(uniqueTime);
                    Navigator.pop(
                      ctxDialog,
                      VerificationResultModel(
                        state: false,
                        message: 'Dibatalkan oleh pengguna',
                        approver: user.userId,
                      ),
                    );
                  },
                  style: CustomButtonStyle.cancel(),
                  child: Text('CANCEL',
                      style: CustomTextStyle.whiteStandard()),
                );
              }

              Widget buttonPositive() {
                return ElevatedButton(
                  onPressed: () async {
                    if (isLoading) {
                      if (loadingCheck) return;
                      loadingCheck = true;

                      try {
                        final checkState =await CloudRequest.approvalState(uniqueTime);

                        if (checkState.state != true) {
                          showToastError(checkState.message ?? 'Error Check Approval');
                        } else {
                          if (checkState.data?.state == "1") {
                            showToastWarning("Verifikasi belum disetujui");
                          } else if (checkState.data?.state == "2") {
                            if (!ctxWidget.mounted) return;
                            setState(() {
                              isLoading = false;
                              isConfirmed = true;
                              approver = checkState.data?.approver ?? '';
                            });
                          } else if (checkState.data?.state == "3") {
                            if (!ctxWidget.mounted) return;
                            setState(() {
                              isLoading = false;
                              isConfirmed = false;
                              approver = checkState.data?.approver ?? '';
                            });
                          }
                        }
                      } finally {
                        loadingCheck = false;
                      }
                    } else {
                      CloudRequest.finishApproval(uniqueTime);

                      Navigator.pop(
                        ctxDialog,
                        VerificationResultModel(
                          state: isConfirmed,
                          message: reason,
                          approver: approver,
                        ),
                      );
                    }
                  },
                  style: CustomButtonStyle.confirm(),
                  child: Text(
                    isLoading
                        ? 'CHECK'
                        : isConfirmed
                            ? 'CONFIRM'
                            : 'KEMBALI',
                    style: CustomTextStyle.whiteStandard(),
                  ),
                );
              }

              return AlertDialog(
                backgroundColor: CustomColorStyle.background(),
                title: Center(
                  child: Text(
                    isLoading
                        ? 'Menunggu Verifikasi Kapten/ Spv'
                        : isConfirmed
                            ? 'Confirmed'
                            : 'Ditolak',
                    style: CustomTextStyle.titleAlertDialogSize(16),
                  ),
                ),
                content: BlocBuilder<ApprovalCubit, BaseResponse>(
                  bloc: approvalCubit,
                  builder: (ctx, response) {
                    if (response.isLoading) {
                      return SizedBox(
                        height: ScreenSize.getHeightPercent(ctx, 25),
                        child: AddOnWidget.loading(),
                      );
                    }

                    if (response.state != true) {
                      return Center(
                        child: Text(
                            response.message ?? 'Error request Verification'),
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        animation(),
                        const SizedBox(height: 20),
                        countdown(),
                        InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center, 
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(isNullOrEmpty(reason)?'isi catatan': reason, style: CustomTextStyle.blackStandard(), maxLines: 3,)), 
                              const SizedBox(width: 12,),
                              Image.asset('assets/icon/pencil.png', width: 16, height: 16,)
                            ],
                          ),
                          onTap: ()async{
                            onEditText = true;
                            final note = await TextFieldDialog().inputText(ctx, reason);
                            onEditText = false;
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
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: buttonCancel()),
                            const SizedBox(width: 12),
                            Expanded(child: buttonPositive()),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );

    // cleanup
    eventSubscription?.cancel();
    approvalCubit.close();

    return result ??
        VerificationResultModel(
          state: false,
          message: 'Dialog ditutup',
          approver: approver,
        );
  }

  /*
  static Future<VerificationResultModel> requestVerification(BuildContext ctx, String reception, String room, String note)async{

    final user = GlobalProviders.read(userProvider);
    final isPotrait = isVertical(ctx);

    bool isLoading = true;
    bool isConfirmed = false;
    bool loadingCheck = false;

    Completer<VerificationResultModel?> completer = Completer<VerificationResultModel?>();
    String uniqueTime = DateTime.now().microsecondsSinceEpoch.toString();
    ApprovalCubit approvalCubit = ApprovalCubit();
    StreamSubscription? eventSubscription;
    StateSetter? dialogSetState;
    bool onEditText = false;

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
                Text('Batal otomatis', style: CustomTextStyle.blackStandard(), maxLines: 2, textAlign: TextAlign.center,):
                Text('Batal otomatis', style: CustomTextStyle.blackStandard(), maxLines: 2, textAlign: TextAlign.center,),

                SlideCountdown(
                duration: const Duration(minutes: 2),
                replacement: Text('Waktu Habis, ulangi proses verifikasi', style: GoogleFonts.poppins(color: Colors.deepOrange.shade900, fontSize: 14),),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: CustomColorStyle.appBarBackground(),
                ),
                onDone: ()async{
                  final timeOutState = await CloudRequest.timeoutApproval(uniqueTime);
                  if(timeOutState.state == true && ctx.mounted && !onEditText){
                    CloudRequest.cancelApproval(uniqueTime);
                    showToastWarning('Permintaan Dibatalkan');
                    if(ctx.mounted){
                      Navigator.pop(ctx, VerificationResultModel(result: false, message: 'Waktu habis', approver: user.userId));
                    }
                  }
                },
                ),
              ],
            ),
          );
    }

    if(['ACCOUNTING', 'KAPTEN', 'SUPERVISOR'].contains(user.level)){
      final biometricResult = await FingerpintAuth().requestFingerprintAuth();
      return VerificationResultModel(
        result: biometricResult, 
        message: '', 
        approver: user.userId
      );
    }
    showDialog(
      context: ctx, 
      barrierDismissible: true,
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
                return ElevatedButton(
                  onPressed: (){
                    setState(() {
                      CloudRequest.cancelApproval(uniqueTime);
                      Navigator.pop(ctx, VerificationResultModel(result: false, message: 'Dibatalkan oleh pengguna', approver: user.userId));
                    });
                  }, 
                  style: CustomButtonStyle.cancel(),
                  child: Text('CANCEL', style: CustomTextStyle.whiteStandard(), maxLines: 1,)
                );
              }

              Widget buttonPositive(){
                return ElevatedButton(
                  onPressed: ()async{
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
                    Navigator.pop(ctx, VerificationResultModel(result: true, message: reason, approver: ''));
                  }else if(isConfirmed == false){
                    CloudRequest.finishApproval(uniqueTime);
                    Navigator.pop(ctx, VerificationResultModel(result: false, message: reason, approver: ''));
                  }
                  },
                  style: CustomButtonStyle.confirm(), 
                  child: Text( isLoading == true? 'CHECK': isConfirmed==true? 'CONFIRM':'KEMBALI', style: CustomTextStyle.whiteStandard(), maxLines: 1,));
              }

              return AlertDialog(
                actionsPadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.all(0),
                backgroundColor: CustomColorStyle.background(),
                titlePadding: const EdgeInsets.only(left: 12, right: 12, top: 6),
                buttonPadding: const EdgeInsets.all(0),
                // insetPadding: const EdgeInsets.all(0),
                title:
                isLoading == true?
                Center(
                  child: isPotrait == true?
                  Text('Menunggu Verifikasi Kapten/ Spv', style: CustomTextStyle.titleAlertDialogSize(16),maxLines: 1,):
                  Text('Menunggu Verifikasi Kapten/ Spv', style: CustomTextStyle.titleAlertDialogSize(16), maxLines: 1,)                
                ):
                isConfirmed == true?
                Center(
                  child: isPotrait == true? 
                    Text('Confirmed', style: CustomTextStyle.titleAlertDialogSize(16),maxLines: 1,):
                    Text('Confirmed', style: CustomTextStyle.titleAlertDialogSize(16),maxLines: 1,)
                ):
                Center(
                  child: isPotrait == true? 
                    Text('Ditolak', style: CustomTextStyle.titleAlertDialogSize(16),maxLines: 1,):
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
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(isNullOrEmpty(reason)?'isi catatan': reason, style: CustomTextStyle.blackStandard(), maxLines: 3,)), 
                            const SizedBox(width: 12,),
                            Image.asset('assets/icon/pencil.png', width: 16, height: 16,)
                          ],
                        ),
                        onTap: ()async{
                          onEditText = true;
                          final note = await TextFieldDialog().inputText(ctx, reason);
                          onEditText = false;
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
  */
}