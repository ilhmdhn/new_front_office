import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';

class DoneOrderPage extends StatefulWidget {
  final DetailCheckinModel detailCheckin;
  const DoneOrderPage({super.key, required this.detailCheckin});

  @override
  State<DoneOrderPage> createState() => _DoneOrderPageState();
}

class _DoneOrderPageState extends State<DoneOrderPage> {

  OrderResponse? apiResult;
  bool isLoading = true;
  List<OrderedModel> listOrder = List.empty(growable: true);

  void getData()async{
    setState(() {
      isLoading = true;
    });
    apiResult = await ApiRequest().getOrder(widget.detailCheckin.roomCode);

    if(isNotNullOrEmpty(apiResult?.data)){

      listOrder = apiResult!.data!.where((element) => element.orderState == '5' &&  (element.qty??0) - (element.cancelQty??0) >0).toList();

      apiResult?.data?.sort((a, b) {
        int solComparison = a.sol!.compareTo(b.sol!);
        if (solComparison != 0) {
          return solComparison;
        }
        return a.name!.compareTo(b.name!);
      });
    }

    setState(() {
      isLoading = false;
      apiResult;
    });
  }

  @override
  void didChangeDependencies() {
    getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body: 
        apiResult == null ?
          AddOnWidget.loading():
        apiResult?.state != true?
          AddOnWidget.error(apiResult?.message):
        isNullOrEmpty(listOrder)?
          AddOnWidget.empty():
        Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: listOrder.length,
            shrinkWrap: true,
            itemBuilder: (ctxList, index){
              final order = listOrder[index];
              num price = (order.price??0) * ((order.qty??0) - (order.cancelQty??0));
              int qty = (order.qty??0) - (order.cancelQty??0);
              return Column(
                children: [
                  Container(
                    decoration: CustomContainerStyle.whiteList(),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: AutoSizeText(order.sol??'sol null', style: CustomTextStyle .blackStandard(), maxLines: 1, minFontSize: 9,)
                            ),
                            Flexible(
                              flex: 1,
                              child: AutoSizeText(Formatter.formatRupiah(price), style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
                            ),
                          ],
                        ),
                        const SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AutoSizeText('${qty}x ${order.name} ', style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
                            ),
                            InkWell(
                              onTap: ()async{
                                String userLevel = PreferencesData.getUser().level??'';
                                if(userLevel != 'KASIR'){
                                  showToastWarning('Hanya user kasir');
                                  return;
                                }
                                final cancelQty = await ConfirmationDialog.confirmationCancelDo(context, order.name.toString(), qty, widget.detailCheckin);
                                if(cancelQty > 0){
                                  setState(() {
                                    isLoading = true;
                                });
                                final cancelState = await ApiRequest().cancelDo(widget.detailCheckin.roomCode, order, cancelQty);
                                if(cancelState.state !=true){
                                  setState(() {
                                    isLoading = false;
                                  });
                                }else{
                                  getData();
                                }
                                }
                              },
                              child: Container(
                                decoration: CustomContainerStyle.cancelButton(),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                                child: Text('CANCEL', style: CustomTextStyle.whiteSize(16),),
                              ),
                            )
                          ],
                        ),
                      isNotNullOrEmpty(order.notes)?
                      Row(
                        children: [
                          AutoSizeText('note: ${order.notes??''}', style: CustomTextStyle.blackStandard(), maxLines: 3,),
                        ],
                      ): const SizedBox()
                      ],
                    ),
                  ),
                  const SizedBox(height: 6,)
                ],
              );
            }),
        ),
    );
  }
}