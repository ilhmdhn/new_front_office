import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/room_list_model.dart';
import 'package:front_office_2/data/model/transfer_params.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/filter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';

class ListRoomTransferPage extends StatefulWidget {
    static const nameRoute = '/list-room-transfer-page';
  const ListRoomTransferPage({super.key});

  @override
  State<ListRoomTransferPage> createState() => _ListRoomTransferPageState();
}

class _ListRoomTransferPageState extends State<ListRoomTransferPage> {

  RoomListResponse listRoomResponse = RoomListResponse();
  TransferParams transferParams = TransferParams();
  bool isLoading = false;
  bool gettedData = false;

  @override
  Widget build(BuildContext context) {

    transferParams = ModalRoute.of(context)?.settings.arguments as TransferParams;
    if(!gettedData){
      getData();
    }
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColorStyle.background(),
        appBar: AppBar(
          title: Align(alignment: Alignment.centerLeft ,child: Text('Room Tujuan', style: CustomTextStyle.titleAppBar(),)),
          iconTheme: const IconThemeData(
            color:  Colors.white,
          ),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: 
        Padding(
          padding: const EdgeInsets.all(12),
          child:   
            isLoading? AddOnWidget.loading():
          listRoomResponse.state != true?
          AddOnWidget.error(listRoomResponse.message):
          isNullOrEmpty(listRoomResponse.data)?
          AddOnWidget.empty():
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              int crossAxisCount = 3;   
              if (constraints.maxWidth < 580) {
                crossAxisCount = 2;
              }
              final listRoomItem = listRoomResponse.data;
          
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8, // Spasi antar kolom
                  mainAxisSpacing: 8, // Spasi antar baris
                  childAspectRatio: 10/3
                ),
                itemCount: listRoomItem.length,
                itemBuilder: (BuildContext context, int index){
                  return InkWell(
                    onTap:()async{
                      showToastWarning('roomDestination: ${transferParams.roomDestination} roomTypeDestination: ${transferParams.roomTypeDestination} isRoomCheckin: ${transferParams.isRoomCheckin} oldRoom: ${transferParams.oldRoom} transferReason: ${transferParams.transferReason}');

                      if(Filter.isLobby(transferParams.roomTypeDestination??'')){

                      }else{

                      }
                    },
                    child: Container(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(listRoomItem[index].roomCode.toString(), style: CustomTextStyle.blackMediumSize(21),  maxLines: 2, minFontSize: 12,),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                        ]
                      ),
                    ),
                  );
                });
            }
          ),
        ),
      ),
    );
  }

  void getData()async{
    setState(() {
      isLoading = true;
    });
    listRoomResponse = await ApiRequest().getRoomList(transferParams.roomTypeDestination??'');
    if(listRoomResponse.state == true){
      setState(() {
        isLoading = false;
        listRoomResponse;
        gettedData = true;
      });
    }else{
      setState(() {
        isLoading = false;
        listRoomResponse;
      });
    }
  }
}