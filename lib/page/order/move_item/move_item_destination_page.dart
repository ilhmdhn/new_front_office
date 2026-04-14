import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/enum/pos_type.dart';
import 'package:front_office_2/data/model/model_helper/move_item_model.dart';
import 'package:front_office_2/data/model/room_checkin_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/orientation.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class DestinationItemPage extends StatefulWidget {
  static const nameRoute = '/destination-item';
  const DestinationItemPage({super.key});

  @override
  State<DestinationItemPage> createState() => _DestinationItemPageState();
}

class _DestinationItemPageState extends State<DestinationItemPage> {

  RoomCheckinResponse? roomCheckinResponse;
  String searchRoom = '';
  List<ListRoomCheckinModel> listRoomCheckin = [];
  bool isLoaded = false;
  bool isRestoOutlet = false;
  final pos = GlobalProviders.read(posTypeProvider);
  late MoveItemModel item;

  void getRoomCheckin(String search)async{
    roomCheckinResponse = await ApiRequest().getListRoomCheckin(search);
  
    if(roomCheckinResponse?.state != true){
      showToastError(roomCheckinResponse?.message??'Error get list room checkin');
    }
    setState(() {
      roomCheckinResponse;
      listRoomCheckin = roomCheckinResponse?.data??[];
      listRoomCheckin = listRoomCheckin.where((thisRoom) => thisRoom.summaryCode == '' && thisRoom.room != item.roomSource).toList();
    });

    isLoaded = true;
  }

  @override
  void initState() {
    super.initState();
      if(pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased){
        isRestoOutlet = true;
      }
    getRoomCheckin('');
  }

  @override
  Widget build(BuildContext context) {
    bool isPotrait = isVertical(context);
    item = ModalRoute.of(context)?.settings.arguments as MoveItemModel;
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color:  Colors.white, //change your color here
        ),
        title: Text('Table tujuan item', style: CustomTextStyle.titleAppBar(),),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.food_bank_outlined, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Detail Item',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildList('Nama Item', item.itemName),
                  const SizedBox(height: 2),
                  _buildList('qty', item.qty.toString()),
                  const SizedBox(height: 2),
                  _buildList('dari table', item.roomSource),
                  _buildList('slip order', item.slipOrderCode),
                ],
              ),
            ),
            SizedBox(height: 12,),
            SizedBox(
              height: ScreenSize.getHeightPercent(context, 10),
              child: SearchBar(
                hintText: 'Cari Room',
                backgroundColor: WidgetStateColor.resolveWith((states) => Colors.white),
                surfaceTintColor: WidgetStateColor.resolveWith((states) => Colors.white),
                shadowColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                onChanged: ((value){
                  searchRoom = value;
                  getRoomCheckin(searchRoom);
                }),
                trailing: Iterable.generate(
                  1,(index) => const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child:  Icon(Icons.search)
                  )
                ),
              ),
            ),
            const SizedBox(height: 11,),
            Flexible(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints){
                  int crossAxisCount = 3;   
                  if (constraints.maxWidth < 580) {
                    crossAxisCount = 2;
                  }     
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8, // Spasi antar kolom
                      mainAxisSpacing: 8, // Spasi antar baris
                      childAspectRatio: 6/2
                    ),
                    itemCount: listRoomCheckin.length,
                    itemBuilder: (context, index){
                      final roomData = listRoomCheckin[index];
                      return InkWell(
                        onTap: ()async{
                          final isConfirmed = await ConfirmationDialog.confirmation(context, 'Pindahkan item ${item.itemName} ke ${roomData.room}');
                          if(isConfirmed){
                            final moveState = await ApiRequest().moveItem(item, roomData.room);
                            if(moveState.state == true){
                              if(context.mounted){
                                Navigator.pushNamedAndRemoveUntil(context, MainPage.nameRoute, (route)=>false);
                              }else{
                                showToastError('Gagal memindahkan item');
                              }
                            }
                          }
                          return;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.white, // Warna background
                            borderRadius: BorderRadius.circular(10), // Bentuk border
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha:  0.2), // Warna shadow
                                spreadRadius: 3, // Radius penyebaran shadow
                                blurRadius: 7, // Radius blur shadow
                                offset: const Offset(0, 3), // Offset shadow
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText(roomData.room, style: CustomTextStyle.blackMediumSize(isPotrait? 19: 29),  maxLines: 1, minFontSize: 11,),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    AutoSizeText(roomData.memberName, style: CustomTextStyle.blackMediumSize(14),  maxLines: 1, minFontSize: 9,),                                   ],
                                ),
                              ),
                              isRestoOutlet && roomData.printState != '0'?
                              Center(
                                child: Transform.rotate(
                                  angle: -0.2,
                                  child: AutoSizeText('Print Bill', style: GoogleFonts.poppins(color: Colors.deepOrange, fontSize: 16, fontWeight: FontWeight.w500), minFontSize: 9, maxLines: 1, overflow: TextOverflow.ellipsis,)
                                ), 
                              ): SizedBox.shrink()
                            ]
                          ),
                        ),
                      );
                    });
                }),
            ),
            const SizedBox(height: 11,)
          ],
        ),
      ),
    );
  }

  Widget _buildList(String key, String value){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(key, style: CustomTextStyle.blackStandard())
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(':', style: CustomTextStyle.blackStandard()),
        ),
        Expanded(
          flex: 2,
          child: Text(value, style: CustomTextStyle.blackMedium())
        )
      ],
    );
  }
}