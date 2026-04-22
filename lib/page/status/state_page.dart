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
    if (mounted) setState(() {});
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
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  // ── HEADER ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final bool large = context.isDesktop || context.isLandscape;
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + (large ? 12 : 8),
        bottom: large ? 16 : 12,
        left: large ? 24 : 16,
        right: large ? 24 : 16,
      ),
      color: CustomColorStyle.appBarBackground(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.monitor_heart_outlined,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status Checkin',
                    style: GoogleFonts.poppins(
                        fontSize: large ? 19 : 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text('Monitor status room aktif',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.door_front_door,
                    color: Colors.white, size: 15),
                const SizedBox(width: 5),
                Text('${filteredData.length}',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BODY ────────────────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context) {
    if (data == null) {
      return Center(
          child: CircularProgressIndicator(
              color: CustomColorStyle.appBarBackground()));
    }
    if (data?.state == false) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
          const SizedBox(height: 12),
          Text(data?.message ?? 'Gagal memuat data',
              style: GoogleFonts.poppins(
                  fontSize: 15, color: Colors.grey.shade700)),
        ]),
      );
    }
    if (isNullOrEmpty(data?.data)) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          LottieBuilder.asset('assets/animation/empty.json',
              height: 180, width: 180),
          const SizedBox(height: 12),
          Text('Tidak Ada Room Aktif',
              style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700)),
          const SizedBox(height: 4),
          Text('Belum ada room yang sedang checkin',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: Colors.grey.shade500)),
        ]),
      );
    }

    final double pad = context.isDesktop ? 20 : 12;
    final bool useGrid =
        context.isDesktop || context.isTablet || context.isLandscape;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(pad, pad, pad, 10),
          child: _buildSearchBar(context),
        ),
        Expanded(
          child: useGrid
              ? _buildGrid(context, pad)
              : _buildList(context, pad),
        ),
      ],
    );
  }

  // ── SEARCH ───────────────────────────────────────────────────────────────────
  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      onChanged: (v) => setState(() => searchQuery = v),
      decoration: InputDecoration(
        hintText: 'Cari room atau guest...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon:
            Icon(Icons.search, color: CustomColorStyle.appBarBackground()),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: CustomColorStyle.appBarBackground(), width: 1.5)),
      ),
    );
  }

  // ── LIST (phone portrait) ────────────────────────────────────────────────────
  Widget _buildList(BuildContext context, double pad) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(pad, 0, pad, pad),
      itemCount: filteredData.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _buildListTile(filteredData[i]),
    );
  }

  Widget _buildListTile(RoomCheckinStateModel room) {
    final bool isBilled = room.state != '0';
    final Color accent =
        isBilled ? Colors.orange.shade600 : CustomColorStyle.appBarBackground();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: accent, width: 5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AutoSizeText(
                  room.room,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                  maxLines: 1,
                  minFontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              _statusBadge(isBilled),
            ],
          ),
          const SizedBox(height: 4),
          _infoRow(Icons.person_outline, room.guest),
          const SizedBox(height: 2),
          _infoRow(Icons.access_time, room.timeRemain),
          const SizedBox(height: 8),
          _orderChips(room),
        ],
      ),
    );
  }

  // ── GRID (tablet / landscape / desktop) ──────────────────────────────────────
  Widget _buildGrid(BuildContext context, double pad) {
    final int columns = context.isDesktop && context.isLandscape
        ? 4
        : context.isDesktop
            ? 3
            : context.isLandscape
                ? 3
                : 2;

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(pad, 0, pad, pad),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: context.isDesktop && context.isLandscape
            ? 2.0
            : context.isDesktop
                ? 1.8
                : 1.9,
      ),
      itemCount: filteredData.length,
      itemBuilder: (_, i) => _buildGridCard(filteredData[i]),
    );
  }

  Widget _buildGridCard(RoomCheckinStateModel room) {
    final bool isBilled = room.state != '0';
    final Color accent =
        isBilled ? Colors.orange.shade600 : CustomColorStyle.appBarBackground();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top accent bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              border: Border(top: BorderSide(color: accent, width: 3)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AutoSizeText(
                    room.room,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                    maxLines: 1,
                    minFontSize: 10,
                  ),
                ),
                const SizedBox(width: 6),
                _statusBadge(isBilled),
              ],
            ),
          ),
          // body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(Icons.person_outline, room.guest),
                      const SizedBox(height: 3),
                      _infoRow(Icons.access_time, room.timeRemain),
                    ],
                  ),
                  _orderChips(room),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── SHARED HELPERS ───────────────────────────────────────────────────────────
  Widget _statusBadge(bool isBilled) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isBilled ? Colors.orange.shade100 : Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isBilled ? 'Bill' : 'Checkin',
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isBilled ? Colors.orange.shade800 : Colors.green.shade800),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Expanded(
          child: AutoSizeText(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            maxLines: 1,
            minFontSize: 9,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _orderChips(RoomCheckinStateModel room) {
    final chips = <Widget>[];
    if (room.so > 0) { chips.add(_chip('SO ${room.so}', Colors.green.shade700, Colors.green.shade50)); }
    if (room.process > 0) { chips.add(_chip('Proses ${room.process}', Colors.amber.shade800, Colors.amber.shade50)); }
    if (room.delivery > 0) { chips.add(_chip('Kirim ${room.delivery}', Colors.blue.shade700, Colors.blue.shade50)); }
    if (room.cancel > 0) { chips.add(_chip('Batal ${room.cancel}', Colors.red.shade700, Colors.red.shade50)); }
    if (chips.isEmpty) { chips.add(_chip('No Order', Colors.grey.shade500, Colors.grey.shade100)); }

    return Wrap(spacing: 5, runSpacing: 4, children: chips);
  }

  Widget _chip(String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor)),
    );
  }
}
