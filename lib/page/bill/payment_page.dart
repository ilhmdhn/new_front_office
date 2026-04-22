import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/enum/pos_type.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/model/payment_params.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/card_payment_dialog.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/dialog/payment_list_dialog.dart';
import 'package:front_office_2/page/dialog/rating_dialog.dart';
import 'package:front_office_2/page/dialog/verification_dialog.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/riverpod/feature_provider.dart';
import 'package:front_office_2/riverpod/provider_container.dart';
import 'package:front_office_2/riverpod/server_config_provider.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/list.dart';
import 'package:front_office_2/tools/printer/print_executor.dart';
import 'package:front_office_2/tools/rupiah.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPage extends StatefulWidget {
  static const nameRoute = '/payment';
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String roomCode = '';
  String paymentMethod = 'CASH';
  bool isLoading = true;
  num nominal = 0;
  String eMoneyChoosed = 'DANA';
  String piutangChoosed = 'PEMEGANG SAHAM OUTLET';
  String edcChoosed = '';
  String cardChoosed = '';
  bool sendEmail = false;
  final posType = GlobalProviders.read(posTypeProvider);

  final TextEditingController _nominalController = TextEditingController();
  
  final TextEditingController _nameCreditCardController = TextEditingController();
  final TextEditingController _numberCreditCardController = TextEditingController();
  final TextEditingController _approvalCreditCardController = TextEditingController();

  final TextEditingController _nameDebetCardController = TextEditingController();
  final TextEditingController _numberDebetCardController = TextEditingController();
  final TextEditingController _approvalDebetCardController = TextEditingController();

  final TextEditingController _nameEmoneyCardController = TextEditingController();
  final TextEditingController _numberEmoneyCardController = TextEditingController();
  final TextEditingController _referalEmoneyCardController = TextEditingController();

  final TextEditingController _nameComplimentaryCardController = TextEditingController();
  final TextEditingController _agencyComplimentaryCardController = TextEditingController();
  final TextEditingController _responsibleComplimentaryCardController = TextEditingController();

  final TextEditingController _nameReceivablesCardController = TextEditingController();
  final TextEditingController _memberReceivablesCardController = TextEditingController();

  List<PaymentDetail> paymentList = List.empty(growable: true);
  num totalBill = 0;
  num minusPay = 0;

  PreviewBillResponse? billData;

  final ratingEnable = GlobalProviders.read(ratingFeatureProvider);

  void _setNominal(){
    minusPay = totalBill;
    for (var element in paymentList) {
      minusPay -= element.nominal;
    }
    _nominalController.text = Formatter.formatRupiah(minusPay);
  }

  void getData()async{
    billData = await ApiRequest().previewBill(roomCode);
    if(billData?.state == true){
      totalBill = billData?.data?.dataInvoice.jumlahBersih??0;
      _setNominal();
    }
    _nameReceivablesCardController.text = (billData?.data?.dataInvoice.memberName??'');
    _memberReceivablesCardController.text = (billData?.data?.dataInvoice.memberCode??'');
    setState(() {
      billData;  
    });
  }

  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    if (billData == null) {
      getData();
    }

    final isDesktopLandscape = context.isDesktop && context.isLandscape;

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body: Column(
        children: [
          _buildHeader(context, isDesktopLandscape),
          Expanded(
            child: billData == null
                ? _buildLoadingState()
                : billData?.state != true
                    ? _buildErrorState()
                    : isDesktopLandscape
                        ? _buildDesktopLayout()
                        : 
                        _buildMobileLayout(),
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
        color: CustomColorStyle.appBarBackground()
        /*gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade700.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],*/
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
            child: const Icon(Icons.payments, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pembayaran',
                  style: GoogleFonts.poppins(
                    fontSize: isDesktopLandscape ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Room $roomCode',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              Formatter.formatRupiah(totalBill),
              style: GoogleFonts.poppins(
                fontSize: isDesktopLandscape ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
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
        child: CircularProgressIndicator(color: Colors.green.shade600),
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
            billData?.message ?? 'Error get data bill',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Panel - Payment Form
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 15)],
              ),
              child: Column(
                children: [
                  _buildPanelHeader('Input Pembayaran', Icons.edit_note, Colors.blue),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildNominalField(),
                          const SizedBox(height: 20),
                          _buildPaymentMethods(isDesktop: true),
                          const SizedBox(height: 16),
                          _buildPaymentForm(),
                          const SizedBox(height: 16),
                          _buildAddButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Right Panel - Payment Summary
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 15)],
              ),
              child: Column(
                children: [
                  _buildPanelHeader('Ringkasan Pembayaran', Icons.receipt_long, Colors.green),
                  Expanded(child: _buildPaymentSummary()),
                  _buildPayButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNominalField(),
                  const SizedBox(height: 16),
                  _buildPaymentMethods(isDesktop: false),
                  const SizedBox(height: 12),
                  _buildPaymentForm(),
                  const SizedBox(height: 12),
                  _buildAddButton(),
                ],
              ),
            ),
          ),
          _buildMobilePaymentSummary(),
        ],
      ),
    );
  }

  Widget _buildPanelHeader(String title, IconData icon, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.shade600,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNominalField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.green.shade100.withAlpha(50)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nominal Pembayaran',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nominalController,
            keyboardType: TextInputType.number,
            inputFormatters: [RupiahInputFormatter()],
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.money, color: Colors.green.shade600),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods({required bool isDesktop}) {
    final Map<String, IconData> methodIcons = {
      'CASH': Icons.money,
      'CREDIT CARD': Icons.credit_card,
      'DEBET CARD': Icons.credit_card_outlined,
      'E-MONEY': Icons.phone_android,
      'COMPLIMENTARY': Icons.card_giftcard,
      'PIUTANG': Icons.receipt_long,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metode Pembayaran',
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop || context.isTablet ? 3 : 2,
            childAspectRatio: isDesktop || context.isTablet ? 3.5 : 4.4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: paymentMethodList.length,
          itemBuilder: (context, index) {
            final method = paymentMethodList[index];
            bool isSelected = paymentMethod == method;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => paymentMethod = method),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? CustomColorStyle.bluePrimary() : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? CustomColorStyle.bluePrimary() : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: CustomColorStyle.bluePrimary().withAlpha(50), blurRadius: 8)]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        methodIcons[method] ?? Icons.payment,
                        size: 18,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: AutoSizeText(
                          method,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          minFontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    if (paymentMethod == 'CASH') return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (paymentMethod == 'CREDIT CARD' || paymentMethod == 'DEBET CARD') ...[
            Row(
              children: [
                Expanded(child: _buildSelectorButton('EDC Mesin', edcChoosed, () async {
                  final choosed = await CardPaymentDialog.edcMachine(context);
                  if (choosed != null) setState(() => edcChoosed = choosed);
                })),
                const SizedBox(width: 12),
                Expanded(child: _buildSelectorButton('Tipe Kartu', cardChoosed, () async {
                  final choosed = await CardPaymentDialog.cardType(context);
                  if (choosed != null) setState(() => cardChoosed = choosed);
                })),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField('Nama', paymentMethod == 'CREDIT CARD' ? _nameCreditCardController : _nameDebetCardController),
            const SizedBox(height: 10),
            _buildTextField('Nomor', paymentMethod == 'CREDIT CARD' ? _numberCreditCardController : _numberDebetCardController, isNumber: true),
            const SizedBox(height: 10),
            _buildTextField('Kode Approval', paymentMethod == 'CREDIT CARD' ? _approvalCreditCardController : _approvalDebetCardController, isNumber: true),
          ] else if (paymentMethod == 'E-MONEY') ...[
            _buildSelectorButton('Tipe E-Money', eMoneyChoosed, () async {
              final choosedEmoney = await PaymentListDialog.eMoneyList(context, eMoneyChoosed);
              if (choosedEmoney != null) setState(() => eMoneyChoosed = choosedEmoney);
            }),
            const SizedBox(height: 12),
            _buildTextField('Nama', _nameEmoneyCardController),
            const SizedBox(height: 10),
            _buildTextField('Nomor', _numberEmoneyCardController, isNumber: true),
            const SizedBox(height: 10),
            _buildTextField('Kode Referal', _referalEmoneyCardController, isNumber: true),
          ] else if (paymentMethod == 'COMPLIMENTARY') ...[
            _buildVerificationBadge(),
            const SizedBox(height: 12),
            _buildTextField('Nama', _nameComplimentaryCardController),
            const SizedBox(height: 10),
            _buildTextField('Instansi', _agencyComplimentaryCardController),
            const SizedBox(height: 10),
            _buildTextField('Penanggung Jawab', _responsibleComplimentaryCardController),
          ] else if (paymentMethod == 'PIUTANG') ...[
            _buildVerificationBadge(),
            const SizedBox(height: 12),
            _buildSelectorButton('Tipe Piutang', piutangChoosed, () async {
              final choosedPiutang = await PaymentListDialog.piutangList(context, piutangChoosed);
              if (choosedPiutang != null) setState(() => piutangChoosed = choosedPiutang);
            }),
            const SizedBox(height: 12),
            _buildTextField('Nama', _nameReceivablesCardController),
            const SizedBox(height: 10),
            _buildTextField('ID Member', _memberReceivablesCardController, isNumber: true),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectorButton(String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CustomColorStyle.bluePrimary().withAlpha(100)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      value.isEmpty ? 'Pilih' : value,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: value.isEmpty ? Colors.grey.shade400 : Colors.grey.shade800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: CustomColorStyle.bluePrimary()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CustomColorStyle.bluePrimary(), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user, size: 16, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Text(
            'Memerlukan Verifikasi',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.orange.shade800),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: _addPayment,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Tambahkan'),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColorStyle.bluePrimary(),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (paymentList.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada pembayaran',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: paymentList.length,
                itemBuilder: (context, index) {
                  final payment = paymentList[index];
                  return _buildPaymentItem(payment, index);
                },
              ),
            ),
          const Divider(),
          _buildSummaryRow(minusPay < 0 ? 'KEMBALI' : 'KURANG', Formatter.formatRupiah(minusPay.abs()), isHighlight: true),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: sendEmail,
                activeColor: Colors.green.shade600,
                onChanged: (value) => setState(() => sendEmail = !sendEmail),
              ),
              Text('Kirim Invoice via Email', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(PaymentDetail payment, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => setState(() {
              paymentList.removeAt(index);
              _setNominal();
            }),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.close, size: 16, color: Colors.red.shade600),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              payment.paymentType,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            Formatter.formatRupiah(payment.nominal),
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isHighlight ? 16 : 14,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            color: minusPay < 0 ? Colors.green.shade700 : Colors.orange.shade700,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isHighlight ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: minusPay < 0 ? Colors.green.shade700 : Colors.orange.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
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
        child: ElevatedButton.icon(
          onPressed: _processPayment,
          icon: const Icon(Icons.payments, size: 22),
          label: Text('BAYAR', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _buildMobilePaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          paymentList.isNotEmpty? Align(
            alignment: AlignmentGeometry.centerLeft,
            child: Text(
              'Pembayaran Ditambahkan',
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ): Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
                'Belum ada Pembayaran',
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: context.hp(25)
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (paymentList.isNotEmpty) ...[
                    for (int i = 0; i < paymentList.length; i++)
                      _buildPaymentItem(paymentList[i], i),
                    const SizedBox(height: 4),
                  ],
                ],
              ),
            ),
          ),
          Column(
            children: [
              _buildSummaryRow(minusPay < 0 ? 'KEMBALI' : 'KURANG', Formatter.formatRupiah(minusPay.abs()), isHighlight: true),
              const SizedBox(height: 8),
              SafeArea(
                left: false,
                right: false,
                top: false,
                child: Row(
                  children: [
                    Checkbox(
                      value: sendEmail,
                      activeColor: Colors.green.shade600,
                      onChanged: (value) => setState(() => sendEmail = !sendEmail),
                    ),
                    const Text('Email Invoice', style: TextStyle(fontSize: 12)),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _processPayment,
                      icon: const Icon(Icons.payments, size: 18),
                      label: const Text('BAYAR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addPayment() async {
    if (isNullOrEmpty(_nominalController.text)) {
      return showToastError('Isi nominal');
    }
    final value = int.parse(_nominalController.text.replaceAll(RegExp(r'[^\d]'), ''));
    final isAdded = paymentList.where((element) => element.paymentType == paymentMethod).toList();
    if (isAdded.isNotEmpty) {
      return showToastWarning('Metode pembayaran sudah ditambahkan');
    }

    switch (paymentMethod) {
      case 'CASH':
        paymentList.add(PaymentDetail(nominal: value, paymentType: 'CASH'));
        break;
      case 'CREDIT CARD':
        final approvalCode = _approvalCreditCardController.text;
        final cardCode = _numberCreditCardController.text;
        final cardName = _nameCreditCardController.text;
        if (isNullOrEmpty(approvalCode) || isNullOrEmpty(cardCode) || isNullOrEmpty(cardName) || isNullOrEmpty(cardChoosed) || isNullOrEmpty(edcChoosed)) {
          return showToastError('Lengkapi data');
        }
        paymentList.add(PaymentDetail(
          nominal: value,
          approvalCodeCredit: approvalCode,
          cardCodeCredit: cardCode,
          cardCredit: cardChoosed,
          edcCredit: edcChoosed,
          namaUserCredit: cardName,
          paymentType: 'CREDIT CARD',
        ));
        break;
      case 'DEBET CARD':
        final approvalCode = _approvalDebetCardController.text;
        final cardCode = _numberDebetCardController.text;
        final cardName = _nameDebetCardController.text;
        if (isNullOrEmpty(approvalCode) || isNullOrEmpty(cardCode) || isNullOrEmpty(cardName) || isNullOrEmpty(cardChoosed) || isNullOrEmpty(edcChoosed)) {
          return showToastError('Lengkapi data');
        }
        paymentList.add(PaymentDetail(
          approvalCodeDebet: approvalCode,
          cardCodeDebet: cardCode,
          cardDebet: cardChoosed,
          edcDebet: edcChoosed,
          namaUserDebet: cardName,
          nominal: value,
          paymentType: 'DEBET CARD',
        ));
        break;
      case 'E-MONEY':
        final accountCode = _numberEmoneyCardController.text;
        final accountName = _nameEmoneyCardController.text;
        final referalCode = _referalEmoneyCardController.text;
        if (isNullOrEmpty(accountCode) || isNullOrEmpty(accountName) || isNullOrEmpty(referalCode)) {
          return showToastError('Lengkapi data');
        }
        paymentList.add(PaymentDetail(
          accountEmoney: accountCode,
          namaUserEmoney: accountName,
          nominal: value,
          paymentType: 'E-MONEY',
          refCodeEmoney: referalCode,
          typeEmoney: eMoneyChoosed,
        ));
        break;
      case 'COMPLIMENTARY':
        final agencyName = _agencyComplimentaryCardController.text;
        final responsibleName = _responsibleComplimentaryCardController.text;
        final nameComplimentary = _nameComplimentaryCardController.text;
        if (isNullOrEmpty(agencyName) || isNullOrEmpty(responsibleName) || isNullOrEmpty(nameComplimentary)) {
          return showToastError('Lengkapi data');
        }
        final approvalState = await VerificationDialog.requestVerification(
          context,
          billData?.data?.dataInvoice.reception ?? '',
          billData?.data?.dataRoom.roomCode ?? '',
          'Meminta persetujuan pembayaran COMPLIMENTARY sebesar $value',
        );
        if (approvalState.state != true) {
          return showToastWarning('Permintaan complimentary ditolak');
        }
        paymentList.add(PaymentDetail(
          instansiCompliment: agencyName,
          instruksiCompliment: responsibleName,
          namaUserCompliment: nameComplimentary,
          nominal: value,
          paymentType: 'COMPLIMENTARY',
        ));
        break;
      case 'PIUTANG':
        final name = _nameReceivablesCardController.text;
        final memberCode = _memberReceivablesCardController.text;
        if (isNullOrEmpty(name) || isNullOrEmpty(memberCode)) {
          return showToastError('Lengkapi data');
        }
        final approvalState = await VerificationDialog.requestVerification(
          context,
          'RCP',
          'ROOMNYA',
          'Meminta persetujuan pembayaran PIUTANG sebesar $value',
        );
        if (approvalState.state != true) {
          return showToastWarning('Permintaan piutang ditolak');
        }
        paymentList.add(PaymentDetail(
          idMemberPiutang: memberCode,
          namaUserPiutang: name,
          nominal: value,
          paymentType: 'PIUTANG',
          typePiutang: piutangChoosed,
        ));
        break;
    }

    setState(() {
      _setNominal();
    });
  }

  Future<void> _processPayment() async {
    if (minusPay > 0) {
      showToastWarning('Pembayaran Kurang');
      return;
    }

    final confirmationState = await ConfirmationDialog.confirmation(context, 'Bayar Room $roomCode');
    if (confirmationState != true) return;

    final params = GeneratePaymentParams.generatePaymentParams(sendEmail, roomCode, paymentList);
    final paymentResult = await ApiRequest().pay(params);

    if (paymentResult.state != true) {
      showToastError(paymentResult.message.toString());
      return;
    }

    PrintExecutor.printInvoice(billData?.data?.dataInvoice.reception ?? '');

    if (context.mounted) {
      final invoiceCode = billData?.data?.dataInvoice.invoice ?? '';
      final memberCode = billData?.data?.dataInvoice.memberCode ?? '';
      final memberName = billData?.data?.dataInvoice.memberName ?? '';

      if (posType == PosType.restoOnlyOld || posType == PosType.restoOnlyWebBased) {
        await ApiRequest().checkout(roomCode);
        await ApiRequest().clean(roomCode);
      }
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, MainPage.nameRoute, (route) => false);
        if (ratingEnable) {
          RatingDialog.submitRate(context, invoiceCode, memberCode, memberName);
        }
      }
    }
  }
}