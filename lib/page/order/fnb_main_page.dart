import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/order/cancel_page.dart';
import 'package:front_office_2/page/order/confirm_page.dart';
import 'package:front_office_2/page/order/done_page.dart';
import 'package:front_office_2/page/order/list_fnb_page.dart';
import 'package:front_office_2/page/order/send_order_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/screen_size.dart';

class FnbMainPage extends StatefulWidget {
  const FnbMainPage({super.key});

  static const nameRoute = '/fnb';
  
  @override
  State<FnbMainPage> createState() => _FnbMainPageState();
}

class _FnbMainPageState extends State<FnbMainPage> {

  String roomCode = '';
  final PageController slideController = PageController();
  final List<String> namePage = ['ORDER', 'SEND ORDER', 'CONFIRM', 'DONE', 'CANCEL'];
  int activePageIndex = 0;
  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    print('DEBUGGING $activePageIndex');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColorStyle.appBarBackground(),
          title: Text(roomCode, style: CustomTextStyle.titleAppBar(),),
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              height: ScreenSize.getHeightPercent(context, 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: namePage.length,
                shrinkWrap: true,
                itemBuilder: (ctxPager, index){
                  return InkWell(
                    onTap: (){
                      slideController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Container(
                      height: ScreenSize.getHeightPercent(context, 10),
                      decoration: activePageIndex == index? CustomContainerStyle.barActive(): CustomContainerStyle.barInactive(),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: Center(child: Text(namePage[index], style: activePageIndex == index? CustomTextStyle.whiteSize(16):CustomTextStyle.blackMedium(),)),
                    ),
                  );
                }),
            ),
            Flexible(
              child: PageView(
                controller: slideController,
                onPageChanged: (index){
                  setState(() {
                    activePageIndex = index;
                  });
                },
                children: [
                  ListFnbPage(),
                  SendOrderPage(roomCode: roomCode,),
                  ConfirmOrderPage(roomCode: roomCode),
                  DoneOrderPage(roomCode: roomCode),
                  CancelOrderPage(roomCode: roomCode)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}