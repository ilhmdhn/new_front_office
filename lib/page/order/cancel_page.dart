import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';

class CancelOrderPage extends StatefulWidget {
  final String roomCode;
  const CancelOrderPage({super.key, required this.roomCode});

  @override
  State<CancelOrderPage> createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {

  OrderResponse? apiResult;
  List<OrderedModel> listOrder = List.empty(growable: true);

  void getData()async{
    apiResult = await ApiRequest().getOrder(widget.roomCode);

    if(isNotNullOrEmpty(apiResult?.data)){

      listOrder = apiResult!.data!.where((element) => (element.cancelQty??0) > 0).toList();

      apiResult?.data?.sort((a, b) {
        int solComparison = a.sol!.compareTo(b.sol!);
        if (solComparison != 0) {
          return solComparison;
        }
        return a.name!.compareTo(b.name!);
      });
    }

    setState(() {
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
      apiResult == null?
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
                  decoration: CustomContainerStyle.cancelList(),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: AutoSizeText(order.sol??'sol null', style: CustomTextStyle.whiteStandard(), maxLines: 1, minFontSize: 9,)
                          ),
                          Flexible(
                            flex: 1,
                            child: AutoSizeText(Formatter.formatRupiah((order.price??0) * (order.cancelQty??0)), style: CustomTextStyle.whiteStandard(), maxLines: 1, minFontSize: 9,)
                          ),
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: AutoSizeText('${order.cancelQty}x ${order.name}', style: CustomTextStyle.whiteStandard(), maxLines: 1, minFontSize: 9,)
                          ),
                        ],
                      ),
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