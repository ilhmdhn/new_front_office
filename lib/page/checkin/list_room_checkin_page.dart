import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/core/extention/extention.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/enum/pos_type.dart';
import 'package:front_office_2/data/model/room_checkin_response.dart';
import 'package:front_office_2/data/model/transfer_params.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/bill/bill_page.dart';
import 'package:front_office_2/page/checkin/edit_checkin_page.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/dialog/rating_dialog.dart';
import 'package:front_office_2/page/extend/extend_room_page.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/order/fnb_main_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/transfer/reason_transfer_page.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool isRestoOutlet = false;
  final pos = GlobalProviders.read(posTypeProvider);



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
        if(isRestoOutlet){
          listRoomCheckin = listRoomCheckin.where((item) => item.summaryCode == '').toList();
        }else{
          listRoomCheckin = listRoomCheckin.where((item) => item.printState == '0' && item.summaryCode == '').toList();
        }
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
  void initState() {
    super.initState();
    if(pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased){
      isRestoOutlet = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    destination = ModalRoute.of(context)!.settings.arguments as int;
    if (destination != 0 && isLoaded == false) {
      getRoomCheckin('');
    }

    final isDesktopLandscape = context.isDesktop && context.isLandscape;

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body: Column(
        children: [
          // Custom Header
          _buildHeader(context, isDesktopLandscape),
          // Body
          Expanded(
            child: roomCheckinResponse == null
                ? _buildLoadingState()
                : isNullOrEmpty(listRoomCheckin) && isNullOrEmpty(searchRoom)
                    ? _buildEmptyState()
                    : _buildContent(context, isDesktopLandscape),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktopLandscape) {
    IconData headerIcon;
    String subtitle;

    switch (destination) {
      case 1:
      case 2:
      case 3:
      case 4:
        headerIcon = Icons.meeting_room;
        subtitle = 'Pilih room untuk melanjutkan';
        break;
      case 5:
        headerIcon = Icons.payment;
        subtitle = 'Room siap untuk pembayaran';
        break;
      case 6:
        headerIcon = Icons.logout;
        subtitle = 'Room siap untuk checkout';
        break;
      case 7:
        headerIcon = Icons.cleaning_services;
        subtitle = 'Room perlu dibersihkan';
        break;
      default:
        headerIcon = Icons.meeting_room;
        subtitle = '';
    }

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + (isDesktopLandscape ? 12 : 8),
        bottom: isDesktopLandscape ? 16 : 12,
        left: isDesktopLandscape ? 24 : 16,
        right: isDesktopLandscape ? 24 : 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [CustomColorStyle.bluePrimary(), CustomColorStyle.bluePrimary().withAlpha(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColorStyle.bluePrimary().withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(headerIcon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appBarTitle.isEmpty ? 'List Room' : appBarTitle,
                  style: GoogleFonts.poppins(
                    fontSize: isDesktopLandscape ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                  ),
              ],
            ),
          ),
          // Room Count Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.door_front_door, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${listRoomCheckin.length}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 20)],
        ),
        child: CircularProgressIndicator(color: CustomColorStyle.bluePrimary()),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset('assets/animation/empty.json', height: 200, width: 200),
          const SizedBox(height: 16),
          Text(
            'Tidak Ada Room',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 4),
          Text(
            'Belum ada room yang tersedia',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDesktopLandscape) {
    return Padding(
      padding: EdgeInsets.all(isDesktopLandscape ? 20 : 12),
      child: Column(
        children: [
          // Search Bar
          _buildSearchBar(isDesktopLandscape),
          const SizedBox(height: 16),
          // Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktopLandscape ? 5 : (context.isLandscape ? 3 : 2),
                crossAxisSpacing: isDesktopLandscape ? 16 : 10,
                mainAxisSpacing: isDesktopLandscape ? 16 : 10,
                childAspectRatio: isDesktopLandscape ? 1.8 : (context.isLandscape ? 1.6 : 1.4),
              ),
              itemCount: listRoomCheckin.length,
              itemBuilder: (context, index) {
                final roomData = listRoomCheckin[index];
                return _buildRoomCard(context, roomData, isDesktopLandscape);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDesktopLandscape) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          searchRoom = value;
          getRoomCheckin(searchRoom);
        },
        decoration: InputDecoration(
          hintText: isRestoOutlet ? 'Cari Table...' : 'Cari Room...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: CustomColorStyle.bluePrimary()),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isDesktopLandscape ? 16 : 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, ListRoomCheckinModel roomData, bool isDesktopLandscape) {
    // Calculate remaining time
    String remainingText = 'WAKTU HABIS';
    bool isTimeExpired = true;

    if (roomData.remainHour > 0 || roomData.remainMinute > 0) {
      isTimeExpired = false;
      remainingText = 'Sisa';
      if (roomData.remainHour > 0) {
        remainingText += ' ${roomData.remainHour}j';
      }
      if (roomData.remainMinute > 0) {
        remainingText += ' ${roomData.remainMinute}m';
      }
    }

    Color cardColor = isTimeExpired && !isRestoOutlet ? Colors.red.shade50 : Colors.white;
    Color accentColor = isTimeExpired && !isRestoOutlet ? Colors.red : CustomColorStyle.bluePrimary();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => movePage(destination, roomData.room),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isDesktopLandscape ? 14 : 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isTimeExpired && !isRestoOutlet ? Colors.red.shade200 : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Number & Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AutoSizeText(
                        roomData.room,
                        style: GoogleFonts.poppins(
                          fontSize: isDesktopLandscape ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                        maxLines: 1,
                        minFontSize: 12,
                      ),
                    ),
                  ),
                  if (destination == 6)
                    InkWell(
                      onTap: () => RatingDialog.submitRate(
                        context,
                        roomData.summaryCode,
                        roomData.memberName,
                        roomData.memberName,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.star_rate, size: 18, color: Colors.amber),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              // Print Bill Badge (for resto)
              if (isRestoOutlet && roomData.printState != '0')
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Text(
                      'Print Bill',
                      style: GoogleFonts.poppins(
                        color: Colors.deepOrange,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              // Member Name & Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    roomData.memberName,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    minFontSize: 9,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isRestoOutlet)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isTimeExpired ? Colors.red.shade100 : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: isTimeExpired ? Colors.red.shade700 : Colors.green.shade700,
                          ),
                          const SizedBox(width: 4),
                          AutoSizeText(
                            remainingText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isTimeExpired ? Colors.red.shade700 : Colors.green.shade700,
                            ),
                            maxLines: 1,
                            minFontSize: 8,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void movePage(int code, String roomCode)async{
    if(code == 1 && isNotNullOrEmpty(roomCode)){
      Navigator.pushNamed(context, EditCheckinPage.nameRoute, arguments: roomCode);
    }

    if(code == 2 && isNotNullOrEmpty(roomCode)){
      Navigator.pushNamed(context, ExtendRoomPage.nameRoute, arguments: roomCode);
    }

    if(code == 3 && isNotNullOrEmpty(roomCode)){
      TransferParams transferParams = TransferParams(
        oldRoom: roomCode,
        pax: listRoomCheckin.firstWhere((element) => element.room == roomCode).pax
      );
      Navigator.pushNamed(context, TransferReasonPage.nameRoute, arguments: transferParams);
    }

    if(code == 4 && isNotNullOrEmpty(roomCode)){
      Navigator.pushNamed(context, FnbMainPage.nameRoute, arguments: roomCode);
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