import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/tools/helper.dart';

class SendOrderPage extends StatefulWidget {
  final String roomCode;
  const SendOrderPage({super.key, required this.roomCode});

  @override
  State<SendOrderPage> createState() => _SendOrderPageState();
}

class _SendOrderPageState extends State<SendOrderPage> {

  List<OrderedModel> listOrder = List.empty(growable: true);
  OrderResponse? apiResult;

  void getData()async{
    apiResult = await ApiRequest().getOrder(widget.roomCode);
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
      isNullOrEmpty(apiResult?.data)?
      AddOnWidget.empty():
      Column()
    );
  }
}