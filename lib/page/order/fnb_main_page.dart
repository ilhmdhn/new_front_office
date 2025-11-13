import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/order/cancel_page.dart';
import 'package:front_office_2/page/order/confirm_page.dart';
import 'package:front_office_2/page/order/done_page.dart';
import 'package:front_office_2/page/order/list_fnb_page.dart';
import 'package:front_office_2/page/order/send_order_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/screen_size.dart';

class FnbMainPage extends StatefulWidget {
  const FnbMainPage({super.key});

  static const nameRoute = '/fnb';
  
  @override
  State<FnbMainPage> createState() => _FnbMainPageState();
}

class _FnbMainPageState extends State<FnbMainPage> {

  final PageController slideController = PageController();
  DetailCheckinResponse? dataCheckin;

  String userLevel = PreferencesData.getUser().level??'';

  List<String> namePage = [];

  int activePageIndex = 0;

  void getData(String roomCode)async{
    dataCheckin = await ApiRequest().getDetailRoomCheckin(roomCode);
    setState(() {
      dataCheckin;
    });
  }

  @override
  Widget build(BuildContext context) {
  final roomCode = ModalRoute.of(context)!.settings.arguments as String;

  if(userLevel == 'KASIR'){
    namePage = ['ORDER', 'SEND ORDER', 'CONFIRM', 'DONE', 'CANCEL'];
  }else{
    namePage = ['ORDER', 'SEND ORDER', 'DONE', 'CANCEL'];
  }


  if(dataCheckin == null){
    getData(roomCode);
  }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColorStyle.appBarBackground(),
          title: Text(roomCode, style: CustomTextStyle.titleAppBar(),),
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
        ),
        backgroundColor: CustomColorStyle.background(),
        body: 
        
      dataCheckin == null?
        AddOnWidget.loading():
      dataCheckin?.state != true?
        AddOnWidget.error(dataCheckin?.message??'Error get detail checkin'):
        Column(
          children: [
            Container(
              color: Colors.white,
              width: ScreenSize.getSizePercent(context, 100),
              height: ScreenSize.getHeightPercent(context, 10),
              child:
              Align(
                alignment: Alignment.center,
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
            ),
            Flexible(
              child: 
              
              userLevel == 'KASIR' || userLevel == 'SUPERVISOR' || userLevel == 'IT'?
              
              PageView(
                controller: slideController,
                onPageChanged: (index){
                  setState(() {
                    activePageIndex = index;
                  });
                },
                children: [
                  ListFnbPage(detailCheckin: dataCheckin!.data!,),
                  SendOrderPage(detailCheckin: dataCheckin!.data!),
                  ConfirmOrderPage(roomCode: roomCode),
                  DoneOrderPage(detailCheckin: dataCheckin!.data!),
                  CancelOrderPage(roomCode: roomCode)
                ],
              ):PageView(
                controller: slideController,
                onPageChanged: (index){
                  setState(() {
                    activePageIndex = index;
                  });
                },
                children: [
                  ListFnbPage(detailCheckin: dataCheckin!.data!,),
                  SendOrderPage(detailCheckin: dataCheckin!.data!),
                  DoneOrderPage(detailCheckin: dataCheckin!.data!),
                  CancelOrderPage(roomCode: roomCode)
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}