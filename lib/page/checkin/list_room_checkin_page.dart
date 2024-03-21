import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/room_checkin_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/checkin/edit_checkin_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';

class RoomCheckinListPage extends StatefulWidget {
  static const nameRoute = '/list-room-checkin';
  const RoomCheckinListPage({super.key});

  @override
  State<RoomCheckinListPage> createState() => _RoomCheckinListPageState();
}

class _RoomCheckinListPageState extends State<RoomCheckinListPage> {


  RoomCheckinResponse? roomCheckinResponse;
  int destination = 0;

  void getRoomCheckin(String search)async{
    roomCheckinResponse = await ApiRequest().getListRoomCheckin(search);
    
    if(roomCheckinResponse?.state != true){
      showToastError(roomCheckinResponse?.message??'Error get list room checkin');
    }
    
    setState(() {
      roomCheckinResponse;
    });
  }

  @override
  void initState() {
    getRoomCheckin('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    destination = ModalRoute.of(context)!.settings.arguments as int;
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColorStyle.background(),
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color:  Colors.white, //change your color here
          ),
          title: Text('List Room Checkin', style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: 
        
        roomCheckinResponse == null?

        const Center(
          child: CircularProgressIndicator(),
        ):
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SearchBar(
                hintText: 'Cari Room',
                surfaceTintColor: MaterialStateColor.resolveWith((states) => Colors.white),
                shadowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
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
                    itemCount: roomCheckinResponse?.data.length,
                    itemBuilder: (context, index){
                      final roomData = roomCheckinResponse?.data[index];
                      return InkWell(
                        onTap: (){
                          movePage(destination, roomData?.room??'');
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
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: AutoSizeText(roomData?.room??'kode room', style: CustomTextStyle.blackMediumSize(19),  maxLines: 1, minFontSize: 11,),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AutoSizeText(roomData?.memberName??'nama', style: CustomTextStyle.blackMediumSize(14),  maxLines: 1, minFontSize: 9,),
                                      AutoSizeText((roomData?.remainTime??0)>0?'Sisa ${roomData?.remainTime??0} menit': 'WAKTU HABIS', style: CustomTextStyle.blackMediumSize(14),  maxLines: 1, minFontSize: 9,),
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

  void movePage(int code, String roomCode){
    if(code == 1 && isNotNullOrEmpty(roomCode)){
      Navigator.pushNamed(context, EditCheckinPage.nameRoute, arguments: roomCode);
    }
  }
}