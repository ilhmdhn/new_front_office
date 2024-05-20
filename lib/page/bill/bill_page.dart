import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/bill/payment_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';

class BillPage extends StatefulWidget {
  static const nameRoute = '/bill';
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  String roomCode = '';
  bool isLoading = true;

  PreviewBillResponse result = PreviewBillResponse(state: false, message: 'loading');

  void getData()async{
    result = await ApiRequest().previewBill(roomCode);
    setState(() {
      result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    if(isLoading){
      getData();
    }
    num roomPrice = result.data?.dataInvoice.sewaRuangan??0;
    num promoRoom = result.data?.dataInvoice.promo??0;
    List<OrderModel> orderList = result.data?.dataOrder??[];
    List<CancelOrderModel> cancelOrderList = result.data?.dataCancelOrder??[];
    List<PromoOrderModel> promoOrderList = result.data?.dataPromoOrder??[];
    List<PromoCancelOrderModel> promoCancelOrderList = result.data?.dataPromoCancelOrder??[];
    num roomTotal = result.data?.dataInvoice.jumlahRuangan??0;
    num fnbTotal = result.data?.dataInvoice.jumlahPenjualan??0;
    num serviceRoom = result.data?.dataInvoice.roomService??0;
    num taxRoom = result.data?.dataInvoice.roomTax??0;
    num serviceFnb = result.data?.dataInvoice.fnbService??0;
    num taxFnb = result.data?.dataInvoice.fnbTax??0;
    num totalAll = result.data?.dataInvoice.jumlahBersih??0;


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color:  Colors.white, //change your color here
          ),
          title: Text(roomCode, style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        backgroundColor: Colors.white,
        body: isLoading == true?
          Center(child: CircularProgressIndicator(backgroundColor: CustomColorStyle.appBarBackground(),),):
        result.state != true?
          Center(
            child: Text(result.message),):
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText('Sewa Ruangan', style: CustomTextStyle.blackMediumSize(19), minFontSize: 14, maxLines: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText('${result.data!.dataRoom.checkin} - ${result.data!.dataRoom.checkout}', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                          AutoSizeText(Formatter.formatRupiah(roomPrice), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                        ],
                      ),
                      promoRoom>0?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText('Promo Room', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                          AutoSizeText('(${Formatter.formatRupiah(promoRoom)})', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                        ],
                      ):const SizedBox(),
                      const SizedBox(height: 6,),
                      orderList.isNotEmpty?
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AutoSizeText('Rincian Penjualan', style: CustomTextStyle.blackMediumSize(19), minFontSize: 14, maxLines: 1),
                            const SizedBox(height: 6,),
                            Flexible(
                              child: ListView.builder(
                                itemCount: orderList.length,
                                shrinkWrap: true,
                                itemBuilder: (ctx, index){
                                  final order = orderList[index];
                                  final cancelOrder = cancelOrderList.where((element) => element.orderCode == order.orderCode && element.inventoryCode == order.inventoryCode).toList();
                                  final promoOrder = promoOrderList.where((element) => element.orderCode == order.orderCode  && element.inventoryCode == order.inventoryCode).toList();
                                  final promoCancelOrder = promoCancelOrderList.where((element) => element.orderCode == order.orderCode  && element.inventoryCode == order.inventoryCode).toList();
                              
                                  num pricePromo = 0;
                                  if(promoOrder.isNotEmpty){
                                    pricePromo = promoOrder[0].promoPrice;
                                  }
                              
                                  if(promoCancelOrder.isNotEmpty){
                                    pricePromo = promoOrder[0].promoPrice - promoCancelOrder[0].promoPrice;
                                  }
                                                  
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        AutoSizeText(order.namaItem, style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText('${order.jumlah} x ${order.harga}', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                                          AutoSizeText(Formatter.formatRupiah(order.total), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                                        ],
                                      ),
                                      cancelOrder.isNotEmpty?
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText('RETUR ${cancelOrder[0].namaItem}', style: CustomTextStyle.cancelOrder(), minFontSize: 14, maxLines: 1),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              AutoSizeText('${cancelOrder[0].jumlah} x ${cancelOrder[0].harga}', style: CustomTextStyle.cancelOrder(), minFontSize: 14, maxLines: 1),
                                              AutoSizeText('(${Formatter.formatRupiah(cancelOrder[0].total)})', style: CustomTextStyle.cancelOrder(), minFontSize: 14, maxLines: 1),
                                            ],
                                          ),
                                        ],
                                      ):const SizedBox(),
                                      promoOrder.isNotEmpty?
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(promoOrder[0].promoName, style: CustomTextStyle.discountOrder(), minFontSize: 14, maxLines: 1),
                                          AutoSizeText('(${Formatter.formatRupiah(pricePromo)})', style: CustomTextStyle.discountOrder(), minFontSize: 14, maxLines: 1),
                                        ],
                                      ):const SizedBox(),
                                      const SizedBox(height: 6,)
                                    ],
                                  );
                                }),
                            )
                          ],
                        ),
                      ): const SizedBox()
                    ],
                  ),
                ),
                Column(
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText('Ruangan + FnB', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                      AutoSizeText(Formatter.formatRupiah(roomTotal + fnbTotal), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText('Service', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                      AutoSizeText(Formatter.formatRupiah(serviceFnb + serviceRoom), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText('Pajak', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                      AutoSizeText(Formatter.formatRupiah(taxFnb + taxRoom), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText('Total', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                      AutoSizeText(Formatter.formatRupiah(totalAll), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          final userLevel = PreferencesData.getUser();
                          if(userLevel.level != 'KASIR'){
                            showToastWarning('User tidak memiliki akses');
                            return;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: CustomContainerStyle.blueButton(),
                          child: const Icon(Icons.print, color: Colors.white, size: 32,)),
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            final userLevel = PreferencesData.getUser();
                            if(userLevel.level != 'KASIR'){
                              showToastWarning('User tidak memiliki akses');
                              return;
                            }
                            Navigator.pushNamed(context, PaymentPage.nameRoute, arguments: roomCode);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            decoration: CustomContainerStyle.confirmButton(),
                            child: Center(child: Text('PEMBAYARAN', style: CustomTextStyle.whiteSize(16),)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ],
                )
              ],
            ),
          )
        ,
      ),);
  }
}