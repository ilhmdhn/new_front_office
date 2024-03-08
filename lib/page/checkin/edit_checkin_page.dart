import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/dialog/radio_list_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
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

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData()async{
    dataEdc = await ApiRequest().getEdc();
    if(dataEdc?.state != true){
      showToastError(dataEdc?.message??'Unknown error get edc list');
    }
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Room Checkin', style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: isLoading == true?
        const Center(
          child: CircularProgressIndicator(),
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
                            Text('ILHAM DOHAAN', style: CustomTextStyle.blackMedium(),),
                            Text('000022061122', style: CustomTextStyle.blackMedium(),),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 39,color: CustomColorStyle.bluePrimary(),),
                      Expanded(
                        child: Column(
                          children: [
                            Text('PR A Xiantiande', style: CustomTextStyle.blackMedium(),),
                            Text('Sisa 9 Jam 54 Menit', style: CustomTextStyle.blackMedium(),),
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
                    IconButton(onPressed: (){}, icon: const Icon(Icons.delete))
                    ],
                  ),
                                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Promo Room', style: CustomTextStyle.blackMedium(),)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            style: CustomButtonStyle.blueAppbar(),
                            onPressed: ()async{
                              RadioListDialog().show(context, 'Pilih EDC', 1, edcType, edcTypeCode);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                              child: Text('Pilih', style: CustomTextStyle.whiteStandard(),),
                            ),),
                                            const SizedBox(width: 6,), 
                                            voucherCode!=null?AutoSizeText(voucherCode.toString(), style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 12,): const SizedBox(),
                        ],
                      ),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.delete))
                    ],
                  ),
                                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Promo FnB', style: CustomTextStyle.blackMedium(),)),
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
                    IconButton(onPressed: (){}, icon: const Icon(Icons.delete))
                    ],
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
                  TextField(decoration: CustomTextfieldStyle.normalHint('Keterangan'),),
                  const SizedBox(height: 12,),
                  Align(alignment: Alignment.centerLeft ,child: Text('Acara', style: CustomTextStyle.blackMedium(),)),
                  TextField(decoration: CustomTextfieldStyle.normalHint('Acara'),),
                    
                    
                ],
              ),
            ),
          ),
        ),
      ));
  }
}