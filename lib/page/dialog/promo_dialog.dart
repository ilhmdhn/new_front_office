import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoDialog {
  Future<PromoRoomModel?> setPromoRoom(BuildContext ctx, String roomType) async {
    bool isProcess = false;
    Completer<PromoRoomModel?> completer = Completer<PromoRoomModel?>();

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        PromoRoomResponse promoRoomResponse = PromoRoomResponse();
        final isDesktopLandscape = context.isDesktop && context.isLandscape;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void getPromoRoomData(roomType) async {
              promoRoomResponse = await ApiRequest().getPromoRoom(roomType);
              if (context.mounted) {
                if (promoRoomResponse.state == true) {
                  setState(() {});
                } else {
                  showToastError(promoRoomResponse.message ?? 'Error get Promo Room Data');
                  Navigator.pop(context);
                }
              }
            }

            if (isProcess == false) {
              getPromoRoomData(roomType);
              isProcess = true;
            }

            List<PromoRoomModel> promoRoomList = promoRoomResponse.data;

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(isDesktopLandscape ? 40 : 20),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktopLandscape ? 600 : 500,
                  maxHeight: isDesktopLandscape ? context.height * 0.8 : context.height * 0.7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    _buildPromoHeader(
                      context: context,
                      title: 'Promo Room',
                      subtitle: 'Pilih promo untuk kamar',
                      icon: Icons.meeting_room,
                      color: Colors.orange,
                    ),
                    // Content
                    Flexible(
                      child: promoRoomResponse.isLoading == true
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: CircularProgressIndicator(color: Colors.orange.shade600),
                              ),
                            )
                          : promoRoomList.isEmpty
                              ? _buildEmptyState('Tidak ada promo room tersedia')
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(16),
                                  itemCount: promoRoomList.length,
                                  itemBuilder: (context, index) {
                                    final dataPromo = promoRoomList[index];
                                    return _buildPromoRoomCard(context, dataPromo, Colors.orange);
                                  },
                                ),
                    ),
                    // Footer
                    _buildDialogFooter(context),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) => completer.complete(value));
    return completer.future;
  }

  Widget _buildPromoHeader({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required MaterialColor color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.shade600, color.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoRoomCard(BuildContext context, PromoRoomModel dataPromo, MaterialColor color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context, dataPromo),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.shade200),
              boxShadow: [
                BoxShadow(
                  color: color.shade100.withAlpha(100),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.local_offer, color: color.shade700, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        dataPromo.promoName ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: color.shade900,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: color.shade400, size: 16),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if ((dataPromo.promoPercent ?? 0) > 0)
                      _buildPromoChip('${dataPromo.promoPercent}%', Icons.percent, color),
                    if ((dataPromo.promoIdr ?? 0) > 0)
                      _buildPromoChip(Formatter.formatRupiah(dataPromo.promoIdr ?? 0), Icons.payments, color),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      AutoSizeText(
                        '${dataPromo.timeStart} - ${dataPromo.timeFinish}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                        minFontSize: 9,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoChip(String label, IconData icon, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color.shade700),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color.shade800, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Batal'),
        ),
      ),
    );
  }

Future<PromoFnbModel?> setPromoFnb(BuildContext ctx, String roomType, String roomCode) async {
    bool isProcess = false;
    Completer<PromoFnbModel?> completer = Completer<PromoFnbModel?>();
    PromoFnbResponse promoFnbResponse = PromoFnbResponse();
    List<PromoFnbModel> listPromoFnb = [];

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final isDesktopLandscape = context.isDesktop && context.isLandscape;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void getPromoFnbData(String roomType, String roomCode) async {
              promoFnbResponse = await ApiRequest().getPromoFnB(roomType, roomCode);
              if (context.mounted) {
                if (promoFnbResponse.state == true) {
                  listPromoFnb = promoFnbResponse.data;
                  setState(() {});
                } else {
                  showToastError(promoFnbResponse.message ?? 'Error get promo fnb');
                  Navigator.pop(context);
                }
              }
            }

            if (!isProcess) {
              getPromoFnbData('PR A', 'PR A');
              isProcess = true;
            }

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(isDesktopLandscape ? 40 : 20),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktopLandscape ? 600 : 500,
                  maxHeight: isDesktopLandscape ? context.height * 0.8 : context.height * 0.7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    _buildPromoHeader(
                      context: context,
                      title: 'Promo FnB',
                      subtitle: 'Pilih promo makanan & minuman',
                      icon: Icons.restaurant,
                      color: Colors.green,
                    ),
                    // Content
                    Flexible(
                      child: promoFnbResponse.isLoading == true
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: CircularProgressIndicator(color: Colors.green.shade600),
                              ),
                            )
                          : listPromoFnb.isEmpty
                              ? _buildEmptyState('Tidak ada promo FnB tersedia')
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(16),
                                  itemCount: listPromoFnb.length,
                                  itemBuilder: (context, index) {
                                    final promoData = listPromoFnb[index];
                                    return _buildPromoFnbCard(context, promoData, Colors.green);
                                  },
                                ),
                    ),
                    // Footer
                    _buildDialogFooter(context),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) => completer.complete(value));
    return completer.future;
  }

  Widget _buildPromoFnbCard(BuildContext context, PromoFnbModel promoData, MaterialColor color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context, promoData),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.shade200),
              boxShadow: [
                BoxShadow(
                  color: color.shade100.withAlpha(100),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.fastfood, color: color.shade700, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        promoData.promoName ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: color.shade900,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: color.shade400, size: 16),
                  ],
                ),
                if ((promoData.promoPercent ?? 0) > 0 || (promoData.promoIdr ?? 0) > 0) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      if ((promoData.promoPercent ?? 0) > 0)
                        _buildPromoChip('${promoData.promoPercent}%', Icons.percent, color),
                      if ((promoData.promoIdr ?? 0) > 0)
                        _buildPromoChip(Formatter.formatRupiah(promoData.promoIdr ?? 0), Icons.payments, color),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
