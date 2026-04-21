import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/enum/pos_type.dart';
import 'package:front_office_2/data/model/checkin_body.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/promo_fnb_response.dart';
import 'package:front_office_2/data/model/promo_room_response.dart';
import 'package:front_office_2/data/model/verification_result_model.dart';
import 'package:front_office_2/data/model/voucher_member_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/dialog/promo_dialog.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/dialog/verification_dialog.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';
class EditCheckinPage extends StatefulWidget {
  static const nameRoute = '/edit-checkin';
  const EditCheckinPage({super.key});

  @override
  State<EditCheckinPage> createState() => _EditCheckinPageState();
}

class _EditCheckinPageState extends State<EditCheckinPage> {
  int pax = 1;
  int dpCode = 1;
  bool isLoading = true;
  String chooseEdc = '';
  String chooseCardType = '';
  PromoRoomModel? promoRoom;
  PromoFnbModel? promoFnb;
  DetailCheckinResponse? detailRoom;
  String roomCode = '';
  bool hasModified = false;
  DetailCheckinModel? dataCheckin;
  String remainingTime = 'Waktu Habis';
  bool approvalPromoRoomState = false;
  String chooseEdcName = '';
  String cardTypeName = "";
  String dpNote = "";
  String edcCode = "";
  bool showEditName = false;
  VoucherMemberModel? voucherDetail;
  final posType = GlobalProviders.read(posTypeProvider);

  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventController = TextEditingController();
  TextEditingController custNameController = TextEditingController();
  VoucherDetail? voucherFix;

  void getData()async{
    detailRoom = await ApiRequest().getDetailRoomCheckin(roomCode);
    if(detailRoom?.state != true){
      showToastError(detailRoom?.message??'Error get room info');
    }

    if(detailRoom?.data?.vcrDetail != null){
      voucherFix = detailRoom!.data!.vcrDetail!;
    }

    isLoading = false;
    setState(() {
      isLoading;
      voucherFix;
      detailRoom;
      dataCheckin = detailRoom?.data;
    });
  }
  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    if (roomCode != '' && detailRoom == null) {
      getData();
    }
    if (isLoading == false && hasModified == false) {
      promoRoom = dataCheckin?.promoRoom;
      promoFnb = dataCheckin?.promoFnb;
      pax = dataCheckin?.pax ?? 1;
      hasModified = true;
    }

    int hourRemaining = (dataCheckin?.hourRemaining ?? 0);
    int minuteRemaining = (dataCheckin?.minuteRemaining ?? 0);

    if (hourRemaining > 0 || minuteRemaining > 0) {
      remainingTime = 'Sisa';
      if (hourRemaining > 0) remainingTime += ' $hourRemaining Jam';
      if (minuteRemaining > 0) remainingTime += ' $minuteRemaining Menit';
    }

    descriptionController.text = detailRoom?.data?.description ?? '';
    eventController.text = detailRoom?.data?.guestNotes ?? '';
    edcCode = detailRoom?.data?.edcMachine ?? '';
    dpNote = detailRoom?.data?.dpNote ?? '';
    cardTypeName = detailRoom?.data?.cardType ?? '';

