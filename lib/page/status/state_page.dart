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
    if(mounted){
      setState(() {
        data;
      });
    }
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
          shrinkWrap: false,
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
                    height: 105,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(alignment: Alignment.center, child: AutoSizeText('ROOM INFO', style: CustomTextStyle.blackMediumSize(13), maxLines: 1, minFontSize: 10,)),
                                AutoSizeText('Room  : ${room.room}', style: CustomTextStyle.blackMediumSize(13), maxLines: 1, minFontSize: 10,),
                                AutoSizeText('Guest : ${room.guest}', style: CustomTextStyle.blackMediumSize(13),maxLines: 1, minFontSize: 10,),
                                AutoSizeText('Waktu : ${room.timeRemain}', style: CustomTextStyle.blackMediumSize(13),maxLines: 1, minFontSize: 10,),
                                AutoSizeText('Status : ${room.state == '0'?'Checkin':'Bill'}', style: CustomTextStyle.blackMediumSize(13),maxLines: 1, minFontSize: 10,)
                              ],
                            ),
                          ),
                        ),
                        Center(child: Container(color: Colors.grey, width: 1,)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AutoSizeText('ORDER INFO', style: CustomTextStyle.blackMediumSize(13), textAlign: TextAlign.center, maxLines: 1,),
                                  ],
                                ),
                                room.so == 0 && room.process == 0 && room.delivery == 0 && room.cancel == 0?
                                Expanded(child: Center(child: LottieBuilder.asset('assets/animation/zxz.json', height: 70, width: 70,))):
                                Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          child: Row(
                                            children: [
                                              const SizedBox( height: 16, width: 16,
                                              child: Icon(
                                                Icons.inventory_outlined,
                                                color: Colors.green,
                                                size: 16,
                                              ),
                                              ),
                                              const SizedBox(width: 4,),
                                              AutoSizeText('Order', style: CustomTextStyle.blackMediumSize(13), maxLines: 1, minFontSize: 10,),
                                            ],
                                          ),
                                        ),
                                        AutoSizeText(': ${room.so}', style: CustomTextStyle.blackMediumSize(13), maxLines: 1,),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child: Icon(
                                                  Icons.wifi_protected_setup,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              AutoSizeText(
                                                'Process',
                                                style: CustomTextStyle.blackMediumSize(13),
                                                maxLines: 1,
                                                minFontSize: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        AutoSizeText(': ${room.process}',
                                          style: CustomTextStyle.blackMediumSize(13), maxLines: 1,),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child: Icon(
                                                  Icons.done_all_outlined,
                                                  color: Colors.blue,
                                                  size: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              AutoSizeText(
                                                'Delivery',
                                                style: CustomTextStyle.blackMediumSize(13),
                                                maxLines: 1,
                                                minFontSize: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        AutoSizeText(': ${room.delivery}', style: CustomTextStyle.blackMediumSize(13), maxLines: 1,),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child: Icon( Icons.turn_left, color: Colors.redAccent, size: 16,),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              AutoSizeText('Cancel', style: CustomTextStyle.blackMediumSize(13), maxLines: 1, minFontSize: 10,),
                                            ],
                                          ),
                                        ),
                                        AutoSizeText(': ${room.cancel}', style: CustomTextStyle.blackMediumSize(13), maxLines: 1,),
                                      ],
                                    ),
                                  ],
                                ),
                                ],
                            ),
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