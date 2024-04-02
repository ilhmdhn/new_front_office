import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/verification_dialog.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/toast.dart';

class ExtendRoomPage extends StatefulWidget {
  static const nameRoute = '/room-extend';
  const ExtendRoomPage({super.key});

  @override
  State<ExtendRoomPage> createState() => _ExtendRoomPageState();
}

class _ExtendRoomPageState extends State<ExtendRoomPage> {

  DetailCheckinResponse? detailCheckin;
  bool isLoading = false;
  int extendTime = 0;
  int reduceTime = 0;
  
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
    String rcp = detailCheckin?.data?.reception??'NOT SET';
    
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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


              const SizedBox(height: 16,),
              Align(alignment: Alignment.centerLeft, child: AutoSizeText('Extend Checkin Duration', style: CustomTextStyle.blackMediumSize(17),)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      setState((){
                        if(extendTime>0){
                          --extendTime;
                        }
                      });
                    },
                    child: SizedBox(
                      height: 43,
                      width: 43,
                      child: Image.asset(
                        'assets/icon/minus.png'),
                    )
                  ),
                  const SizedBox(width: 9,),
                  AutoSizeText(extendTime.toString(), style: CustomTextStyle.blackMediumSize(26), maxLines: 1, minFontSize: 11,),
                  const SizedBox(width: 9,),
                  InkWell(
                    onTap: (){
                      setState((){
                        if(extendTime < 24){
                          ++extendTime;
                        }
                      });
                    },
                    child: SizedBox(
                      height: 43,
                      width: 43,
                      child: Image.asset(
                        'assets/icon/plus.png'),
                    )
                  ),
                  const SizedBox(width: 12,),
                  ElevatedButton(
                    onPressed: ()async{
                      final reduceState = await ApiRequest().extendRoom(roomCode, extendTime.toString());
                      if(reduceState.state == true){
                        if(context.mounted){
                          Navigator.pushNamedAndRemoveUntil(context, MainPage.nameRoute, (route) => false);
                        }else{
                          showToastWarning('Berhasil silahkan kembali');
                        }
                      }else{
                        showToastError(reduceState.message??'Gagal reduce duration');
                      }
                    },
                    style: CustomButtonStyle.confirm(),
                    child: Text('Extend Room', style: CustomTextStyle.whiteSize(16),)),
                ],
              ),
              const SizedBox(height: 26,),
              Align(alignment: Alignment.centerLeft, child: AutoSizeText('Reduce Checkin Duration', style: CustomTextStyle.blackMediumSize(17),)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      setState((){
                        if(reduceTime>0){
                          --reduceTime;
                        }
                      });
                    },
                    child: SizedBox(
                      height: 43,
                      width: 43,
                      child: Image.asset(
                        'assets/icon/minus.png'),
                    )
                  ),
                  const SizedBox(width: 9,),
                  AutoSizeText('- ${reduceTime.toString()}', style: CustomTextStyle.blackMediumSize(26), maxLines: 1, minFontSize: 11,),
                  const SizedBox(width: 9,),
                  InkWell(
                    onTap: (){
                      setState((){
                        if(reduceTime < 24){
                          ++reduceTime;
                        }
                      });
                    },
                    child: SizedBox(
                      height: 43,
                      width: 43,
                      child: Image.asset(
                        'assets/icon/plus.png'),
                    )
                  ),
                  const SizedBox(width: 12,),
                  ElevatedButton(
                    onPressed: ()async{
                      final biometricResult = await VerificationDialog.requestVerification(context, rcp, 'Reduce Checkin Duration');
                      if(biometricResult == true){
                          final reduceState = await ApiRequest().reduceRoom(rcp, reduceTime.toString());
                      if(reduceState.state == true){
                        if(context.mounted){
                          Navigator.pushNamedAndRemoveUntil(context, MainPage.nameRoute, (route) => false);
                        }else{
                          showToastWarning('Berhasil silahkan kembali');
                        }
                      }else{
                        showToastError(reduceState.message??'Gagal reduce duration');
                      }
                      }
                    },
                    style: CustomButtonStyle.cancel(),
                    child: Text('Reduce Duration', style: CustomTextStyle.whiteSize(16),)
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
  }

  @override
  void dispose() {
    // _extendController.dispose();
    // _reduceController.dispose();
    super.dispose();
  }
}