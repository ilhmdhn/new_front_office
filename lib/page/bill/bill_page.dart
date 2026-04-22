import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/enum/pos_type.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/model/bill_resto_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/bill/payment_page.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/dialog/verification_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/calculate.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/printer/print_executor.dart';
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
  final user = GlobalProviders.read(userProvider);
  final pos = GlobalProviders.read(posTypeProvider);
  PreviewBillResponse result = PreviewBillResponse(state: false, message: 'loading');
  BillRestoResponse? resultResto;
  

  void getData()async{
    if(pos == PosType.oldPos || pos == PosType.posWebBased){
      result = await ApiRequest().previewBill(roomCode);
    }else{
      resultResto = await ApiRequest().getBillResto(roomCode);
    }
    setState(() {
      result;
      resultResto;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    if(isLoading){
      getData();
    }

    if(pos == PosType.restoOnlyOld || pos ==PosType.restoOnlyWebBased){
      return _restoLayout(context, resultResto);
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

    return Scaffold(
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
        SafeArea(
          left: false,
          right: false,
          top: false,
          bottom: true,
          child: Container(
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
                      pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased?
                      SizedBox.shrink():
                      Column(
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
                          /*(result.data?.voucherValue?.roomPrice??0)>0?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText('Voucher Room', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                              AutoSizeText('(${Formatter.formatRupiah((result.data?.voucherValue?.roomPrice ?? 0))})', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                            ],
                          )
                          : const SizedBox(),*/
                          const SizedBox(height: 6,),
                        ],
                      ),
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
                                        AutoSizeText(order.namaItem, style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 2),
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
                      ): const SizedBox(),
                    ],
                  ),
                ),
                Column(
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased?
                        'Total Penjualan': 'Ruangan + FnB', 
                        style: CustomTextStyle.blackMedium(), 
                        minFontSize: 14, 
                        maxLines: 1
                      ),
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
                  isNotNullOrEmpty(result.data?.transferList)?
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Transfer List', style: CustomTextStyle.blackMedium())),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: result.data?.transferList.length,
                          itemBuilder: (ctxList, index){
                            String roomName = result.data?.transferList[index].room??'room name';
                            num value  = result.data?.transferList[index].transferTotal??0;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(roomName, style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                                AutoSizeText(Formatter.formatRupiah(value), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                              ],
                            ); 
                          }
                        ),
                      ],
                    ),
                  ):
                  const SizedBox(),
                  (result.data?.voucherValue?.totalPrice ?? 0) > 0? 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText('Voucher', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                      AutoSizeText(Formatter.formatRupiah((result.data?.voucherValue?.totalPrice ?? 0)), style: CustomTextStyle.discountOrder(), minFontSize: 14, maxLines: 1),
                    ],
                  ): const SizedBox(),
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
                      ElevatedButton(
                        onPressed: ()async{
                          final isSpecialOutlet = pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased;
                          final allowedRoles = ['KASIR', 'ACCOUNTING', 'SUPERVISOR', 'KAPTEN'];
                            if (!isSpecialOutlet && !allowedRoles.contains(user.level)) {
                              showToastWarning('${user.level} Tidak memiliki akses');
                              return;
                            }else{
                            if(result.data?.dataInvoice.statusPrint != '0'){
                              final reprintBillState = await VerificationDialog.requestVerification(context, (result.data?.dataInvoice.reception??''), (result.data?.dataRoom.ruangan??''), 'Cetak Ulang Tagihan');
                              if(reprintBillState.state!= true){
                                showToastWarning('Permintaan dibatalkan');
                                return;
                              }
                              if(isSpecialOutlet){
                                // PrintExecutor.printBillResto(roomCode);
                              }else{
                                PrintExecutor.printBill(roomCode);
                              }
                            }else{
                              final confirmationState = await ConfirmationDialog.confirmation(context, 'Cetak Tagihan');
                              if(confirmationState == true){
                                if(isSpecialOutlet){
                                  // PrintExecutor.printBillResto(roomCode);
                                }else{
                                  PrintExecutor.printBill(roomCode);
                                }
                              }
                            }
                          }
                        },
                        style: CustomButtonStyle.bluePrimary(),
                        child: const Icon(Icons.print, color: Colors.white, size: 32,),
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            if(user.level != 'KASIR' && user.level != 'ACCOUNTING' && user.level != 'KAPTEN' && user.level != 'IT' && user.level != 'SUPERVISOR'){
                              showToastWarning('User tidak memiliki akses');
                              return;
                            }
                            Navigator.pushNamed(context, PaymentPage.nameRoute, arguments: roomCode);
                          },
                          style: CustomButtonStyle.confirm(),
                          child: Center(child: Text('PEMBAYARAN', style: CustomTextStyle.whiteSize(16),)),
                          ),
                        ),
                    ],
                  ),
                  ],
                )
              ],
            ),
          ),
        )
      ,
    );
  }
}

  Widget _restoLayout(BuildContext ctx, BillRestoResponse? data){
    final List<OrderRestoModel> order = data?.data?.order??[];
    final roomInfo = data?.data;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color:  Colors.white, //change your color here
        ),
        title: Text(roomInfo?.rcp.room??'', style: CustomTextStyle.titleAppBar(),),
        backgroundColor: CustomColorStyle.appBarBackground(),
      ),
      backgroundColor: Colors.white,
      body: data == null?
        Center(child: CircularProgressIndicator(backgroundColor: CustomColorStyle.appBarBackground(),),):
        data.state != true?
        Center(
          child: Text(data.message),):
        SafeArea(
          left: false,
          right: false,
          top: false,
          bottom: true,
          child: Container(
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
                      order.isNotEmpty?
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText('Rincian Penjualan', style: CustomTextStyle.blackMediumSize(19), minFontSize: 14, maxLines: 1),
                                // AutoSizeText('OP: ${data.data!.rcp.user}', style: CustomTextStyle.blackMediumSize(19), minFontSize: 14, maxLines: 1),
                              ],
                            ),
                            const SizedBox(height: 6,),
                            Flexible(
                              child: ListView.builder(
                                itemCount: order.length,
                                shrinkWrap: false,
                                itemBuilder: (ctx, index){                              
                                  final item = order[index];
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        AutoSizeText(item.name, style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 2),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText('${item.qty} x ${Formatter.formatRupiah(item.price)}', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                                          AutoSizeText(Formatter.formatRupiah(item.qty * item.price), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                                        ],
                                      ),
                                      (item.promo??0) > 0?
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(item.promoName??'', style: CustomTextStyle.discountOrder(), minFontSize: 14, maxLines: 1),
                                          AutoSizeText('(${Formatter.formatRupiah(item.promo!)})', style: CustomTextStyle.discountOrder(), minFontSize: 14, maxLines: 1),
                                        ],
                                      ):const SizedBox.shrink(),
                                      const SizedBox(height: 6,)
                                    ],
                                  );
                                }),
                            )
                          ],
                        ),
                      ): const SizedBox(),
                    ],
                  ),
                ),
                Column(
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Total Penjualan', 
                        style: CustomTextStyle.blackMedium(), 
                        minFontSize: 14, 
                        maxLines: 1
                      ),
                      AutoSizeText(Formatter.formatRupiah(Calculate.calculateFnbTotalResto(roomInfo?.order??[])), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText('Service ${roomInfo?.invoice.servicePercent}%', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                      AutoSizeText(Formatter.formatRupiah(roomInfo?.invoice.service??0), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText('Pajak ${roomInfo?.invoice.taxPercent}%', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                      AutoSizeText(Formatter.formatRupiah(roomInfo?.invoice.tax??0), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText('Total', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                      AutoSizeText(Formatter.formatRupiah(data.data!.invoice.total), style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: ()async{
                            if(roomInfo?.invoice.statusPrint != '0'){
                              final reprintBillState = await VerificationDialog.requestVerification(ctx, (roomInfo?.rcp.reception??''), (roomInfo?.rcp.room??''), 'Cetak Ulang Tagihan');
                              if(reprintBillState.state!= true){
                                showToastWarning('Permintaan dibatalkan');
                                return;
                              }
                              Future.microtask(() async {          
                                PrintExecutor.printBillResto(roomInfo?.rcp.room??'', roomInfo?.rcp.reception??'');
                              });
                            }else{
                              final confirmationState = await ConfirmationDialog.confirmation(ctx, 'Cetak Tagihan');
                              if(confirmationState == true){
                                Future.microtask(() async {          
                                  PrintExecutor.printBillResto(roomInfo?.rcp.room??'', roomInfo?.rcp.reception??'');
                                });
                              }
                            }
                        },
                        style: CustomButtonStyle.bluePrimary(),
                        child: const Icon(Icons.print, color: Colors.white, size: 32,),
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            if(isNullOrEmpty(roomInfo?.rcp.room??'')){
                              showToastError('Room tidak diketahui');
                              return;
                            }
                            final user = GlobalProviders.read(userProvider);
                            if(user.level != 'KASIR' && user.level != 'ACCOUNTING' && user.level != 'KAPTEN' && user.level != 'IT' && user.level != 'SUPERVISOR'){
                              showToastWarning('User tidak memiliki akses');
                              return;
                            }

                            Navigator.pushNamed(ctx, PaymentPage.nameRoute, arguments: roomInfo?.rcp.room??'');
                          },
                          style: CustomButtonStyle.confirm(),
                          child: Center(child: Text('PEMBAYARAN', style: CustomTextStyle.whiteSize(16),)),
                          ),
                        ),
                    ],
                  ),
                  ],
                )
              ],
            ),
          ),
        )
      ,
    );
}