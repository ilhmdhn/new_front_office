import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/checkin_body.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';
import 'package:front_office_2/data/model/voucher_member_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/dialog/promo_dialog.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/dialog/verification_dialog.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';
class EditCheckinPage extends StatefulWidget {
  static const nameRoute = '/edit-checkin';
  const EditCheckinPage({super.key});

  @override
  State<EditCheckinPage> createState() => _EditCheckinPageState();
}

class _EditCheckinPageState extends State<EditCheckinPage> {
  int pax = 1;
  int dpCode = 1;
  String? voucherCode;
  bool isLoading = true;
  String chooseEdc = '';
  String chooseCardType = '';
  PromoRoomModel? promoRoom;
  PromoFnbModel? promoFnb;
  DetailCheckinResponse? detailRoom;
  String roomCode = '';
  bool hasModified = false;
  DetailCheckinModel? dataCheckin;
  String remainingTime = 'Waktu Habis';
  bool approvalPromoRoomState = false;
  String chooseEdcName = '';
  String cardTypeName = "";
  String dpNote = "";
  String edcCode = "";
  VoucherMemberModel? voucherDetail;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventController = TextEditingController();

  void getData()async{
    detailRoom = await ApiRequest().getDetailRoomCheckin(roomCode);
    if(detailRoom?.state != true){
      showToastError(detailRoom?.message??'Error get room info');
    }


    isLoading = false;
    setState(() {
      isLoading;
      detailRoom;
      dataCheckin = detailRoom?.data;
    });
  }
  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    if(roomCode != ''&& detailRoom == null){
      getData();
    }
    if(isLoading == false && hasModified == false){
        promoRoom = dataCheckin?.promoRoom;
        promoFnb = dataCheckin?.promoFnb;
        pax = dataCheckin?.pax??1;
        hasModified = true;
    }

    int hourRemaining = (dataCheckin?.hourRemaining??0);
    int minuteRemaining = (dataCheckin?.minuteRemaining??0);

    if(hourRemaining>0 || minuteRemaining>0){
      remainingTime = 'Sisa';

      if(hourRemaining>0){
        remainingTime += ' $hourRemaining Jam';
      }

      if(minuteRemaining>0){
        remainingTime+= ' $minuteRemaining Menit';
      }
    }

