import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
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

  Future<void> getRoomCheckin(String search) async {
    roomCheckinResponse = await ApiRequest().getListRoomCheckin(search);
    if (roomCheckinResponse?.state != true) {
      showToastError(roomCheckinResponse?.message ?? 'Error get list room checkin');
    }
    setState(() {
      listRoomCheckin = (roomCheckinResponse?.data ?? [])
          .where((r) => r.summaryCode == '' && r.room != item.roomSource)
          .toList();
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    if (pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased) {
      isRestoOutlet = true;
    }
    getRoomCheckin('');
  }

  @override
  Widget build(BuildContext context) {
    item = ModalRoute.of(context)?.settings.arguments as MoveItemModel;

    final bool sideBySide = context.isDesktop ||
        (context.isLandscape && context.isTablet);

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: AutoSizeText(
          'Pindah Item',
          style: CustomTextStyle.titleAppBar(),
          maxLines: 1,
        ),
        backgroundColor: CustomColorStyle.appBarBackground(),
      ),
      body: roomCheckinResponse == null
          ? Center(
              child: CircularProgressIndicator(
                color: CustomColorStyle.appBarBackground(),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(context.isDesktop ? 16 : 10),
              child: sideBySide
                  ? _buildSideBySide(context)
                  : _buildStacked(context),
            ),
    );
  }

  // Desktop / tablet landscape: detail di kiri, grid room di kanan
  Widget _buildSideBySide(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.isDesktop ? context.wp(28) : context.wp(36),
          child: Column(
            children: [
              _buildDetailCard(context),
              const SizedBox(height: 12),
              _buildSearchBar(),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(child: _buildRoomGrid(context)),
      ],
    );
  }

  // Phone / tablet portrait: stacked
  Widget _buildStacked(BuildContext context) {
    return Column(
      children: [
        _buildDetailCard(context),
        const SizedBox(height: 10),
        _buildSearchBar(),
        const SizedBox(height: 10),
        Expanded(child: _buildRoomGrid(context)),
      ],
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.restaurant_menu_rounded,
                    color: Colors.blue.shade700, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'Detail Item',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.blue.shade50, height: 1),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.fastfood_outlined, 'Item', item.itemName),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.numbers_rounded, 'Qty', item.qty.toString()),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.table_restaurant_outlined, 'Dari Table', item.roomSource),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.receipt_long_outlined, 'Slip Order', item.slipOrderCode),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        SizedBox(
          width: 72,
          child: Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ),
        Text(': ', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
        Expanded(
          child: AutoSizeText(
            value,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
            maxLines: 2,
            minFontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      hintText: 'Cari room...',
      backgroundColor: WidgetStateProperty.all(Colors.white),
      surfaceTintColor: WidgetStateProperty.all(Colors.white),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      side: WidgetStateProperty.all(BorderSide(color: Colors.grey.shade300)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 14)),
      leading: Icon(Icons.search, color: Colors.grey.shade500),
      onChanged: (value) {
        searchRoom = value;
        getRoomCheckin(searchRoom);
      },
    );
  }

  Widget _buildRoomGrid(BuildContext context) {
    if (isNullOrEmpty(listRoomCheckin) && isNullOrEmpty(searchRoom)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset('assets/animation/empty.json',
                height: 180, width: 180),
            const SizedBox(height: 10),
            Text('Tidak ada room tersedia', style: CustomTextStyle.blackMedium()),
          ],
        ),
      );
    }

    if (isNullOrEmpty(listRoomCheckin)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 52, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text('Room tidak ditemukan',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final double w = constraints.maxWidth;
        final int columns =
            ctx.isDesktop && ctx.isLandscape ? 5 :
            ctx.isDesktop ? 4 :
            ctx.isLandscape && ctx.isTablet ? 4 :
            ctx.isLandscape ? 3 :
            ctx.isTablet ? 3 : 2;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: w > 650 ? 5 / 2 : 5 / 2.4,
          ),
          itemCount: listRoomCheckin.length,
          itemBuilder: (context, index) =>
              _buildRoomCard(context, listRoomCheckin[index]),
        );
      },
    );
  }

  Widget _buildRoomCard(BuildContext context, ListRoomCheckinModel roomData) {
    return InkWell(
      onTap: () async {
        final isConfirmed = await ConfirmationDialog.confirmation(
          context,
          'Pindahkan item ${item.itemName} ke ${roomData.room}?',
        );
        if (isConfirmed) {
          final moveState = await ApiRequest().moveItem(item, roomData.room);
          if (moveState.state == true) {
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, MainPage.nameRoute, (route) => false);
            }
          } else {
            showToastError('Gagal memindahkan item');
          }
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  roomData.room,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  minFontSize: 11,
                ),
                if (!isNullOrEmpty(roomData.memberName)) ...[
                  const SizedBox(height: 2),
                  AutoSizeText(
                    roomData.memberName,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400),
                    maxLines: 1,
                    minFontSize: 8,
                  ),
                ],
              ],
            ),
            if (isRestoOutlet && roomData.printState != '0')
              Positioned(
                right: 0,
                bottom: 0,
                child: Transform.rotate(
                  angle: -0.2,
                  child: AutoSizeText(
                    'Print Bill',
                    style: GoogleFonts.poppins(
                      color: Colors.deepOrange,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    minFontSize: 8,
                    maxLines: 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
