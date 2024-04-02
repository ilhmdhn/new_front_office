import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class ExtendRoomPage extends StatefulWidget {
  static const nameRoute = '/room-extend';
  const ExtendRoomPage({super.key});

  @override
  State<ExtendRoomPage> createState() => _ExtendRoomPageState();
}

class _ExtendRoomPageState extends State<ExtendRoomPage> {

  TextEditingController _extendController = TextEditingController();
  TextEditingController _reduceController = TextEditingController();
  DetailCheckinResponse? detailCheckin;
  bool isLoading = false;

  
  void getData(String roomCode) async{
    setState(() {
      isLoading = true;
    });
    detailCheckin = await ApiRequest().getDetailRoomCheckin(roomCode);
    setState(() {
      detailCheckin;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    String roomCode = ModalRoute.of(context)!.settings.arguments as String;

    if(detailCheckin == null){
      getData(roomCode);
    }
    String memberName = detailCheckin?.data?.memberName??'Nama Member tidak ada';
    String memberCode = detailCheckin?.data?.memberCode??'Belum diisi';
    String room = detailCheckin?.data?.roomCode??'Belum diisi';
    String remainingTime = 'WAKTU HABIS';

    int hourRemaining = (detailCheckin?.data?.hourRemaining??0);
    int minuteRemaining = (detailCheckin?.data?.minuteRemaining??0);

    if(hourRemaining>0 || minuteRemaining>0){
      remainingTime = 'Sisa';

      if(hourRemaining>0){
        remainingTime += ' $hourRemaining Jam';
      }

      if(minuteRemaining>0){
        remainingTime+= ' $minuteRemaining Menit';
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColorStyle.background(),
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color:  Colors.white, //change your color here
          ),
          title: Text('Change Checkin Duration', style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: 
        
        isLoading == true?

        Center(
          child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground(),),
        ):

        detailCheckin?.state != true?
        Center(
          child: AutoSizeText(detailCheckin?.message??'ERROR GET DATA CHECKIN'),
        ):
        Column(
          children: [
            Center(
              child: AutoSizeText('INFORMASI CHECKIN', style: CustomTextStyle.blackMediumSize(21), minFontSize: 12, maxLines: 1,),
            ),
            const SizedBox(height: 12,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AutoSizeText(memberCode, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                      AutoSizeText(memberName, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                    ],
                  ),
                ),
                Container(width: 1, height: 39,color: CustomColorStyle.bluePrimary()),
                Expanded(
                  child: Column(
                    children: [
                      AutoSizeText(room, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                      AutoSizeText(remainingTime, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                    ],
                  )
                )
              ],
            ),
            const SizedBox(height: 12,),

            Text('Durasi Extend', style: CustomTextStyle.blackMedium(),),
            Row(
              children: [
                
              ],
            )
          ],
        ),
      ));
  }

  @override
  void dispose() {
    _extendController.dispose();
    _reduceController.dispose();
    super.dispose();
  }
}