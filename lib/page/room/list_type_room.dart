import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/checkin_params.dart';
import 'package:front_office_2/data/model/room_type_model.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/room/list_room_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';

class ListRoomTypePage extends StatefulWidget {
  static const nameRoute = '/list-room-type';
  const ListRoomTypePage({super.key});

  @override
  State<ListRoomTypePage> createState() => _ListRoomTypePageState();
}

class _ListRoomTypePageState extends State<ListRoomTypePage> {
  ListRoomTypeReadyResponse listRoom = ListRoomTypeReadyResponse();
  @override
  void initState(){
    getData();
    super.initState();
  }

  void getData()async{
    final listRoomResponseResult = await ApiRequest().getListRoomTypeReady();
    if(listRoomResponseResult.isLoading ==false){
      setState(() {
        listRoom = listRoomResponseResult;
        if(listRoom.state != true){
          showToastError(listRoom.message.toString());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkinArgs = ModalRoute.of(context)?.settings.arguments as CheckinParams;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        iconTheme: const IconThemeData(
          color:  Colors.white, //change your color here
        ),
        title: Text('List Room Type', style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        backgroundColor: CustomColorStyle.background(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 55,
                    child: CircleAvatar(
                      backgroundImage: Image.asset('assets/icon/user.png').image,
                    ),
                  ),
                  const SizedBox(width: 6,),
                  Column(
                    children: [
                      const SizedBox(height: 3,),
                      Text(checkinArgs.memberName??'', style: CustomTextStyle.blackMedium()),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 26,),
              Expanded(
                child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  int crossAxisCount = 3;
                
                  if (constraints.maxWidth < 580) {
                    crossAxisCount = 2;
                  }
          
                  final listRoomItem = listRoom.data;
                  return GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8, // Spasi antar kolom
                      mainAxisSpacing: 8, // Spasi antar baris
                      childAspectRatio: 10/3
                    ),
                    itemCount: listRoomItem.length, 
                    itemBuilder: (context, index){
                      return InkWell(
                        onTap: (){
                          checkinArgs.roomType = listRoomItem[index].roomType;
                          Navigator.pushNamed(context, ListRoomReadyPage.nameRoute, arguments:checkinArgs);
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
                                          SizedBox(
                                            width: ScreenSize.getSizePercent(context, 38),
                                            child: AutoSizeText(listRoomItem[index].roomType.toString(), style: CustomTextStyle.blackMedium(),  maxLines: 1, minFontSize: 9,)),
                                          AutoSizeText('Room Ready ${listRoomItem[index].roomAvailable.toString()}', style: CustomTextStyle.blackMediumSize(13),  maxLines: 1, minFontSize: 12,),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                                  ]),
                                ),
                      );
                    });
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}