    final pos = GlobalProviders.read(posTypeProvider);
    final isDesktopLandscape = context.isDesktop && context.isLandscape;

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body: isLoading
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 20)],
                ),
                child: CircularProgressIndicator(color: CustomColorStyle.bluePrimary()),
              ),
            )
          : detailRoom?.state != true
              ? Center(child: Text(detailRoom?.message ?? 'Error get Room Info'))
              : isDesktopLandscape
                  ? _buildDesktopLandscapeLayout(pos)
                  : _buildDefaultLayout(pos),
    );
  }

  Widget _buildDesktopLandscapeLayout(PosType pos) {
    return Column(
      children: [
        // Custom Header
        _buildDesktopHeader(),
        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Panel - Info & Pax
                Expanded(
                  flex: 1,
                  child: _buildLeftPanel(pos),
                ),
                const SizedBox(width: 20),
                // Right Panel - Promo & Notes
                Expanded(
                  flex: 1,
                  child: _buildRightPanel(pos),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [CustomColorStyle.bluePrimary(), CustomColorStyle.bluePrimary().withAlpha(200)],
        ),
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
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.edit_note, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Check-in', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('${dataCheckin?.roomCode ?? ''} • ${dataCheckin?.memberName ?? ''}',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(remainingTime, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftPanel(PosType pos) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Panel Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: CustomColorStyle.bluePrimary(), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Informasi Checkin', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Info Card
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    title: pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased ? 'Customer' : 'Member',
                    value: dataCheckin?.memberName ?? '',
                    subtitle: pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased ? null : dataCheckin?.memberCode,
                    showEdit: pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased,
                    onEdit: () => setState(() => showEditName = !showEditName),
                  ),
                  if (showEditName) _buildEditNameField(),
                  const SizedBox(height: 16),
                  // Room Info Card
                  _buildInfoCard(
                    icon: Icons.meeting_room_outlined,
                    title: pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased ? 'Table' : 'Room',
                    value: dataCheckin?.roomCode ?? '',
                    subtitle: pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased ? null : remainingTime,
                  ),
                  const SizedBox(height: 24),
                  // Pax Section
                  _buildPaxSection(),
                  const SizedBox(height: 24),
                  // Voucher Section (only for karaoke)
                  if (pos != PosType.restoOnlyOld && pos != PosType.restoOnlyWebBased) _buildVoucherSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel(PosType pos) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Panel Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.local_offer, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Promo & Catatan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange.shade900)),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Promo Room (only for karaoke)
                  if (pos != PosType.restoOnlyOld && pos != PosType.restoOnlyWebBased) _buildPromoRoomSection(),
                  // Promo FnB
                  _buildPromoFnbSection(),
                  const SizedBox(height: 20),
                  // Notes Fields
                  _buildNotesSection(),
                ],
              ),
            ),
          ),
          // Save Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildSaveButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    bool showEdit = false,
    VoidCallback? onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: CustomColorStyle.bluePrimary().withAlpha(20), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: CustomColorStyle.bluePrimary(), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                if (subtitle != null) Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
          ),
          if (showEdit)
            IconButton(
              onPressed: onEdit,
              icon: Icon(Icons.edit, color: CustomColorStyle.bluePrimary(), size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildEditNameField() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          TextField(
            controller: custNameController,
            decoration: InputDecoration(
              hintText: 'Nama customer baru...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => setState(() => showEditName = false), child: const Text('Batal')),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  if (isNotNullOrEmpty(custNameController.text)) {
                    if (custNameController.text.length > 25) {
                      showToastWarning('Maksimal 25 karakter');
                      return;
                    }
                    final state = await ConfirmationDialog.confirmation(context, 'Ubah nama customer?');
                    if (!state) return;
                    setState(() {
                      showEditName = false;
                      isLoading = true;
                    });
                    await ApiRequest().editName(dataCheckin!.reception, custNameController.text);
                    getData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColorStyle.bluePrimary(),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaxSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.green.shade50, Colors.green.shade100.withAlpha(50)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.green.shade400, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.groups, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jumlah Pengunjung', style: TextStyle(fontSize: 12, color: Colors.green.shade700)),
                Text('$pax orang', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
              ],
            ),
          ),
          Row(
            children: [
              _buildPaxButton(Icons.remove, () => setState(() { if (pax > 1) pax--; })),
              Container(
                constraints: const BoxConstraints(minWidth: 40),
                alignment: Alignment.center,
                child: Text('$pax', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              _buildPaxButton(Icons.add, () => setState(() => pax++)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaxButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: CustomColorStyle.bluePrimary(), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Voucher Puppy Club', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
        const SizedBox(height: 12),
        if (voucherFix == null)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _scanVoucher(),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Voucher'),
              style: OutlinedButton.styleFrom(
                foregroundColor: CustomColorStyle.bluePrimary(),
                side: BorderSide(color: CustomColorStyle.bluePrimary()),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          )
        else
          _buildVoucherCard(),
      ],
    );
  }

  Widget _buildVoucherCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple.shade50, Colors.purple.shade100.withAlpha(50)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.confirmation_number, color: Colors.purple.shade600, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(voucherFix?.code ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.purple.shade800))),
              InkWell(
                onTap: () => _removeVoucher(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(6)),
                  child: Text('Hapus', style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if ((voucherFix?.hour ?? 0) > 0) _buildVoucherChip('${voucherFix?.hour} Jam', Icons.access_time),
              if ((voucherFix?.hourPrice ?? 0) > 0) _buildVoucherChip(Formatter.formatRupiah(voucherFix?.hourPrice ?? 0), Icons.meeting_room),
              if ((voucherFix?.hourPercent ?? 0) > 0) _buildVoucherChip('Room ${voucherFix?.hourPercent}%', Icons.percent),
              if ((voucherFix?.item ?? '').trim().isNotEmpty) _buildVoucherChip('${voucherFix?.item}', Icons.fastfood),
              if ((voucherFix?.itemPrice ?? 0) > 0) _buildVoucherChip(Formatter.formatRupiah(voucherFix?.itemPrice ?? 0), Icons.restaurant),
              if ((voucherFix?.itemPercent ?? 0) > 0) _buildVoucherChip('FnB ${voucherFix?.itemPercent}%', Icons.percent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.purple.shade200)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.purple.shade600),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.purple.shade800, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPromoRoomSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Promo Room', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
        const SizedBox(height: 10),
        if (promoRoom == null)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final result = await PromoDialog().setPromoRoom(context, detailRoom?.data?.roomType ?? '');
                if (result != null) setState(() => promoRoom = result);
              },
              icon: const Icon(Icons.add),
              label: const Text('Pilih Promo Room'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange.shade700,
                side: BorderSide(color: Colors.orange.shade300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          )
        else
          _buildPromoCard(
            title: promoRoom?.promoName ?? '',
            value: '${(promoRoom?.promoPercent ?? 0) > 0 ? '${promoRoom?.promoPercent}%' : ''} ${(promoRoom?.promoIdr ?? 0) > 0 ? Formatter.formatRupiah((promoRoom?.promoIdr ?? 0).toInt()) : ''}',
            time: '${promoRoom?.timeStart} - ${promoRoom?.timeFinish}',
            color: Colors.orange,
            onRemove: () => _removePromoRoom(),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPromoFnbSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Promo FnB', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
        const SizedBox(height: 10),
        if (promoFnb == null)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final choosePromo = await PromoDialog().setPromoFnb(context, 'PR A', 'PR A');
                if (choosePromo != null) {
                  final addPromoFnb = await ApiRequest().addPromo(detailRoom?.data?.invoice ?? '', choosePromo.promoName ?? '');
                  if (addPromoFnb.state == true) setState(() => promoFnb = choosePromo);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Pilih Promo FnB'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green.shade700,
                side: BorderSide(color: Colors.green.shade300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          )
        else
          _buildPromoCard(
            title: promoFnb?.promoName ?? '',
            value: '${(promoFnb?.promoPercent ?? 0) > 0 ? '${promoFnb?.promoPercent}%' : ''} ${(promoFnb?.promoIdr ?? 0) > 0 ? Formatter.formatRupiah((promoFnb?.promoIdr ?? 0).toInt()) : ''}',
            color: Colors.green,
            onRemove: () => _removePromoFnb(),
          ),
      ],
    );
  }

  Widget _buildPromoCard({required String title, required String value, String? time, required MaterialColor color, required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.shade50, color.shade100.withAlpha(50)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, color: color.shade600, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: color.shade800))),
              InkWell(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(6)),
                  child: Text('Hapus', style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value.trim(), style: TextStyle(fontSize: 14, color: color.shade700, fontWeight: FontWeight.w500)),
          if (time != null) ...[
            const SizedBox(height: 4),
            Text('Berlaku: $time', style: TextStyle(fontSize: 12, color: color.shade600)),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Keterangan', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
        const SizedBox(height: 8),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            hintText: 'Tambahkan keterangan...',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
        const SizedBox(height: 16),
        Text('Acara', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
        const SizedBox(height: 8),
        TextField(
          controller: eventController,
          decoration: InputDecoration(
            hintText: 'Nama acara...',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _saveCheckin(),
        icon: const Icon(Icons.save),
        label: const Text('SIMPAN PERUBAHAN'),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColorStyle.bluePrimary(),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Helper methods for actions
  Future<void> _scanVoucher() async {
    final qrCode = await showQRScannerDialog(context);
    if (qrCode != null) {
      final voucherState = await CloudRequest.memberVoucher(detailRoom?.data?.memberCode ?? '', qrCode);
      if (voucherState.state != true) {
        showToastError(voucherState.message ?? 'Error get voucher data');
        return;
      }
      voucherDetail = voucherState.data;
      if (voucherDetail != null) {
        voucherFix = VoucherDetail(
          code: voucherDetail?.voucherCode ?? '',
          hour: voucherDetail?.voucherHour ?? 0,
          hourPrice: (voucherDetail?.voucherRoomPrice ?? 0).toInt(),
          hourPercent: (voucherDetail?.voucherRoomDiscount ?? 0).toInt(),
          item: voucherDetail?.itemCode ?? '',
          itemPrice: (voucherDetail?.voucherFnbPrice ?? 0).toInt(),
          itemPercent: (voucherDetail?.voucherFnbDiscount ?? 0).toInt(),
          price: (voucherDetail?.voucherPrice ?? 0).toInt(),
        );
      }
      setState(() {});
    }
  }

  Future<void> _removeVoucher() async {
    if (dataCheckin?.voucher == null) {
      setState(() => voucherDetail = null);
    } else {
      final removeVoucherState = await VerificationDialog.requestVerification(
          context, detailRoom?.data?.reception ?? 'unknown', roomCode, 'Hapus Voucher ${voucherFix?.code ?? ''}');
      if (removeVoucherState.state == true) setState(() => voucherFix = null);
    }
  }

  Future<void> _removePromoRoom() async {
    if (dataCheckin?.promoRoom == null) {
      setState(() => promoRoom = null);
    } else {
      final approvalResult = await VerificationDialog.requestVerification(
          context, detailRoom?.data?.reception ?? 'unknown', roomCode, 'Hapus Promo Room');
      if (approvalResult.state == true) {
        final state = await ApiRequest().removePromoRoom(dataCheckin?.reception ?? '');
        if (state.state != true) {
          showToastError('Gagal menghapus promo room ${state.message}');
          return;
        }
        setState(() => promoRoom = null);
      }
    }
  }

  Future<void> _removePromoFnb() async {
    if (dataCheckin?.promoFnb == null) {
      await ApiRequest().removePromoFood(dataCheckin?.reception ?? '');
      setState(() => promoFnb = null);
    } else {
      final approvalResult = await VerificationDialog.requestVerification(
          context, detailRoom?.data?.reception ?? 'unknown', roomCode, 'Hapus Promo FnB');
      if (approvalResult.state == true) {
        final removeState = await ApiRequest().removePromoFood(dataCheckin?.reception ?? '');
        if (removeState.state != true) {
          showToastError('Gagal hapus promo food ${removeState.message}');
          return;
        }
        setState(() => promoFnb = null);
      }
    }
  }

  Future<void> _saveCheckin() async {
    final isConfirmed = await ConfirmationDialog.confirmation(context, 'Simpan Edit Checkin?');
    if (isConfirmed != true) return;

    setState(() => isLoading = true);
    List<String> listPromo = [];
    if (isNotNullOrEmpty(promoRoom?.promoName)) listPromo.add(promoRoom!.promoName!);
    if (isNotNullOrEmpty(promoFnb?.promoName)) listPromo.add(promoFnb!.promoName!);

    final chusr = GlobalProviders.read(userProvider).userId;
    final params = EditCheckinBody(
      room: dataCheckin!.roomCode,
      pax: pax,
      hp: dataCheckin!.hp,
      dp: "",
      description: descriptionController.text,
      event: eventController.text,
      chusr: chusr,
      voucher: '',
      dpNote: "",
      cardType: "",
      voucherDetail: voucherFix,
      cardName: "",
      cardNo: "",
      cardApproval: "",
      edcMachine: "",
      memberCode: dataCheckin!.memberCode,
      promo: listPromo,
    );

    final editResponse = await ApiRequest().editCheckin(params);
    if (editResponse.state == true) {
      if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, MainPage.nameRoute, (route) => false);
    } else {
      showToastError(editResponse.message ?? 'Error Edit data checkin');
      setState(() => isLoading = false);
    }
  }

  Widget _buildDefaultLayout(PosType pos) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Room Checkin', style: CustomTextStyle.titleAppBar()),
        backgroundColor: CustomColorStyle.appBarBackground(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Center(child: AutoSizeText('INFORMASI CHECKIN', style: CustomTextStyle.blackMediumSize(21), minFontSize: 12, maxLines: 1)),
                const SizedBox(height: 12,),
                Row(
                  children: [
                    Expanded(
                      child: 
                      pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased?
                      Column(
                        children: [
                          AutoSizeText('Cust:', style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(child: AutoSizeText(dataCheckin!.memberName, style: CustomTextStyle.blackMedium(), minFontSize: 14, overflow: TextOverflow.ellipsis, maxLines: 1,)),
                              SizedBox(width: 4,),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    showEditName = !showEditName;
                                  });
                                },
                                child: Icon(Icons.edit_square, size: 16, color: Colors.grey.shade600,),
                              )
                            ],
                          ),
                          showEditName?
                          Column(
                            children: [
                              SizedBox(height: 3,),
                              Badge(
                                backgroundColor: Colors.red,
                                label: InkWell(
                                  onTap: (){
                                    setState(() {
                                      showEditName = !showEditName;
                                    });
                                  },
                                  child: Text('X', style: CustomTextStyle.whiteSize(11)), 
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: custNameController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          hintStyle: CustomTextStyle.blackStandard().copyWith(fontSize: 11),
                                          hintText: 'Ubah Nama Customer...',
                                          labelText: 'Ubah nama customer',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(color: CustomColorStyle.bluePrimary(), width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            // borderSide: const BorderSide(color: Colors.orange, width: 2),
                                          ),
                                          fillColor: Colors.white,
                                          filled: true
                                        ),
                                      ),
                                      SizedBox(height: 4,),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: ()async{
                                            if(isNotNullOrEmpty(custNameController.text)){
                                              if(custNameController.text.length > 25){
                                                showToastWarning('Maksimal 25 karakter untuk nama customer');
                                                return;
                                              }
                                              // dataCheckin!.memberName = custNameController.text;
                                              final state = await ConfirmationDialog.confirmation(context, 'Ubah nama customer menjadi ${custNameController.text}?');
                                              if(!state){
                                                return;
                                              }
                                              setState(() {
                                                showEditName = false;
                                                isLoading = true;
                                              });
                                              await ApiRequest().editName(dataCheckin!.reception, custNameController.text);
                                              getData();
                                            }else{
                                              showToastWarning('Nama customer tidak boleh kosong');
                                              return;
                                            }
                                          }, 
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: CustomColorStyle.appBarBackground(),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text('Simpan', style: CustomTextStyle.whiteSize(12)),
                                          )
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ): SizedBox.shrink()
                        ],
                      ):                      
                      Column(
                        children: [
                          AutoSizeText(dataCheckin!.memberName, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                          AutoSizeText(dataCheckin!.memberCode, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                        ],
                      ),
                    ),
                    Container(width: 1, height: showEditName? 59: 39,color: CustomColorStyle.bluePrimary()),
                    Expanded(
                      child: 
                      pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased?
                      Column(
                        children: [
                          AutoSizeText('Table', style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                          AutoSizeText(dataCheckin!.roomCode, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                      ],):
                      Column(
                        children: [
                          AutoSizeText(dataCheckin!.roomCode, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                          AutoSizeText(remainingTime, style: CustomTextStyle.blackMedium(), minFontSize: 9, maxLines: 1,),
                      ],)
                    )
                  ],
                ),
                const SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText('Jumlah Pengunjung', style: CustomTextStyle.blackMediumSize(15), maxLines: 1, minFontSize: 12,),
                    const SizedBox(width: 12,),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: InkWell(
                        child: Image.asset(
                          'assets/icon/minus.png'),
                        onTap: (){
                        setState((){
                          if(pax>1){
                            --pax;
                          }
                        });
                      },
                      ),
                      ),
                    const SizedBox(width: 12,),
                    Text(pax.toString(), style: CustomTextStyle.blackMediumSize(21),),
                    const SizedBox(width: 12,),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: InkWell(
                        child: Image.asset(
                          'assets/icon/plus.png'),
                        onTap: (){
                        setState((){
                          ++pax;
                        });
                      },
                      ),
                      ),
                  ],
                ),
                pos != PosType.restoOnlyOld && pos != PosType.restoOnlyWebBased?
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Voucher Puppy Club', style: CustomTextStyle.blackMediumSize(17),)): SizedBox(),
                pos != PosType.restoOnlyOld && pos != PosType.restoOnlyWebBased?
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      voucherFix == null? ElevatedButton(
                        onPressed: ()async{
                          // showToastWarning('Masih belum aktif, gunakan FO Desktop');
                          // return;
                          final qrCode = await showQRScannerDialog(context);
                  
                          if(qrCode != null){
                            final voucherState = await CloudRequest.memberVoucher(detailRoom?.data?.memberCode??'', qrCode);
                  
                            if(voucherState.state != true){
                              showToastError(voucherState.message??'Error get voucher data');
                              return;
                            }
                              voucherDetail = voucherState.data;
                            
                            if(voucherDetail != null){
                                voucherFix = VoucherDetail(
                                  code: voucherDetail?.voucherCode??'',
                                  hour: voucherDetail?.voucherHour??0,
                                  hourPrice: (voucherDetail?.voucherRoomPrice??0).toInt(),
                                  hourPercent: (voucherDetail?.voucherRoomDiscount??0).toInt(),
                                  item: voucherDetail?.itemCode??'',
                                  itemPrice: (voucherDetail?.voucherFnbPrice??0).toInt(),
                                  itemPercent: (voucherDetail?.voucherFnbDiscount??0).toInt(),
                                  price: (voucherDetail?.voucherPrice??0).toInt(),
                                );
                            }
                            
                            setState(() {
                              voucherFix;
                            });
                          }
                        },
                        style: CustomButtonStyle.bluePrimary(),
                        child: Text('Scan Voucher', style: CustomTextStyle.whiteStandard(),),
                          ): Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 0.7,
                              ),
                              borderRadius: BorderRadius.circular(10), // Bentuk border
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: AutoSizeText(voucherFix?.code??'', style: CustomTextStyle.blackMediumSize(17)),
                                ),
                                (voucherFix?.hour??0) > 0? AddOnWidget.vcrItem(context, 'Jam', '${voucherFix?.hour??0}') : const SizedBox(),
                                (voucherFix?.hourPrice??0) > 0? AddOnWidget.vcrItem(context, 'Room', Formatter.formatRupiah(voucherFix?.hourPrice??0)) : const SizedBox(),
                                (voucherFix?.hourPercent??0) > 0? AddOnWidget.vcrItem(context, 'Room', '${voucherFix?.hourPercent??0}%') : const SizedBox(),
                                
                                (voucherFix?.item??'').trim() != ''? AddOnWidget.vcrItem(context, 'FnB', '${voucherFix?.item}') : const SizedBox(),
                                (voucherFix?.itemPrice??0) > 0 ? AddOnWidget.vcrItem(context, 'FnB', Formatter.formatRupiah(voucherFix?.itemPrice??0)) : const SizedBox(),
                                (voucherFix?.itemPercent??0) > 0? AddOnWidget.vcrItem(context, 'FnB', '${voucherFix?.itemPercent}%') : const SizedBox(),
                                (voucherFix?.price??0) >0 ? AddOnWidget.vcrItem(context, 'Price', Formatter.formatRupiah(voucherFix?.price??0)) : const SizedBox(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: ()async{
                                      if(dataCheckin?.voucher == null){
                                        setState(() {
                                          voucherDetail = null;
                                        });
                                      }else{
                                        if(context.mounted){
                                          final removeVoucherState = await VerificationDialog.requestVerification(context, (detailRoom?.data?.reception??'unknown') , roomCode, 'Hapus Voucher ${voucherFix?.code??''}');
                                          if(removeVoucherState.state != true){
                                            showToastWarning('Batal');
                                            return;
                                          }
                                          setState(() {
                                            voucherFix = null;
                                          });
                                        }
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.shade400,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                        child: Text('Hapus Voucher', style: CustomTextStyle.whiteSize(14),),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6,), 
                    ],
                  ),
                ): SizedBox(),
                const SizedBox(width: 6,),

                promoRoom == null && (pos != PosType.restoOnlyOld && pos != PosType.restoOnlyWebBased)?
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6,),
                      Text('Promo Room', style: CustomTextStyle.blackMediumSize(17),),
                      const SizedBox(height: 2,),
                      ElevatedButton(
                        onPressed: ()async{
                          final nganu = await PromoDialog().setPromoRoom(context, detailRoom?.data?.roomType??'');
                          if(nganu != null){  
                            setState(() {
                              promoRoom = nganu;
                            });
                          }
                        },
                        style: CustomButtonStyle.bluePrimary(),
                        child: AutoSizeText('Pilih Promo Room', style: CustomTextStyle.whiteStandard(), maxLines: 1,),
                      )
                    ],
                  ),
                ): SizedBox(),
                
                promoRoom != null && (pos != PosType.restoOnlyOld && pos != PosType.restoOnlyWebBased)?
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 0.7,
                      ),
                      borderRadius: BorderRadius.circular(10), // Bentuk border
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: AutoSizeText('PROMO ROOM DIPILIH', style: CustomTextStyle.blackMediumSize(17)),
                        ),
                        Row(
                          children: [
                            Text('NAMA  PROMO :', style: CustomTextStyle.blackStandard()),
                            const SizedBox(width: 5,),
                            Expanded(child: AutoSizeText(promoRoom?.promoName??'', style: CustomTextStyle.blackStandard(), minFontSize: 7, maxLines: 1,))
                          ],
                        ),
                        Row(
                          children: [
                            Text('VALUE  PROMO :', style: CustomTextStyle.blackStandard()),
                            const SizedBox(width: 5,),
                            Expanded(child: AutoSizeText('${(promoRoom?.promoPercent??0) > 0? '${promoRoom?.promoPercent}%' : ''} ${(promoRoom?.promoIdr??0) > 0? Formatter.formatRupiah((promoRoom?.promoIdr??0).toInt()) : ''}', style: CustomTextStyle.blackStandard(), minFontSize: 7, maxLines: 1,))
                          ],
                        ),
                        Row(
                          children: [
                            Text('MASA BERLAKU :', style: CustomTextStyle.blackStandard()),
                            const SizedBox(width: 5,),
                            AutoSizeText('${promoRoom?.timeStart} - ${promoRoom?.timeFinish}', style: CustomTextStyle.blackStandard(), minFontSize: 9,)
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: ()async{
                              if(dataCheckin?.promoRoom == null){
                                setState(() {
                                  promoRoom = null;
                                });
                              }else{
                                if(context.mounted){
                                  // approvalPromoRoomState = await VerificationDialog.requestVerification(context, (detailRoom?.data?.reception??'unknown') , roomCode, 'Hapus Promo Room')??false;
                                  final VerificationResultModel approvalResult = await VerificationDialog.requestVerification(context, (detailRoom?.data?.reception??'unknown') , roomCode, 'Hapus Promo Room');
                                  approvalPromoRoomState = approvalResult.state;
                                  if(approvalPromoRoomState == true){
                                    final state = await ApiRequest().removePromoRoom(dataCheckin?.reception??'');
                                    if(state.state != true){
                                      showToastError('Gagal menghapus promo room ${state.message}');
                                      return;
                                    }
                                    setState(() {
                                      promoRoom = null;
                                    });
                                  }
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent.shade400,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                child: Text('Hapus Promo', style: CustomTextStyle.whiteSize(14),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ): SizedBox(),
                promoFnb == null?
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6,),
                      Text('Promo FnB', style: CustomTextStyle.blackMediumSize(19),),
                      ElevatedButton(
                        onPressed: ()async{
                          final choosePromo = await PromoDialog().setPromoFnb(context, 'PR A', 'PR A');
                          if(choosePromo != null){
                            final addPromoFnb = await ApiRequest().addPromo(detailRoom?.data?.invoice?? '', choosePromo.promoName??'');
                            if(addPromoFnb.state != true){
                              promoFnb = null;
                              return;
                            }else{
                              setState(() {
                                promoFnb = choosePromo;
                              });
                            }
                          }
                        },
                        style: CustomButtonStyle.bluePrimary(),
                        child: AutoSizeText('Pilih Promo FnB', style: CustomTextStyle.whiteStandard(), maxLines: 1,),),
                    ],
                  )):Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 0.7,
                      ),
                      borderRadius: BorderRadius.circular(10), // Bentuk border
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: AutoSizeText('PROMO FOOD DIPILIH', style: CustomTextStyle.blackMediumSize(17)),
                        ),
                        Row(
                          children: [
                            Text('NAMA  PROMO :', style: CustomTextStyle.blackStandard()),
                            const SizedBox(width: 5,),
                            Expanded(child: AutoSizeText(promoFnb?.promoName??'', style: CustomTextStyle.blackStandard(), minFontSize: 7, maxLines: 1,))
                          ],
                        ),
                        Row(
                          children: [
                            Text('VALUE  PROMO :', style: CustomTextStyle.blackStandard()),
                            const SizedBox(width: 5,),
                            Expanded(child: AutoSizeText('${(promoFnb?.promoPercent??0) > 0? '${promoFnb?.promoPercent}%' : ''} ${(promoFnb?.promoIdr??0) > 0? Formatter.formatRupiah((promoFnb?.promoIdr??0).toInt()) : ''}', style: CustomTextStyle.blackStandard(), minFontSize: 7, maxLines: 1,))
                          ],
                        ),
                        /*Row(
                          children: [
                            Text('MASA BERLAKU :', style: CustomTextStyle.blackStandard()),
                            const SizedBox(width: 5,),
                            AutoSizeText('${promoFnb?.timeStart} - ${promoFnb?.timeFinish}', style: CustomTextStyle.blackStandard(), minFontSize: 9,)
                          ],
                        ),*/
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: ()async{
                            if(dataCheckin?.promoFnb == null){
                              await ApiRequest().removePromoFood(dataCheckin?.reception??'');
                              setState(() {
                                promoFnb = null;
                              });
                            }else{
                              if(context.mounted){
                                final VerificationResultModel approvalResult = await VerificationDialog.requestVerification(context, (detailRoom?.data?.reception??'unknown') , roomCode, 'Hapus Promo FnB');
                                approvalPromoRoomState = approvalResult.state;
                                if(approvalPromoRoomState == true){
                                  final removeState = await ApiRequest().removePromoFood(dataCheckin?.reception??'');
                                  if(removeState.state != true){
                                    showToastError('Gagal hapus promo food ${removeState.message}');
                                    return;
                                  }
                                  setState(() {
                                    promoFnb = null;
                                  });
                                }
                              } 
                            }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent.shade400,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                child: Text('Hapus Promo', style: CustomTextStyle.whiteSize(14),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12,),
                Align(alignment: Alignment.centerLeft ,child: Text('Keterangan', style: CustomTextStyle.blackMedium(),)),
                TextField(decoration: CustomTextfieldStyle.normalHint(''), controller: descriptionController,),
                const SizedBox(height: 12,),
                Align(alignment: Alignment.centerLeft ,child: Text('Acara', style: CustomTextStyle.blackMedium(),)),
                TextField(decoration: CustomTextfieldStyle.normalHint(''), controller: eventController,),
                const SizedBox(height: 12,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ()async{
    
                      final isConfirmed = await ConfirmationDialog.confirmation(context, 'Simpan Edit Checkin?');
    
                      if(isConfirmed != true){
                        return;
                      }
    
                      setState(() {
                        isLoading = true;
                      });
                      List<String> listPromo = [];
                      if(isNotNullOrEmpty(promoRoom?.promoName)){
                        listPromo.add(promoRoom!.promoName!);
                      }
                      if(isNotNullOrEmpty(promoFnb?.promoName)){
                        listPromo.add(promoFnb!.promoName!);
                      }
    
                      final chusr = GlobalProviders.read(userProvider).userId;
    
                      final params = EditCheckinBody(
                        room: dataCheckin!.roomCode,
                        pax: pax,
                        hp: dataCheckin!.hp,
                        dp: "",
                        description: descriptionController.text,
                        event: eventController.text,
                        chusr: chusr,
                        voucher: '',
                        dpNote: "",
                        cardType: "",
                        voucherDetail: voucherFix,
                        cardName: "",
                        cardNo: "",
                        cardApproval: "",
                        edcMachine: "",
                        memberCode: dataCheckin!.memberCode,
                        promo: listPromo,
                      );
    
                      final editResponse = await ApiRequest().editCheckin(params);
                      if(editResponse.state == true){
                        if(context.mounted){
                          Navigator.pushNamedAndRemoveUntil(context, MainPage.nameRoute, (route) => false);
                        }
                      }else{
                        showToastError(editResponse.message??'Error Edit data checkin');
                        setState(() {
                          isLoading = false;
                        });
                      }
    
                    },
                    style: CustomButtonStyle.bluePrimary(),
                    child: Center(child: Text('SIMPAN', style: CustomTextStyle.whiteSize(18),)),
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    eventController.dispose();
    super.dispose();
  }
}