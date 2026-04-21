import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/model/status_room_checkin.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class StatePage extends StatefulWidget {
  static const nameRoute = '/history';
  const StatePage({super.key});

  @override
  State<StatePage> createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  RoomCheckinState? data;
  String searchQuery = '';

  void getData() async {
    if (data != null) return;

    data = await ApiRequest().checkinState();
    if (mounted) {
      setState(() {});
    }
  }

  List<RoomCheckinStateModel> get filteredData {
    if (data?.data == null) return [];
    if (searchQuery.isEmpty) return data!.data!;
    return data!.data!.where((room) {
      return room.room.toLowerCase().contains(searchQuery.toLowerCase()) ||
          room.guest.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    getData();

    final isDesktopLandscape = context.isDesktop && context.isLandscape;

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body: Column(
        children: [
          _buildHeader(context, isDesktopLandscape),
          Expanded(
            child: data == null
                ? _buildLoadingState()
                : data?.state == false
                    ? _buildErrorState()
                    : isNullOrEmpty(data?.data)
                        ? _buildEmptyState()
                        : _buildContent(context, isDesktopLandscape),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktopLandscape) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + (isDesktopLandscape ? 12 : 8),
        bottom: isDesktopLandscape ? 16 : 12,
        left: isDesktopLandscape ? 24 : 16,
        right: isDesktopLandscape ? 24 : 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade700, Colors.purple.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade700.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.monitor_heart_outlined, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Checkin',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktopLandscape ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Monitor status room aktif',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.door_front_door, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${filteredData.length}',
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
        child: CircularProgressIndicator(color: Colors.purple.shade600),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            data?.message ?? 'Error loading data',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset('assets/animation/empty.json', height: 180, width: 180),
          const SizedBox(height: 16),
          Text(
            'Tidak Ada Room Aktif',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 4),
          Text(
            'Belum ada room yang sedang checkin',
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate optimal columns based on available width
                int crossAxisCount;
                double childAspectRatio;

                if (isDesktopLandscape) {
                  crossAxisCount = constraints.maxWidth > 1200 ? 4 : 3;
                  childAspectRatio = 1.6;
                } else if (context.isLandscape) {
                  crossAxisCount = 2;
                  childAspectRatio = 2.2;
                } else {
                  crossAxisCount = 1;
                  childAspectRatio = 2.5;
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: isDesktopLandscape ? 16 : 10,
                    mainAxisSpacing: isDesktopLandscape ? 16 : 10,
                  ),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final room = filteredData[index];
                    return _buildRoomCard(room, isDesktopLandscape);
                  },
                );
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
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Cari room atau guest...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: Colors.purple.shade600),
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

  Widget _buildRoomCard(RoomCheckinStateModel room, bool isDesktopLandscape) {
    final bool isBilled = room.state != '0';
    final bool hasOrders = room.so > 0 || room.process > 0 || room.delivery > 0 || room.cancel > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBilled ? Colors.orange.shade200 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Section - Room Info
          Expanded(
            child: Container(
              padding: EdgeInsets.all(isDesktopLandscape ? 16 : 12),
              decoration: BoxDecoration(
                color: isBilled ? Colors.orange.shade50 : Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Room Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isBilled ? Colors.orange.shade400 : Colors.blue.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.meeting_room,
                          size: isDesktopLandscape ? 18 : 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AutoSizeText(
                          room.room,
                          style: GoogleFonts.poppins(
                            fontSize: isDesktopLandscape ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: isBilled ? Colors.orange.shade800 : Colors.blue.shade800,
                          ),
                          maxLines: 1,
                          minFontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Guest
                  _buildInfoRow(Icons.person_outline, room.guest, Colors.grey.shade700, isDesktopLandscape),
                  const SizedBox(height: 4),
                  // Time
                  _buildInfoRow(Icons.access_time, room.timeRemain, Colors.grey.shade600, isDesktopLandscape),
                  const SizedBox(height: 6),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isBilled ? Colors.orange.shade100 : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isBilled ? 'Bill' : 'Checkin',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isBilled ? Colors.orange.shade800 : Colors.green.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Divider
          Container(width: 1, color: Colors.grey.shade200),
          // Right Section - Order Info
          Expanded(
            child: Container(
              padding: EdgeInsets.all(isDesktopLandscape ? 16 : 12),
              child: hasOrders
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Order Info',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildOrderRow('Order', room.so, Colors.green, Icons.inventory_outlined, isDesktopLandscape),
                        const SizedBox(height: 4),
                        _buildOrderRow('Process', room.process, Colors.amber, Icons.sync, isDesktopLandscape),
                        const SizedBox(height: 4),
                        _buildOrderRow('Delivery', room.delivery, Colors.blue, Icons.done_all, isDesktopLandscape),
                        const SizedBox(height: 4),
                        _buildOrderRow('Cancel', room.cancel, Colors.red, Icons.close, isDesktopLandscape),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieBuilder.asset(
                            'assets/animation/zxz.json',
                            height: isDesktopLandscape ? 60 : 50,
                            width: isDesktopLandscape ? 60 : 50,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No Orders',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color, bool isDesktop) {
    return Row(
      children: [
        Icon(icon, size: isDesktop ? 14 : 12, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: AutoSizeText(
            text,
            style: TextStyle(fontSize: isDesktop ? 13 : 12, color: color),
            maxLines: 1,
            minFontSize: 9,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderRow(String label, int count, Color color, IconData icon, bool isDesktop) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: isDesktop ? 14 : 12, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: isDesktop ? 12 : 11, color: Colors.grey.shade700),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: count > 0 ? color.withAlpha(30) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: isDesktop ? 12 : 11,
              fontWeight: FontWeight.bold,
              color: count > 0 ? color : Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }
}
