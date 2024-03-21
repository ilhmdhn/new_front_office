import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/checkin_body.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/promo_dialog.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/dialog/radio_list_dialog.dart';
import 'package:front_office_2/page/operational/operational_page.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/list.dart';
import 'package:front_office_2/tools/rupiah.dart';
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
  EdcResponse? dataEdc;
  final _cashDpController = TextEditingController();
  bool isLoading = true;
  List<String> edcType = [];
  List<int> edcTypeCode = [];
  String chooseEdc = '';
  String chooseCardType = '';
  PromoRoomModel? promoRoom;
  PromoFnbModel? promoFnb;
  DetailCheckinResponse? detailRoom;
  String roomCode = '';
  bool hasModified = false;
  DetailCheckinModel? dataCheckin;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventController = TextEditingController();
  TextEditingController dpValueController = TextEditingController();


  void getData()async{
    detailRoom = await ApiRequest().getDetailRoomCheckin(roomCode);
    if(detailRoom?.state != true){
      showToastError(detailRoom?.message??'Error get room info');
    }
    dataEdc = await ApiRequest().getEdc();
    if(dataEdc?.state != true){
      showToastError(dataEdc?.message??'Unknown error get edc list');
    }
    showToastError('room code: ${detailRoom?.data?.roomCode??''} memberName ${detailRoom?.data?.memberCode??''}');
    isLoading = false;
    int nganu =1;
    dataEdc?.data.forEach((x){
      edcType.add(x.edcName??'unknown');
      edcTypeCode.add(nganu);
      nganu++;
    });
    setState(() {
      dataEdc;
      isLoading;
      edcType;
      edcTypeCode;
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
                            AutoSizeText('Sisa ${dataCheckin?.hourRemaining} Jam ${dataCheckin?.minuteRemaining} Menit', style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
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
                    child: Text('Voucher Puppy Club', style: CustomTextStyle.blackMedium(),)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            style: CustomButtonStyle.blueAppbar(),
                            onPressed: ()async{
                              final qrCode = await showQRScannerDialog(context);
                              if(qrCode != null){
                                setState(() {
                                  voucherCode = qrCode;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                              child: Text('Pilih', style: CustomTextStyle.whiteStandard(),),
                            ),),
                                            const SizedBox(width: 6,), 
                                            voucherCode!=null?AutoSizeText(voucherCode.toString(), style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 12,): const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 6,), 
                  promoRoom == null?
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Promo Room', style: CustomTextStyle.blackMedium(),),
                         ElevatedButton(
                           style: CustomButtonStyle.blueAppbar(),
                           onPressed: ()async{
                             final nganu = await PromoDialog().setPromoRoom(context, 'PR A');
                             if(nganu != null){  
                               setState(() {
                                 promoRoom = nganu;
                               });
                             }
                           },
                           child: Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                             child: Text('Pilih', style: CustomTextStyle.whiteStandard(),),
                           ),)
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
                              Expanded(child: AutoSizeText('${(promoRoom?.promoPercent??0) > 0? '${promoRoom?.promoPercent}%' : ''} ${(promoRoom?.promoIdr??0) > 0? Formatter().formatRupiah((promoRoom?.promoIdr??0).toInt()) : ''}', style: CustomTextStyle.blackStandard(), minFontSize: 7, maxLines: 1,))
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
                              onTap: (){
                                setState(() {
                                  promoRoom = null;
                                });
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
                        Text('Promo FnB', style: CustomTextStyle.blackMedium(),),
                        ElevatedButton(
                          style: CustomButtonStyle.blueAppbar(),
                          onPressed: ()async{
                            final choosePromo = await PromoDialog().setPromoFnb(context, 'PR A', 'PR A');
                            if(choosePromo != null){
                              setState(() {
                                promoFnb = choosePromo;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                            child: Text('Pilih', style: CustomTextStyle.whiteStandard(),),
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
                              Expanded(child: AutoSizeText('${(promoFnb?.promoPercent??0) > 0? '${promoFnb?.promoPercent}%' : ''} ${(promoFnb?.promoIdr??0) > 0? Formatter().formatRupiah((promoFnb?.promoIdr??0).toInt()) : ''}', style: CustomTextStyle.blackStandard(), minFontSize: 7, maxLines: 1,))
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
                              onTap: (){
                                setState(() {
                                  promoFnb = null;
                                });
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
                  Text('UANG MUKA', style: CustomTextStyle.blackMedium(),),
                  CustomRadioButton(
                    defaultSelected: dpCode,
                    selectedBorderColor: Colors.transparent,
                    unSelectedBorderColor: CustomColorStyle.appBarBackground(),
                    enableShape: true,
                    horizontal: false,
                    padding: 0,
                    elevation: 0, // Menghilangkan bayangan
                    buttonLables: downPaymentList, 
                    buttonValues: downPaymentCode,
                    buttonTextStyle: ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.black,
                      textStyle: CustomTextStyle.blackStandard()
                    ),
                    autoWidth: true,                        
                    radioButtonValue: (value){
                      setState(() {
                        dpCode = value;
                      });
                    }, 
                    unSelectedColor: Colors.white, 
                    selectedColor: CustomColorStyle.appBarBackground()
                  ),
                  dpCode == 2?
                  TextField(
                    controller: _cashDpController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [RupiahInputFormatter()],
                    decoration: CustomTextfieldStyle.normalHint('Nominal')
                  ):const SizedBox(),
                  
                  dpCode == 3 || dpCode == 4?
                  Column(
                    children: [
                      TextField(
                        controller: _cashDpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [RupiahInputFormatter()],
                        decoration: CustomTextfieldStyle.normalHint('Nominal')
                      ),
                      const SizedBox(height: 6,),  
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: ()async{
                              final chooseEdcName = await RadioListDialog().show(context, 'Pilih EDC', 1, edcType, edcTypeCode);
                              setState(() {
                                chooseEdc = chooseEdcName.toString();
                              });
                            },
                            style: CustomButtonStyle.blueAppbar(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Pilih  EDC ', style: CustomTextStyle.whiteStandard(),),
                            )),
                            const SizedBox(width: 12,),
                            Text(chooseEdc, style: CustomTextStyle.blackStandard(),)
                        ],
                      ),
                      const SizedBox(height: 6,),  
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: ()async{
                              final chooseCardResult = await RadioListDialog().show(context, 'Pilih Kartu', 1, cardType, cardTypeCode);
                              setState(() {
                                chooseCardType = chooseCardResult.toString();
                              });
                            },
                            style: CustomButtonStyle.blueAppbar(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Pilih Kartu', style: CustomTextStyle.whiteStandard(),),
                            )),
                            const SizedBox(width: 12,),
                            Text(chooseCardType, style: CustomTextStyle.blackStandard(),)
                        ],
                      ),
                                          TextField(
                        controller: _cashDpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [RupiahInputFormatter()],
                        decoration: CustomTextfieldStyle.normalHint('Nama')
                      ),
                      const SizedBox(height: 6,),  
                      TextField(
                        controller: _cashDpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [RupiahInputFormatter()],
                        decoration: CustomTextfieldStyle.normalHint('Nomor Kartu')
                      ),
                      const SizedBox(height: 6,),
                      TextField(
                        controller: _cashDpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [RupiahInputFormatter()],
                        decoration: CustomTextfieldStyle.normalHint('Kode Approval')
                      )   
                    ],
                  ):const SizedBox(),
                  dpCode == 5?
                  Column(
                    children: [
                      TextField(
                        controller: _cashDpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [RupiahInputFormatter()],
                        decoration: CustomTextfieldStyle.normalHint('Nominal')
                      ),
                      const SizedBox(height: 6,),  
                      TextField(
                        controller: _cashDpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [RupiahInputFormatter()],
                        decoration: CustomTextfieldStyle.normalHint('Nama Penyetor')
                      ),
                      const SizedBox(height: 6,),
                      TextField(
                        controller: _cashDpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [RupiahInputFormatter()],
                        decoration: CustomTextfieldStyle.normalHint('Bank')
                      )  
                    ],
                  ):const SizedBox(),
                  const SizedBox(height: 12,),
                  Align(alignment: Alignment.centerLeft ,child: Text('Keterangan', style: CustomTextStyle.blackMedium(),)),
                  TextField(decoration: CustomTextfieldStyle.normalHint('Keterangan'), controller: descriptionController,),
                  const SizedBox(height: 12,),
                  Align(alignment: Alignment.centerLeft ,child: Text('Acara', style: CustomTextStyle.blackMedium(),)),
                  TextField(decoration: CustomTextfieldStyle.normalHint('Acara'), controller: eventController,),
                  const SizedBox(height: 12,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ()async{
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
                          dp: '',
                          description: descriptionController.text,
                          event: eventController.text,
                          chusr: 'ILHAM',
                          voucher: '',
                          dpNote: '',
                          cardType: '',
                          cardName: '',
                          cardNo: '',
                          cardApproval: '',
                          edcMachine: '',
                          memberCode: dataCheckin!.memberCode,
                          promo: listPromo,
                        );

                        final editResponse = await ApiRequest().editCheckin(params);
                        if(editResponse.state == true){
                          if(context.mounted){
                            Navigator.pushNamedAndRemoveUntil(context, OperationalPage.nameRoute, (route) => false);
                          }
                        }else{
                          showToastError(editResponse.message??'Error Edit data checkin');
                          setState(() {
                            isLoading = false;
                          });
                        }

                      },
                      style: CustomButtonStyle.confirm(),
                      child: Text('SIMPAN', style: CustomTextStyle.whiteStandard(),),
                      ),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
  }
}