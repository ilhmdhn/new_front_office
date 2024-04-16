import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/payment_params.dart';
import 'package:front_office_2/page/dialog/payment_list_dialog.dart';
import 'package:front_office_2/page/dialog/card_payment_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/list.dart';
import 'package:front_office_2/tools/rupiah.dart';
import 'package:front_office_2/tools/toast.dart';

class PaymentPage extends StatefulWidget {
  static const nameRoute = '/payment';
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String roomCode = '';
  String paymentMethod = 'CASH';
  bool isLoading = true;
  num nominal = 0;
  String eMoneyChoosed = 'DANA';
  String piutangChoosed = 'PEMEGANG SAHAM OUTLET';
  String edcChoosed = '';
  String cardChoosed = '';
  TextEditingController nominalController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController noPaymentController = TextEditingController();
  TextEditingController approvalPaymentController = TextEditingController();
  List<PaymentDetail> paymentList = List.empty();

  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color:  Colors.white,
          ),
          title: Text(roomCode, style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 6,),
              Center(child: Text('TOTAL 1.999.999.999', style: CustomTextStyle.blackMediumSize(19))),
              CustomRadioButton(
                defaultSelected: 'CASH',
                buttonLables: paymentMethodList,
                buttonValues: paymentMethodList,
                autoWidth: true,
                elevation: 0,
                radioButtonValue: (value){
                  setState(() {
                    paymentMethod = value;
                  });
                },
                selectedBorderColor: Colors.transparent,
                unSelectedColor: Colors.white,
                enableShape: true,
                unSelectedBorderColor: CustomColorStyle.appBarBackground(),
                selectedColor: CustomColorStyle.appBarBackground()),
              
              TextField(
                decoration: CustomTextfieldStyle.normalHint('Nominal'),
                  keyboardType: TextInputType.number,
                  controller: nominalController,
                  inputFormatters: [RupiahInputFormatter()]
              ),
              const SizedBox(height: 12,),
          
              paymentMethod == 'CASH'?
              const SizedBox():
              paymentMethod == 'CREDIT CARD'?
              SizedBox(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text('EDC Mesin', style: CustomTextStyle.blackMedium()),
                              const SizedBox(width: 12,),
                              InkWell(
                                onTap: ()async{
                                  final choosed = await CardPaymentDialog().edcMachine(context);
                                  if(choosed != null){
                                    setState(() {
                                      edcChoosed = choosed;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const  EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: CustomContainerStyle.blueButton(),
                                  child: Text(edcChoosed != ''? edcChoosed: 'Pilih', style: CustomTextStyle.whiteStandard(),),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 12,),
                        Expanded(
                          child: Row(
                            children: [
                              Text('Tipe Kartu', style: CustomTextStyle.blackMedium()),
                              const SizedBox(width: 12,),
                              InkWell(
                                onTap: ()async{
                                  final choosed = await CardPaymentDialog().cardType(context);
                                  if(choosed != null){
                                    setState(() {
                                      cardChoosed = choosed;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const  EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: CustomContainerStyle.blueButton(),
                                  child: Text(cardChoosed != ''? cardChoosed: 'Pilih', style: CustomTextStyle.whiteStandard(),),
                                ),
                              )
                            ],
                          ),
                        ),
                    ],),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Nama'),
                      controller: nameController,
                    ),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Nomor'),
                      controller: noPaymentController,
                    ),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Kode Approval'),
                      controller: approvalPaymentController,
                    ),
                  ],
                ),
              ):
              paymentMethod == 'DEBET CARD'?
              SizedBox(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text('EDC Mesin', style: CustomTextStyle.blackMedium()),
                              const SizedBox(width: 12,),
                              InkWell(
                                onTap: ()async{
                                  final choosed = await CardPaymentDialog().edcMachine(context);
                                  if(choosed != null){
                                    setState(() {
                                      edcChoosed = choosed;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const  EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: CustomContainerStyle.blueButton(),
                                  child: Text(edcChoosed != ''? edcChoosed: 'Pilih', style: CustomTextStyle.whiteStandard(),),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 12,),
                        Expanded(
                          child: Row(
                            children: [
                              Text('Tipe Kartu', style: CustomTextStyle.blackMedium()),
                              const SizedBox(width: 12,),
                              InkWell(
                                onTap: ()async{
                                  final choosed = await CardPaymentDialog().cardType(context);
                                  if(choosed != null){
                                    setState(() {
                                      cardChoosed = choosed;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const  EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: CustomContainerStyle.blueButton(),
                                  child: Text(cardChoosed != ''? cardChoosed: 'Pilih', style: CustomTextStyle.whiteStandard(),),
                                ),
                              )
                            ],
                          ),
                        ),
                    ],),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Nama'),
                      controller: nameController,
                    ),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Nomor'),
                      controller: noPaymentController,
                    ),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Kode Approval'),
                      controller: approvalPaymentController,
                    ),
                  ],
                ),
              ):
              paymentMethod == 'E-Money'?
              SizedBox(
                child: Column(
                  children: [
                    InkWell(
                      onTap: ()async{
                        final choosedEmoney = await PaymentListDialog.eMoneyList(context, eMoneyChoosed);
                        if(choosedEmoney != null){
                          setState(() {
                            eMoneyChoosed = choosedEmoney;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: CustomContainerStyle.blueButton(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(eMoneyChoosed, style: CustomTextStyle.whiteStandard()),
                            const Icon(Icons.arrow_drop_down, color: Colors.white,)
                        ],),
                      ),
                    ),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Nama'),
                      controller: nameController,
                    ),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Nomor'),
                      controller: noPaymentController,
                    ),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Kode Referal'),
                      controller: approvalPaymentController,
                    ),
                  ],
                ),
              ):
              paymentMethod == 'COMPLIMENTARY'?
              SizedBox(
                child: Column(
                  children: [
                    Text('Memerlukan Verifikasi', style: CustomTextStyle.blackStandard(),),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Nama'),
                      controller: nameController,
                    ),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Instansi'),
                      controller: noPaymentController,
                    ),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Penanggung Jawab'),
                      controller: approvalPaymentController,
                    ),
                  ],
                ),
              ):
              SizedBox(
                child: Column(
                  children: [
                    Text('Memerlukan Verifikasi', style: CustomTextStyle.blackStandard(),),
                    const SizedBox(height: 6,),
                    InkWell(
                      onTap: ()async{
                        final choosedPiutang = await PaymentListDialog.piutangList(context, piutangChoosed);
                        if(choosedPiutang != null){
                          setState(() {
                            piutangChoosed = choosedPiutang;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: CustomContainerStyle.blueButton(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(piutangChoosed, style: CustomTextStyle.whiteStandard()),
                            const Icon(Icons.arrow_drop_down, color: Colors.white,)
                        ],),
                      ),
                    ),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('Nama'),
                      controller: nameController,
                    ),
                    const SizedBox(height: 6,),
                    TextField(
                      decoration: CustomTextfieldStyle.normalHint('ID Member'),
                      controller: approvalPaymentController,
                    ),
                  ],
                )
              ),
              const SizedBox(height: 6,),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: (){
                    showToastWarning('NGETESSS');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: CustomContainerStyle.blueButton(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_outlined, color: Colors.white,),
                        const SizedBox(width: 6,),
                        Text('Tambahkan', style: CustomTextStyle.whiteStandard(),)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ));
  }
}