    descriptionController.text = detailRoom?.data?.description??'';
    eventController.text = detailRoom?.data?.guestNotes??'';
    edcCode = detailRoom?.data?.edcMachine??'';
    dpNote = detailRoom?.data?.dpNote??'';
    cardTypeName = detailRoom?.data?.cardType??'';
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color:  Colors.white, //change your color here
          ),
          title: Text('Room Checkin', style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: isLoading == true?
        const Center(
          child: CircularProgressIndicator(),
        ):
        detailRoom?.state !=true?
        Center(
          child: Text(detailRoom?.message??'Error get Room Info'),
        ):
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: AutoSizeText('INFORMASI CHECKIN', style: CustomTextStyle.blackMediumSize(21), minFontSize: 12, maxLines: 1,),
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            AutoSizeText(dataCheckin!.memberName, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                            AutoSizeText(dataCheckin!.memberCode, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 39,color: CustomColorStyle.bluePrimary()),
                      Expanded(
                        child: Column(
                          children: [
                            AutoSizeText(dataCheckin!.roomCode, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                            AutoSizeText(remainingTime, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                        ],))
                    ],
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText('Jumlah Pengunjung', style: CustomTextStyle.blackMediumSize(15), maxLines: 1, minFontSize: 12,),
                      const SizedBox(width: 12,),
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: InkWell(
                          child: Image.asset(
                            'assets/icon/minus.png'),
                          onTap: (){
                          setState((){
                            if(pax>1){
                              --pax;
                            }
                          });
                        },
                        ),
                        ),
                      const SizedBox(width: 12,),
                      Text(pax.toString(), style: CustomTextStyle.blackMediumSize(21),),
                      const SizedBox(width: 12,),
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: InkWell(
                          child: Image.asset(
                            'assets/icon/plus.png'),
                          onTap: (){
                          setState((){
                            ++pax;
                          });
                        },
                        ),
                        ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Voucher Puppy Club', style: CustomTextStyle.blackMediumSize(17),)),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isNullOrEmpty(voucherCode)? InkWell(
                          onTap: ()async{
                            final qrCode = await showQRScannerDialog(context);
                    
                            if(qrCode != null){
                              final voucherState = await CloudRequest.memberVoucher(detailRoom?.data?.memberCode??'', qrCode);
                    
                              if(voucherState.state != true){
                                showToastError(voucherState.message??'Error get voucher data');
                                return;
                              }
                    
                              setState(() {
                                voucherCode = qrCode;
                                voucherDetail = voucherState.data;
                              });
                            }
                          },
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            decoration: CustomContainerStyle.blueButton(),
                            alignment: Alignment.center,
                            child: Text('Scan Voucher', style: CustomTextStyle.whiteStandard(),)),):
                          //testtt  
                            Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.7,
                                ),
                                borderRadius: BorderRadius.circular(10), // Bentuk border
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: AutoSizeText(voucherDetail?.voucherName??'', style: CustomTextStyle.blackMediumSize(17)),
                                  ),
                                  Row(
                                    children: [
                                      voucherDetail?.voucherPrice != null && (voucherDetail?.voucherPrice??0) > 0?
                                      Text('Nominal Voucher :', style: CustomTextStyle.blackStandard()): const SizedBox(),
                                      const SizedBox(width: 5,),
                                      Expanded(child: AutoSizeText(Formatter.formatRupiah((voucherDetail?.voucherPrice??0)), style: CustomTextStyle.blackStandard(), minFontSize: 7, maxLines: 1,))
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: ()async{
                                        if(dataCheckin?.voucher == null){
                                          setState(() {
                                            voucherCode = null;
                                            voucherDetail = null;
                                          });
                                        }else{
                                          if(context.mounted){
                                            final removeVoucherState = await VerificationDialog.requestVerification(context, (detailRoom?.data?.reception??'unknown') , roomCode, 'Hapus Voucher $voucherCode')??false;
                                          }
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent.shade400,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                          child: Text('Hapus Voucher', style: CustomTextStyle.whiteSize(14),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //testtt
                          const SizedBox(width: 6,), 
                          // voucherCode!=null?AutoSizeText(voucherCode.toString(), style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 12,): const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6,), 
                  promoRoom == null?
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6,),
                        Text('Promo Room', style: CustomTextStyle.blackMediumSize(17),),
                        const SizedBox(height: 2,),
                        InkWell(
                          onTap: ()async{
                            final nganu = await PromoDialog().setPromoRoom(context, 'PR A');
                            if(nganu != null){  
                              setState(() {
                                promoRoom = nganu;
                              });
                            }
                          },
                          child: Container(
                            width: 150,
                            decoration: CustomContainerStyle.blueButton(),
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            child: Text('Pilih Promo Room', style: CustomTextStyle.whiteStandard(),),
                          ),
                        )
                      ],
                    ),
                  ):Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 0.7,
                        ),
                        borderRadius: BorderRadius.circular(10), // Bentuk border
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: AutoSizeText('PROMO ROOM DIPILIH', style: CustomTextStyle.blackMediumSize(17)),
                          ),
                          Row(
                            children: [
                              Text('NAMA  PROMO :', style: CustomTextStyle.blackStandard()),
                              const SizedBox(width: 5,),
                              Expanded(child: AutoSizeText(promoRoom?.promoName??'', style: CustomTextStyle.blackStandard(), minFontSize: 7, maxLines: 1,))
                            ],
                          ),
                          Row(
                            children: [
                              Text('VALUE  PROMO :', style: CustomTextStyle.blackStandard()),
                              const SizedBox(width: 5,),
                              Expanded(child: AutoSizeText('${(promoRoom?.promoPercent??0) > 0? '${promoRoom?.promoPercent}%' : ''} ${(promoRoom?.promoIdr??0) > 0? Formatter.formatRupiah((promoRoom?.promoIdr??0).toInt()) : ''}', style: CustomTextStyle.blackStandard(), minFontSize: 7, maxLines: 1,))
                            ],
                          ),
                          Row(
                            children: [
                              Text('MASA BERLAKU :', style: CustomTextStyle.blackStandard()),
                              const SizedBox(width: 5,),
                              AutoSizeText('${promoRoom?.timeStart} - ${promoRoom?.timeFinish}', style: CustomTextStyle.blackStandard(), minFontSize: 9,)
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: ()async{
                                if(dataCheckin?.promoRoom == null){
                                  setState(() {
                                    promoRoom = null;
                                  });
                                }else{
                                  if(context.mounted){
                                    approvalPromoRoomState = await VerificationDialog.requestVerification(context, (detailRoom?.data?.reception??'unknown') , roomCode, 'Hapus Promo Room')??false;
                                    if(approvalPromoRoomState == true){
                                      final state = await ApiRequest().removePromoRoom(dataCheckin?.reception??'');
                                      if(state.state != true){
                                        showToastError('Gagal menghapus promo room ${state.message}');
                                        return;
                                      }
                                      setState(() {
                                        promoRoom = null;
                                      });
                                    }
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                  child: Text('Hapus Promo', style: CustomTextStyle.whiteSize(14),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  promoFnb == null?
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6,),
                        Text('Promo FnB', style: CustomTextStyle.blackMediumSize(19),),
                        InkWell(
                          onTap: ()async{
                            final choosePromo = await PromoDialog().setPromoFnb(context, 'PR A', 'PR A');
                            if(choosePromo != null){
                              setState(() {
                                promoFnb = choosePromo;
                              });
                            }
                          },
                          child: Container(
                            width: 150,
                            decoration: CustomContainerStyle.blueButton(),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            child: Text('Pilih Promo FnB', style: CustomTextStyle.whiteStandard(),),
                          ),),
                      ],
                    )):Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 0.7,
                        ),
                        borderRadius: BorderRadius.circular(10), // Bentuk border
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: AutoSizeText('PROMO FOOD DIPILIH', style: CustomTextStyle.blackMediumSize(17)),
                          ),
                          Row(
                            children: [
                              Text('NAMA  PROMO :', style: CustomTextStyle.blackStandard()),
                              const SizedBox(width: 5,),
                              Expanded(child: AutoSizeText(promoFnb?.promoName??'', style: CustomTextStyle.blackStandard(), minFontSize: 7, maxLines: 1,))
                            ],
                          ),
                          Row(
                            children: [
                              Text('VALUE  PROMO :', style: CustomTextStyle.blackStandard()),
                              const SizedBox(width: 5,),
                              Expanded(child: AutoSizeText('${(promoFnb?.promoPercent??0) > 0? '${promoFnb?.promoPercent}%' : ''} ${(promoFnb?.promoIdr??0) > 0? Formatter.formatRupiah((promoFnb?.promoIdr??0).toInt()) : ''}', style: CustomTextStyle.blackStandard(), minFontSize: 7, maxLines: 1,))
                            ],
                          ),
                          Row(
                            children: [
                              Text('MASA BERLAKU :', style: CustomTextStyle.blackStandard()),
                              const SizedBox(width: 5,),
                              AutoSizeText('${promoFnb?.timeStart} - ${promoFnb?.timeFinish}', style: CustomTextStyle.blackStandard(), minFontSize: 9,)
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: ()async{
                              if(dataCheckin?.promoFnb == null){
                                setState(() {
                                  promoFnb = null;
                                });
                              }else{
                                if(context.mounted){
                                  approvalPromoRoomState = await VerificationDialog.requestVerification(context, (detailRoom?.data?.reception??'unknown'), roomCode,'Hapus Promo FnB')??false;
                                  if(approvalPromoRoomState == true){
                                    final removeState = await ApiRequest().removePromoFood(dataCheckin?.reception??'');
                                    if(removeState.state != true){
                                      showToastError('Gagal hapus promo food ${removeState.message}');
                                      return;
                                    }
                                    setState(() {
                                      promoFnb = null;
                                    });
                                  }
                                } 
                              }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                  child: Text('Hapus Promo', style: CustomTextStyle.whiteSize(14),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12,),
                  Align(alignment: Alignment.centerLeft ,child: Text('Keterangan', style: CustomTextStyle.blackMedium(),)),
                  TextField(decoration: CustomTextfieldStyle.normalHint(''), controller: descriptionController,),
                  const SizedBox(height: 12,),
                  Align(alignment: Alignment.centerLeft ,child: Text('Acara', style: CustomTextStyle.blackMedium(),)),
                  TextField(decoration: CustomTextfieldStyle.normalHint(''), controller: eventController,),
                  const SizedBox(height: 12,),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: ()async{

                        final isConfirmed = await ConfirmationDialog.confirmation(context, 'Simpan Edit Checkin?');

                        if(isConfirmed != true){
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });
                        List<String> listPromo = [];
                        if(isNotNullOrEmpty(promoRoom?.promoName)){
                          listPromo.add(promoRoom!.promoName!);
                        }
                        if(isNotNullOrEmpty(promoFnb?.promoName)){
                          listPromo.add(promoFnb!.promoName!);
                        }
                        final params = EditCheckinBody(
                          room: dataCheckin!.roomCode,
                          pax: pax,
                          hp: dataCheckin!.hp,
                          dp: "",
                          description: descriptionController.text,
                          event: eventController.text,
                          chusr: 'ILHAM',
                          voucher: '',
                          dpNote: "",
                          cardType: "",
                          cardName: "",
                          cardNo: "",
                          cardApproval: "",
                          edcMachine: "",
                          memberCode: dataCheckin!.memberCode,
                          promo: listPromo,
                        );

                        final editResponse = await ApiRequest().editCheckin(params);
                        if(editResponse.state == true){
                          if(context.mounted){
                            Navigator.pushNamedAndRemoveUntil(context, MainPage.nameRoute, (route) => false);
                          }
                        }else{
                          showToastError(editResponse.message??'Error Edit data checkin');
                          setState(() {
                            isLoading = false;
                          });
                        }

                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: CustomContainerStyle.confirmButton(),
                        child: Center(child: Text('SIMPAN', style: CustomTextStyle.whiteSize(18),))),
                      ),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
  }

  @override
  void dispose() {
    descriptionController.dispose();
    eventController.dispose();
    super.dispose();
  }
}