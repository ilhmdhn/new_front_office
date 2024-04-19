import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/room_checkin_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/bill/bill_page.dart';
import 'package:front_office_2/page/checkin/edit_checkin_page.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/extend/extend_room_page.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/transfer/reason_transfer_page.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:lottie/lottie.dart';

class RoomCheckinListPage extends StatefulWidget {
  static const nameRoute = '/list-room-checkin';
  const RoomCheckinListPage({super.key});

  @override
  State<RoomCheckinListPage> createState() => _RoomCheckinListPageState();
}

class _RoomCheckinListPageState extends State<RoomCheckinListPage> {


  RoomCheckinResponse? roomCheckinResponse;
  String remaining = 'WAKTU HABIS';
  String searchRoom = '';
  String appBarTitle = '';
  int destination = 0; 
  List<ListRoomCheckinModel> listRoomCheckin = [];
  bool isLoaded = false;

  void getRoomCheckin(String search)async{
    if(destination >0 && destination < 6){
      roomCheckinResponse = await ApiRequest().getListRoomCheckin(search);
    }else if (destination == 6){
      roomCheckinResponse = await ApiRequest().getListRoomPaid(search);
    }else if(destination == 7){
      roomCheckinResponse = await ApiRequest().getListRoomCheckout(search);
    }
    
    if(roomCheckinResponse?.state != true){
      showToastError(roomCheckinResponse?.message??'Error get list room checkin');
    }
    
    setState(() {
      roomCheckinResponse;
      listRoomCheckin = roomCheckinResponse?.data??[];
      if(destination == 1 || destination == 2 || destination == 3 || destination == 4){
        appBarTitle = 'List Room Checkin';
        listRoomCheckin = listRoomCheckin.where((item) => item.printState == '0' && item.summaryCode == '').toList();
      }else if(destination == 5){
        appBarTitle = 'Payment Room';
        listRoomCheckin = listRoomCheckin.where((item) => isNullOrEmpty(item.summaryCode)).toList();
      }else if(destination == 6){
        appBarTitle = 'Checkout Room';
        listRoomCheckin = listRoomCheckin.where((item) => isNotNullOrEmpty(item.summaryCode)).toList();
      }else if(destination == 7){
        appBarTitle = 'Clean Room';
        // listRoomCheckin = listRoomCheckin.where((item) => isNotNullOrEmpty(item.c)).toList();
      }
    });

    isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    destination = ModalRoute.of(context)!.settings.arguments as int;
    if(destination != 0 && isLoaded == false){
      getRoomCheckin('');
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColorStyle.background(),
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color:  Colors.white, //change your color here
          ),
          title: Text(appBarTitle, style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: 
        
        roomCheckinResponse == null?

        const Center(
          child: CircularProgressIndicator(),
        ):

        isNullOrEmpty(listRoomCheckin) && isNullOrEmpty(searchRoom)?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset('assets/animation/empty.json', height: 226, width: 226,),
              const SizedBox(height: 12,),
              Text('Empty', style: CustomTextStyle.blackMedium(),),
            ],
          ),
        ):
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SearchBar(
                hintText: 'Cari Room',
                surfaceTintColor: MaterialStateColor.resolveWith((states) => Colors.white),
                shadowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                onChanged: ((value){
                  searchRoom = value;
                  getRoomCheckin(searchRoom);
                }),
                trailing: Iterable.generate(
                  1, (index) => const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child:  Icon(Icons.search))),
              ),
              const SizedBox(height: 11,),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints){
                  int crossAxisCount = 3;   
                  if (constraints.maxWidth < 580) {
                    crossAxisCount = 2;
                  }
          
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8, // Spasi antar kolom
                      mainAxisSpacing: 8, // Spasi antar baris
                      childAspectRatio: 6/3
                    ),
                    itemCount: listRoomCheckin.length,
                    itemBuilder: (context, index){
                      final roomData = listRoomCheckin[index];
                      if(roomData.remainHour>0 || roomData.remainMinute>0){
                        remaining = 'Sisa';
                        if(roomData.remainHour>0){
                          remaining += ' ${roomData.remainHour} Jam';
                        }
                        if(roomData.remainMinute>0){
                          remaining += ' ${roomData.remainMinute} Menit';
                        }
                      }else{
                        remaining = 'WAKTU HABIS';
                      }
                      return InkWell(
                        onTap: (){
                          movePage(destination, roomData.room);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white, // Warna background
                            borderRadius: BorderRadius.circular(10), // Bentuk border
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2), // Warna shadow
                                spreadRadius: 3, // Radius penyebaran shadow
                                blurRadius: 7, // Radius blur shadow
                                offset: const Offset(0, 3), // Offset shadow
                              ),
                            ],
                          ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: AutoSizeText(roomData.room, style: CustomTextStyle.blackMediumSize(19),  maxLines: 1, minFontSize: 11,),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AutoSizeText(roomData.memberName, style: CustomTextStyle.blackMediumSize(14),  maxLines: 1, minFontSize: 9,),
                                      AutoSizeText(remaining, style: CustomTextStyle.blackMediumSize(14),  maxLines: 2, minFontSize: 9,),
                                    ],
                                  ),
                                )
                                ]),
                        ),
                      );
                    });
                })
            ],
          ),
        ),
      ));
  }

  void movePage(int code, String roomCode)async{
    if(code == 1 && isNotNullOrEmpty(roomCode)){
      Navigator.pushNamed(context, EditCheckinPage.nameRoute, arguments: roomCode);
    }

    if(code == 2 && isNotNullOrEmpty(roomCode)){
      Navigator.pushNamed(context, ExtendRoomPage.nameRoute, arguments: roomCode);
    }

    if(code == 3 && isNotNullOrEmpty(roomCode)){
      Navigator.pushNamed(context, TransferReasonPage.nameRoute, arguments: roomCode);
    }

    if(code == 5 && isNotNullOrEmpty(roomCode)){
      Navigator.pushNamed(context, BillPage.nameRoute, arguments: roomCode);
    }

    if(code == 6 && isNotNullOrEmpty(roomCode)){
      final confirmCheckout = await ConfirmationDialog.confirmation(context, 'Checkout Room $roomCode?');
      if(confirmCheckout != true){
        return;
      }

      final checkoutState = await ApiRequest().checkout(roomCode);

      if(checkoutState.state != true){
        showToastError('Gagal checout room ${checkoutState.message}');
        return;
      }
      BuildContext ctxNya = context;
      if(ctxNya.mounted){
        Navigator.pushNamedAndRemoveUntil(ctxNya, MainPage.nameRoute, (route) => false);
      }
    }

    if(code == 7 && isNotNullOrEmpty(roomCode)){
      BuildContext ctxNya = context;
      if(!ctxNya.mounted){
        showToastWarning('Ulangi clean room');
        return;
      }
      final confirmCheckout = await ConfirmationDialog.confirmation(ctxNya, 'Clean Room $roomCode?');
      if(confirmCheckout != true){
        return;
      }

      final checkoutState = await ApiRequest().clean(roomCode);

      if(checkoutState.state != true){
        showToastError('Gagal checout room ${checkoutState.message}');
        return;
      }

      if(ctxNya.mounted){
        Navigator.pushNamedAndRemoveUntil(ctxNya, MainPage.nameRoute, (route) => false);
      }else{
        showToastWarning('BERHASIL CLEAN ROOM');
      }
    }
  }
}