import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/model/payment_params.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/dialog/payment_list_dialog.dart';
import 'package:front_office_2/page/dialog/card_payment_dialog.dart';
import 'package:front_office_2/page/dialog/rating_dialog.dart';
import 'package:front_office_2/page/dialog/verification_dialog.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/execute_printer.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
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
  bool sendEmail = true;

  final TextEditingController _nominalController = TextEditingController();
  
  final TextEditingController _nameCreditCardController = TextEditingController();
  final TextEditingController _numberCreditCardController = TextEditingController();
  final TextEditingController _approvalCreditCardController = TextEditingController();

  final TextEditingController _nameDebetCardController = TextEditingController();
  final TextEditingController _numberDebetCardController = TextEditingController();
  final TextEditingController _approvalDebetCardController = TextEditingController();

  final TextEditingController _nameEmoneyCardController = TextEditingController();
  final TextEditingController _numberEmoneyCardController = TextEditingController();
  final TextEditingController _referalEmoneyCardController = TextEditingController();

  final TextEditingController _nameComplimentaryCardController = TextEditingController();
  final TextEditingController _agencyComplimentaryCardController = TextEditingController();
  final TextEditingController _responsibleComplimentaryCardController = TextEditingController();

  final TextEditingController _nameReceivablesCardController = TextEditingController();
  final TextEditingController _memberReceivablesCardController = TextEditingController();

  List<PaymentDetail> paymentList = List.empty(growable: true);
  num totalBill = 0;
  num minusPay = 0;

  PreviewBillResponse? billData;

  void _setNominal(){
    minusPay = totalBill;
    for (var element in paymentList) {
      minusPay -= element.nominal;
    }
    _nominalController.text = Formatter.formatRupiah(minusPay);
  }

  void getData()async{
    billData = await ApiRequest().previewBill(roomCode);
    if(billData?.state == true){
      totalBill = billData?.data?.dataInvoice.jumlahBersih??0;
      _setNominal();
    }
    _nameReceivablesCardController.text = (billData?.data?.dataInvoice.memberName??'');
    _memberReceivablesCardController.text = (billData?.data?.dataInvoice.memberCode??'');
    setState(() {
      billData;  
    });
  }

  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    if(billData == null){
      getData();
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color:  Colors.white,
          ),
          title: Text(roomCode, style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: 
        
        billData == null?
        Center(
          child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground(),),
        ):

        billData?.state != true?
        Center(
          child: AutoSizeText(billData?.message??'Errpr get data bill'),
        ):
        
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 6,),
                  Center(child: Text('Total ${Formatter.formatRupiah(totalBill)}', style: CustomTextStyle.blackMediumSize(19))),
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
                      controller: _nominalController,
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
                          controller: _nameCreditCardController,
                        ),
                        const SizedBox(height: 6,),
                        TextField(
                          decoration: CustomTextfieldStyle.normalHint('Nomor'),
                          keyboardType: TextInputType.number,
                          controller: _numberCreditCardController,
                        
                        ),
                        const SizedBox(height: 6,),
                        TextField(
                          decoration: CustomTextfieldStyle.normalHint('Kode Approval'),
                          controller: _approvalCreditCardController,
                          keyboardType: TextInputType.number
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
                          controller: _nameDebetCardController,
                        ),
                        const SizedBox(height: 6,),
                        TextField(
                          decoration: CustomTextfieldStyle.normalHint('Nomor'),
                          keyboardType: TextInputType.number,
                          controller: _numberDebetCardController,
                        ),
                        const SizedBox(height: 6,),
                        TextField(
                          decoration: CustomTextfieldStyle.normalHint('Kode Approval'),
                          controller: _approvalDebetCardController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ):
                  paymentMethod == 'E-MONEY'?
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
                          controller: _nameEmoneyCardController,
                        ),
                        const SizedBox(height: 6,),
                        TextField(
                          decoration: CustomTextfieldStyle.normalHint('Nomor'),
                          keyboardType: TextInputType.number,
                          controller: _numberEmoneyCardController,
                        ),
                        const SizedBox(height: 6,),
                        TextField(
                          decoration: CustomTextfieldStyle.normalHint('Kode Referal'),
                          controller: _referalEmoneyCardController,
                          keyboardType: TextInputType.number,
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
                          controller: _nameComplimentaryCardController,
                        ),
                        const SizedBox(height: 6,),
                        TextField(
                          decoration: CustomTextfieldStyle.normalHint('Instansi'),
                          controller: _agencyComplimentaryCardController,
                        ),
                        const SizedBox(height: 6,),
                        TextField(
                          decoration: CustomTextfieldStyle.normalHint('Penanggung Jawab'),
                          controller: _responsibleComplimentaryCardController,
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
                          controller: _nameReceivablesCardController,
                        ),
                        const SizedBox(height: 6,),
                        TextField(
                          decoration: CustomTextfieldStyle.normalHint('ID Member'),
                          controller: _memberReceivablesCardController,
                          keyboardType: TextInputType.number
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 6,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: ()async{
                        if(isNullOrEmpty(_nominalController.text)){
                          return showToastError('Isi nominal');
                        }
                        final value = int.parse(_nominalController.text.replaceAll(RegExp(r'[^\d]'), ''));
                        final isAdded = paymentList.where((element) => element.paymentType == paymentMethod).toList();
                        if(isAdded.isNotEmpty){
                          return showToastWarning('Metode pembayaran sudah ditambahkan');
                        }
                        switch(paymentMethod){

                          case 'CASH': {
                            paymentList.add(
                              PaymentDetail(
                                nominal: value,
                                paymentType: 'CASH'
                              )
                            );
                          }
                          break;
                          
                          case 'CREDIT CARD':{

                            final approvalCode = _approvalCreditCardController.text;
                            final cardCode = _numberCreditCardController.text;
                            final cardName = _nameCreditCardController.text;

                            if(isNullOrEmpty(approvalCode) || isNullOrEmpty(cardCode) || isNullOrEmpty(cardName) || isNullOrEmpty(cardChoosed) || isNullOrEmpty(edcChoosed)){
                              return showToastError('Lengkapi data');
                            }

                            paymentList.add(
                              PaymentDetail(
                                nominal: value,
                                approvalCodeCredit: approvalCode,
                                cardCodeCredit: cardCode,
                                cardCredit: cardChoosed,
                                edcCredit: edcChoosed,
                                namaUserCredit: cardName,
                                paymentType: 'CREDIT CARD'
                              )
                            );
                          }
                          break;
                          
                          case 'DEBET CARD':{
                            final approvalCode = _approvalDebetCardController.text;
                            final cardCode = _numberDebetCardController.text;
                            final cardName = _nameDebetCardController.text;

                            if(isNullOrEmpty(approvalCode) || isNullOrEmpty(cardCode) || isNullOrEmpty(cardName) || isNullOrEmpty(cardChoosed) || isNullOrEmpty(edcChoosed)){
                              return showToastError('Lengkapi data');
                            }

                            paymentList.add(
                              PaymentDetail(
                                approvalCodeDebet: _approvalDebetCardController.text,
                                cardCodeDebet: _numberDebetCardController.text,
                                cardDebet: cardChoosed,
                                edcDebet: edcChoosed,
                                namaUserDebet: _nameDebetCardController.text,
                                nominal: value,
                                paymentType: 'DEBET CARD'
                              )
                            );
                          }
                          break;
                          
                          case 'E-MONEY':{
                            final accountCode = _numberEmoneyCardController.text;
                            final accountName = _nameEmoneyCardController.text;
                            final referalCode = _referalEmoneyCardController.text;

                            if(isNullOrEmpty(accountCode) || isNullOrEmpty(accountName) || isNullOrEmpty(referalCode)){
                              // showToastWarning('KURANGGG');
                              return showToastError('Lengkapi data');
                            }
                              
                            paymentList.add(
                              PaymentDetail(
                                accountEmoney: accountCode,
                                namaUserEmoney: accountName,
                                nominal: value,
                                paymentType: 'E-MONEY',
                                refCodeEmoney: referalCode,
                                typeEmoney: eMoneyChoosed
                              )
                            );
                          }
                          break;

                          case 'COMPLIMENTARY':{
                            final agencyName = _agencyComplimentaryCardController.text;
                            final responsibleName = _responsibleComplimentaryCardController.text;
                            final nameComplimentary = _nameComplimentaryCardController.text;

                            if(isNullOrEmpty(agencyName) || isNullOrEmpty(responsibleName) || isNullOrEmpty(nameComplimentary)){
                              return showToastError('Lengkapi data');
                            }

                            final approvalState = await VerificationDialog.requestVerification(context, billData?.data?.dataInvoice.reception??'', billData?.data?.dataRoom.roomCode??'', 'Meminta persetujuan pembayaran COMPLIMENTARY sebesar $value');
                              
                            if(approvalState != true){
                              return showToastWarning('Permintaan complimentary ditolak');
                            }

                            paymentList.add(
                              PaymentDetail(
                                instansiCompliment: agencyName,
                                instruksiCompliment: responsibleName,
                                namaUserCompliment: nameComplimentary,
                                nominal: value,
                                paymentType: 'COMPLIMENTARY'
                              )
                            );
                          }
                          break;
                          
                          case 'PIUTANG':{
                            final name = _nameReceivablesCardController.text;
                            final memberCode = _memberReceivablesCardController.text;

                            if(isNullOrEmpty(name) || isNullOrEmpty(memberCode)){
                              return showToastError('Lengkapi data');
                            }

                            final approvalState = await VerificationDialog.requestVerification(context, 'RCP', 'ROOMNYA', 'Meminta persetujuan pembayaran PIUTANG sebesar $value');
                              
                            if(approvalState != true){
                              return showToastWarning('Permintaan piutang ditolak');
                            }

                            paymentList.add(
                              PaymentDetail(
                                idMemberPiutang: memberCode,
                                namaUserPiutang: name,
                                nominal: value,
                                paymentType: 'PIUTANG',
                                typePiutang: piutangChoosed
                              )
                            );
                          }
                        }

                        setState(() {
                          paymentList;
                          _setNominal();
                        });
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
                  ),
                ],
              ),
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: paymentList.length,
                    itemBuilder: (BuildContext ctxList, index){
                      final payment = paymentList[index];
                      return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    paymentList.removeAt(index);
                                    _setNominal();
                                  });
                                },
                                child: const Icon(Icons.remove_circle, color: Colors.redAccent,),
                              ),
                              const SizedBox(width: 6,),
                              AutoSizeText(payment.paymentType, style: CustomTextStyle.blackStandard(),),
                              const SizedBox(height: 6,)
                            ],
                          ),
                          AutoSizeText(Formatter.formatRupiah(payment.nominal), style: CustomTextStyle.blackStandard())
                        ],
                      );
                    }
                  ),

                  minusPay < 0?
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText('KEMBALI', style: CustomTextStyle.blackSemi(),),
                          AutoSizeText(Formatter.formatRupiah(minusPay).replaceAll('-', ''), style: CustomTextStyle.blackSemi())
                        ],
                  ):Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText('KURANG', style: CustomTextStyle.blackSemi(),),
                          AutoSizeText(Formatter.formatRupiah(minusPay), style: CustomTextStyle.blackSemi())
                        ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: CustomColorStyle.appBarBackground(),
                        value: sendEmail,
                        onChanged: (value){
                          setState((){
                            sendEmail = !sendEmail;
                          });
                      }),
                      AutoSizeText('Email Invoice', style: CustomTextStyle.blackStandard(), minFontSize: 9, maxFontSize: 16,),
                      const Expanded(child: SizedBox()),
                      InkWell(
                        onTap: ()async{
                          if(minusPay > 0 ){
                            showToastWarning('Pembayaran Kurang');
                            return;
                          }
                          
                          final confirmationState = await ConfirmationDialog.confirmation(context, 'Bayar Room $roomCode');
                          if(confirmationState != true){
                            return;
                          }

                          final anu = GeneratePaymentParams.generatePaymentParams(sendEmail, roomCode, paymentList);
                          final paymentResult = await ApiRequest().pay(anu);

                          if(paymentResult.state != true){
                            showToastError(paymentResult.message.toString());
                            return;
                          }

                          DoPrint.printInvoice(billData?.data?.dataInvoice.reception??'');

                          if(context.mounted){
                            final invoiceCode = billData?.data?.dataInvoice.invoice??'';
                            final memberCode = billData?.data?.dataInvoice.memberCode??'';
                            final memberName = billData?.data?.dataInvoice.memberName??'';
                            
                            Navigator.pushNamedAndRemoveUntil(context, MainPage.nameRoute, (route) => false);
                            RatingDialog.submitRate(context, invoiceCode, memberCode, memberName);
                          }
                        },
                        child: Container(
                          decoration: CustomContainerStyle.confirmButton(),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 21),
                          child: Row(
                            children: [
                              Center(child: Text('BAYAR', style: CustomTextStyle.whiteSize(16),)),
                              const SizedBox(width: 12,),
                              const Icon(Icons.payments, color: Colors.white,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ));
  }
}