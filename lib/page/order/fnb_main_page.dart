import 'package:flutter/material.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/order/cancel_page.dart';
import 'package:front_office_2/page/order/confirm_page.dart';
import 'package:front_office_2/page/order/done_page.dart';
import 'package:front_office_2/page/order/list_fnb_page.dart';
import 'package:front_office_2/page/order/send_order_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class FnbMainPage extends StatefulWidget {
  const FnbMainPage({super.key});

  static const nameRoute = '/fnb';
  
  @override
  State<FnbMainPage> createState() => _FnbMainPageState();
}

class _FnbMainPageState extends State<FnbMainPage> {

  String roomCode = '';
  
  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColorStyle.appBarBackground(),
          title: Text(roomCode, style: CustomTextStyle.titleAppBar(),),
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
        ),
        body: PageView(
          children: [
            ListFnbPage(),
            SendOrderPage(),
            ConfirmOrderPage(),
            DoneOrderPage(),
            CancelOrderPage()
          ],
        ),
      ),
    );
  }
}