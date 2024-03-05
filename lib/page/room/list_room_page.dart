import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/checkin_params.dart';
import 'package:front_office_2/data/model/room_list_model.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/toast.dart';

class ListRoomReadyPage extends StatefulWidget {
  static const nameRoute = '/list-room';
  const ListRoomReadyPage({super.key});

  @override
  State<ListRoomReadyPage> createState() => _ListRoomReadyPageState();
}

class _ListRoomReadyPageState extends State<ListRoomReadyPage> {

  RoomListResponse listRoom = RoomListResponse();
  CheckinParams checkinParams = CheckinParams();

  @override
  void didChangeDependencies() {
    checkinParams = ModalRoute.of(context)?.settings.arguments as CheckinParams;
    getData(checkinParams.roomType.toString());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
          color:  Colors.white, //change your color here
          ),
          title: Text('Tipe Room ${checkinParams.roomType}', style: CustomTextStyle.titleAppBar(),),
            backgroundColor: CustomColorStyle.appBarBackground(),
          ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              int crossAxisCount = 3;   
              if (constraints.maxWidth < 600) {
                crossAxisCount = 2;
              }
              final listRoomItem = listRoom.data;
          
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8, // Spasi antar kolom
                  mainAxisSpacing: 8, // Spasi antar baris
                  childAspectRatio: 10/3
                ),
                itemCount: listRoomItem.length,
                itemBuilder: (context, index){
                  return InkWell(
                    onTap:(){
                      showToastWarning(listRoomItem[index].roomName.toString());
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                                      ]),
                                  ),
                                  ),
                  );
                });
            }
          ),
        ),
      )
    );
  }

  void getData(String typeCode)async{
    listRoom = await ApiRequest().getRoomList(typeCode);
    setState(() {
      listRoom;
    });
  }
}