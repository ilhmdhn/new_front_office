import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/core/extention/extention.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/room_type_model.dart';
import 'package:front_office_2/data/model/transfer_params.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/transfer/list_room_transfer_page.dart';
import 'package:front_office_2/tools/filter.dart';
import 'package:front_office_2/tools/list.dart';
import 'package:front_office_2/tools/toast.dart';

class TransferReasonPage extends StatefulWidget {
  static const nameRoute = '/transfer-reasong';
  const TransferReasonPage({super.key});

  @override
  State<TransferReasonPage> createState() => _TransferReasonPageState();
}

class _TransferReasonPageState extends State<TransferReasonPage> {

  bool isLoading = true;
  ListRoomTypeReadyResponse listAvailableRoomTypeResponse = ListRoomTypeReadyResponse();
  DetailCheckinResponse? detailRoom;
  List<RoomTypeReadyData> listAvailableRoomType = List.empty();
  String roomCode = '';
  TransferParams transferParams = TransferParams();

  void getData()async{

    detailRoom = await ApiRequest().getDetailRoomCheckin(roomCode);
    String roomType = detailRoom?.data?.roomType??'';
    
    listAvailableRoomTypeResponse = await ApiRequest().getListRoomTypeReady();

    if(listAvailableRoomTypeResponse.state != true){
      setState(() {
        listAvailableRoomTypeResponse;
        isLoading = false;
      });

      showToastError(listAvailableRoomTypeResponse.message??'Error get list room');
      return;
    }

    if(Filter.isLobby(roomType)){
      listAvailableRoomType = listAvailableRoomTypeResponse.data.where((element) => Filter.isLobby(element.roomType??'')).toList();
    }else{
      listAvailableRoomType = listAvailableRoomTypeResponse.data.where((element) => !Filter.isLobby(element.roomType??'')).toList();
    }
    setState(() {
      listAvailableRoomType;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    transferParams = ModalRoute.of(context)?.settings.arguments as TransferParams;
    transferParams.transferReason??= 'Overpax';
    roomCode = transferParams.oldRoom??'';
    if(detailRoom == null){
      getData();
    }
    
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      appBar: AppBar(
        title: Align(alignment: Alignment.centerLeft ,child: Text('Alasan Transfer Room', style: CustomTextStyle.titleAppBar(),)),
        iconTheme: const IconThemeData(
          color:  Colors.white,
        ),
        backgroundColor: CustomColorStyle.appBarBackground(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText("Alasan Transfer", style: CustomTextStyle.blackStandard(),),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transferReason.length,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 
                context.isLandscape && context.isDesktop?
                5:
                context.isTablet?3:2,   // Membuat 2 kolom
                childAspectRatio: 5.1,       // Rasio ramping (lebar : tinggi)
                crossAxisSpacing: 10,        // Jarak antar tombol ke samping
                mainAxisSpacing: 10,         // Jarak antar tombol ke bawah
              ),
              itemBuilder: (context, index) {
                final item = transferReason[index];
                // Cek apakah item ini yang sedang dipilih
                final bool isSelected = transferParams.transferReason == item;
                return InkWell(
                  onTap: () {
                    setState(() {
                      transferParams.transferReason = item;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? CustomColorStyle.appBarBackground() : Colors.white,
                      borderRadius: BorderRadius.circular(9), 
                      border: Border.all(
                        color: CustomColorStyle.appBarBackground(),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: 
                      transferParams.transferReason == item?
                      CustomTextStyle.whiteStandard():
                      CustomTextStyle.blackSize(14),
                    ),
                  ),
                );
              },
            ),
            Text("Room Type", style: CustomTextStyle.blackStandard(),),
            isLoading == true?
              AddOnWidget.loading()
            :listAvailableRoomTypeResponse.state != true?
              AddOnWidget.error(listAvailableRoomTypeResponse.message)
            :listAvailableRoomType.isEmpty?
              AddOnWidget.empty():
            LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 
                    context.isLandscape && context.isDesktop?
                    5:
                    context.isTablet?3
                    :2,
                    crossAxisSpacing: 8, // Spasi antar kolom
                    mainAxisSpacing: 8, // Spasi antar baris
                    childAspectRatio: 10/3
                  ),
                  itemCount: listAvailableRoomType.length, 
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        transferParams.roomTypeDestination = listAvailableRoomType[index].roomType??'';
                        transferParams.invoice = detailRoom?.data?.invoice??'';
                        Navigator.pushNamed(context, ListRoomTransferPage.nameRoute, arguments: transferParams);
                      },
                      child: Container(
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AutoSizeText(listAvailableRoomType[index].roomType.toString(), style: CustomTextStyle.blackMedium(),  maxLines: 2, minFontSize: 12,),
                                        AutoSizeText('Room Ready ${listAvailableRoomType[index].roomAvailable.toString()}', style: CustomTextStyle.blackMediumSize(13),  maxLines: 1, minFontSize: 12,),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 19, color: Colors.green,)
                                ]),
                              ),
                    );
                  });
              }),
            
          ],
        ),
      ),
    );
  }
}