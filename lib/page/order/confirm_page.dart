import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';

class ConfirmOrderPage extends StatefulWidget {
  final String roomCode;
  const ConfirmOrderPage({super.key, required this.roomCode});

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {

  OrderResponse? apiResult;
  List<OrderedModel> listOrder = List.empty(growable: true);
  bool isLoading = true;

  void getData()async{

    setState(() {
      isLoading = true;
    });

    apiResult = await ApiRequest().getOrder(widget.roomCode);

    if(isNotNullOrEmpty(apiResult?.data)){

      listOrder = apiResult!.data!.where((element) => element.orderState == '1' && element.location == 1).toList();

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
      
      isLoading?
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
                              child: AutoSizeText(order.sol??'sol null', style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
                            ),
                            Flexible(
                              flex: 1,
                              child: AutoSizeText(Formatter.formatRupiah((order.price??0) * (order.qty??0)), style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
                            ),
                          ],
                        ),
                        const SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AutoSizeText('${order.qty}x ${order.name} ', style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
                            ),
                            InkWell(
                              onTap: ()async{
                                final confirmDo = await ConfirmationDialog.confirmation(context, 'DO ${order.name}?');
                                if(confirmDo != true){
                                  return;
                                }
                                setState(() {
                                    isLoading = true;
                                  });
                                final doState = await ApiRequest().confirmDo(widget.roomCode, order);
                                if(doState.state != true){
                                  showToastError(doState.message??'Gagal DO');
                                  setState(() {
                                    isLoading = false;
                                  });
                                }else{
                                  getData();
                                }
                              },
                              child: Container(
                                decoration: CustomContainerStyle.confirmButton(),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                                child: Text('DO', style: CustomTextStyle.whiteSize(16),),
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
      )
      ,
    );
  }
}