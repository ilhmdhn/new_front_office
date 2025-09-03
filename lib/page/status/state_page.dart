import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/status_room_checkin.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:lottie/lottie.dart';

class StatePage extends StatefulWidget {
  static const nameRoute = '/history';
  const StatePage({super.key});

  @override
  State<StatePage> createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {

  RoomCheckinState? data;

  void getData()async{
    if(data != null){
      return;
    }

    data = await ApiRequest().checkinState();
    setState(() {
      data;
    });
  }


  @override
  Widget build(BuildContext context) {
  final marginX = ScreenSize.getSizePercent(context, 2);
  final width = ScreenSize.getSizePercent(context, 43);

    getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Checkin', style: CustomTextStyle.titleAppBar(),),
        backgroundColor: CustomColorStyle.appBarBackground(),
      ),
      backgroundColor: CustomColorStyle.background(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: 
        
        data == null? AddOnWidget.loading():
        data?.state == false? AddOnWidget.error(data?.message):
        isNullOrEmpty(data?.data)?AddOnWidget.empty():
        ListView.builder(
          shrinkWrap: true,
          itemCount: data?.data?.length,
          itemBuilder: (context, index){
            final room = data!.data![index];
            return Container(
              decoration: CustomContainerStyle.whiteList(),
              margin: EdgeInsets.symmetric(horizontal: marginX, vertical: 3),
              padding: EdgeInsets.symmetric(horizontal: marginX),
              child: Column(
                children: [
                  SizedBox(
                    width: width*2,
                    height: 125,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(alignment: Alignment.center, child: AutoSizeText('ROOM INFO', style: CustomTextStyle.blackMedium(), maxLines: 1, minFontSize: 12,)),
                              AutoSizeText('Room  : ${room.room}', style: CustomTextStyle.blackMedium(), maxLines: 1, minFontSize: 12,),
                              AutoSizeText('Guest : ${room.guest}', style: CustomTextStyle.blackMedium(),maxLines: 1, minFontSize: 12,),
                              AutoSizeText('Waktu : ${room.timeRemain}', style: CustomTextStyle.blackMedium(),maxLines: 1, minFontSize: 12,),
                              AutoSizeText('Status : ${room.state == '0'?'Checkin':'Bill'}', style: CustomTextStyle.blackMedium(),maxLines: 1, minFontSize: 12,)
                            ],
                          ),
                        ),
                        Center(child: Container(color: Colors.grey, width: 1,)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AutoSizeText('ORDER INFO', style: CustomTextStyle.blackMedium(), textAlign: TextAlign.center,),
                                ],
                              ),
                              room.so == 0 && room.process == 0 && room.delivery == 0 && room.cancel == 0?
                              Expanded(child: Center(child: LottieBuilder.asset('assets/animation/zxz.json', height: 96, width: 96,))):
                              Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        width: 96,
                                        child: Row(
                                          children: [
                                            const SizedBox( height: 24, width: 24,
                                            child: Icon(
                                              Icons.inventory_outlined,
                                              color: Colors.green,
                                            ),
                                            ),
                                            const SizedBox(width: 6,),
                                            AutoSizeText('Order', style: CustomTextStyle.blackMedium(),),
                                          ],
                                        ),
                                      ),
                                      AutoSizeText(': ${room.so}', style: CustomTextStyle.blackMedium()),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        width: 96,
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: Icon(
                                                Icons.wifi_protected_setup,
                                                color: Colors.amber,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            AutoSizeText(
                                              'Process',
                                              style: CustomTextStyle.blackMedium(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      AutoSizeText(': ${room.process}',
                                        style: CustomTextStyle.blackMedium()),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        width: 96,
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: Icon(
                                                Icons.done_all_outlined,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            AutoSizeText(
                                              'Delivery',
                                              style: CustomTextStyle.blackMedium(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      AutoSizeText(': ${room.delivery}', style: CustomTextStyle.blackMedium()),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        width: 96,
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: Icon( Icons.turn_left, color: Colors.redAccent,),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            AutoSizeText('Cancel', style: CustomTextStyle.blackMedium(),),
                                          ],
                                        ),
                                      ),
                                      AutoSizeText(': ${room.cancel}', style: CustomTextStyle.blackMedium()),
                                    ],
                                  ),
                                ],
                              ),
                              ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
      )
    );
  }
}