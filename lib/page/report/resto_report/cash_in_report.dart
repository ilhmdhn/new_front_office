import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// ── Shared Item ───────────────────────────────────────────────────────────────

class XSalesItem {
  final String name;
  final int qty;
  final num amount;
  const XSalesItem(this.name, this.qty, this.amount);
}

// ── Section Classes ───────────────────────────────────────────────────────────

class XSalesSummary {
  final int itemSalesQty;
  final num itemSalesAmount;
  final int itemDiscountQty;
  final num itemDiscountAmount;
  final int billDiscountQty;
  final num billDiscountAmount;
  final int focItemQty;
  final num focItemAmount;
  final int focBillQty;
  final num focBillAmount;
  final int totalQty;
  final num totalAmount;
  final num estimatedSales;

  const XSalesSummary({
    required this.itemSalesQty,
    required this.itemSalesAmount,
    required this.itemDiscountQty,
    required this.itemDiscountAmount,
    required this.billDiscountQty,
    required this.billDiscountAmount,
    required this.focItemQty,
    required this.focItemAmount,
    required this.focBillQty,
    required this.focBillAmount,
    required this.totalQty,
    required this.totalAmount,
    required this.estimatedSales,
  });
}

class XSalesPaymentMedia {
  final List<XSalesItem> items;
  const XSalesPaymentMedia({required this.items});
}

class XSalesTotals {
  final int cardQty;
  final num cardAmount;
  final int cashQty;
  final num cashAmount;
  final int voucherQty;
  final num voucherAmount;

  const XSalesTotals({
    required this.cardQty,
    required this.cardAmount,
    required this.cashQty,
    required this.cashAmount,
    required this.voucherQty,
    required this.voucherAmount,
  });
}

class XSalesVoid {
  final int preSendQty;
  final num preSendAmount;
  final int postSendQty;
  final num postSendAmount;

  const XSalesVoid({
    required this.preSendQty,
    required this.preSendAmount,
    required this.postSendQty,
    required this.postSendAmount,
  });
}

class XSalesSettlement {
  final int extCollectionQty;
  final num extCollectionAmount;
  final int extCollectionFocQty;
  final num extCollectionFocAmount;

  const XSalesSettlement({
    required this.extCollectionQty,
    required this.extCollectionAmount,
    required this.extCollectionFocQty,
    required this.extCollectionFocAmount,
  });
}

class XSalesTaxNet {
  final num pb1Amount;
  final num scAmount;
  final num netSales;

  const XSalesTaxNet({
    required this.pb1Amount,
    required this.scAmount,
    required this.netSales,
  });
}

class XSalesBills {
  final int pending;
  final int totalCount;
  final num totalAmount;
  final int totalCovers;
  final num avgCovers;
  final String bestReceiptNo;
  final String secondReceiptNo;

  const XSalesBills({
    required this.pending,
    required this.totalCount,
    required this.totalAmount,
    required this.totalCovers,
    required this.avgCovers,
    required this.bestReceiptNo,
    required this.secondReceiptNo,
  });
}

class XSalesGroupSales {
  final List<XSalesItem> items;
  final num total;
  const XSalesGroupSales({required this.items, required this.total});
}

class XSalesGroupFoc {
  final List<XSalesItem> items;
  final num total;
  const XSalesGroupFoc({required this.items, required this.total});
}

class XSalesSalesCategory {
  final List<XSalesItem> items;
  const XSalesSalesCategory({required this.items});
}

class XSalesDiscount {
  final List<XSalesItem> items;
  final num total;
  const XSalesDiscount({required this.items, required this.total});
}

class XSalesCash {
  final num salesCash;
  const XSalesCash({required this.salesCash});
}

// ── Root Model ────────────────────────────────────────────────────────────────

class XSalesReportData {
  final String outletName;
  final String reportTitle;
  final DateTime reportDate;
  final String reportNo;
  final String group;

  final XSalesSummary summary;
  final XSalesPaymentMedia paymentMedia;
  final XSalesTotals totals;
  final XSalesVoid voidData;
  final XSalesSettlement settlement;
  final XSalesTaxNet taxNet;
  final XSalesBills bills;
  final XSalesGroupSales groupSales;
  final XSalesGroupFoc groupFoc;
  final XSalesSalesCategory salesCategory;
  final XSalesDiscount discount;
  final XSalesCash cash;

  const XSalesReportData({
    required this.outletName,
    required this.reportTitle,
    required this.reportDate,
    required this.reportNo,
    required this.group,
    required this.summary,
    required this.paymentMedia,
    required this.totals,
    required this.voidData,
    required this.settlement,
    required this.taxNet,
    required this.bills,
    required this.groupSales,
    required this.groupFoc,
    required this.salesCategory,
    required this.discount,
    required this.cash,
  });
}

// ── Dummy Data ────────────────────────────────────────────────────────────────

final _dummyReport = XSalesReportData(
  outletName: 'TUTTU BONO\nRESTO BAR',
  reportTitle: 'X Sales Day Report',
  reportDate: DateTime(2026, 4, 20),
  reportNo: '10567',
  group: 'All Pos',
  summary: const XSalesSummary(
    itemSalesQty: 560, itemSalesAmount: 60128000,
    itemDiscountQty: 0, itemDiscountAmount: 762750,
    billDiscountQty: 0, billDiscountAmount: 0,
    focItemQty: 0, focItemAmount: 0,
    focBillQty: 0, focBillAmount: 400000,
    totalQty: 560, totalAmount: 69016350,
    estimatedSales: 69016350,
  ),
  paymentMedia: const XSalesPaymentMedia(items: [
    XSalesItem('CASH', 20, 34500000),
    XSalesItem('BCA', 46, 822750),
    XSalesItem('BRI', 0, 0),
    XSalesItem('MANDIRI', 7, 2415120),
    XSalesItem('TRANSFER', 1, 1175300),
    XSalesItem('VOUCHER', 0, 0),
    XSalesItem('COMPLIMENTARY', 0, 0),
    XSalesItem('FOC ARIZONA', 0, 0),
  ]),
  totals: const XSalesTotals(
    cardQty: 48, cardAmount: 69449977,
    cashQty: 1, cashAmount: 567100,
    voucherQty: 0, voucherAmount: 0,
  ),
  voidData: const XSalesVoid(
    preSendQty: 0, preSendAmount: 4782000,
    postSendQty: 18, postSendAmount: 1386000,
  ),
  settlement: const XSalesSettlement(
    extCollectionQty: 53, extCollectionAmount: 70413977,
    extCollectionFocQty: 1, extCollectionFocAmount: 70092777,
  ),
  taxNet: const XSalesTaxNet(
    pb1Amount: 6328803,
    scAmount: 2688950,
    netSales: 59015250,
  ),
  bills: const XSalesBills(
    pending: 0,
    totalCount: 23,
    totalAmount: 1326905,
    totalCovers: 79,
    avgCovers: 492532,
    bestReceiptNo: 'A260000097401',
    secondReceiptNo: 'A260000091807',
  ),
  groupSales: const XSalesGroupSales(
    items: [
      XSalesItem('ALCOHOL', 0, 16987000),
      XSalesItem('BEVERAGE', 119, 6314000),
      XSalesItem('FOOD', 0, 8474000),
      XSalesItem('EVENT TUTUBONO', 0, 35902000),
      XSalesItem('OTHER', 0, 25000),
      XSalesItem('SNORE', 392, 1565000),
    ],
    total: 60118000,
  ),
  groupFoc: const XSalesGroupFoc(
    items: [
      XSalesItem('ALCOHOL', 0, 90000),
      XSalesItem('BEVERAGE', 0, 40000),
      XSalesItem('EVENT TUTUBONO', 0, 75000),
      XSalesItem('OTHER', 0, 195000),
    ],
    total: 400000,
  ),
  salesCategory: const XSalesSalesCategory(
    items: [XSalesItem('DINE IN', 560, 60118000)],
  ),
  discount: const XSalesDiscount(
    items: [XSalesItem('M.DIAMOND 15%', 38, 702750)],
    total: 702750,
  ),
  cash: const XSalesCash(salesCash: 582100),
);

// ── Main Page ─────────────────────────────────────────────────────────────────

class RestoCashInReportPage extends StatefulWidget {
  const RestoCashInReportPage({super.key});
  static const nameRoute = '/resto-cash-in';

  @override
  State<RestoCashInReportPage> createState() => RestoCashInReportPageState();
}

class RestoCashInReportPageState extends State<RestoCashInReportPage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedShift = 'FULLDAY';
  XSalesReportData? _reportData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _reportData = _dummyReport;
        _isLoading = false;
      });
    });
  }

  bool get _showSidePanel =>
      context.isTablet && context.isLandscape;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomColorStyle.appBarBackground(),
        title: Text('X Sales Day Report', style: CustomTextStyle.titleAppBar()),
        actions: [
          if (_reportData != null && _showSidePanel)
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              icon: const Icon(Icons.print_outlined),
              label: Text('Cetak', style: CustomTextStyle.whiteSize(14)),
              onPressed: _handlePrint,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _showSidePanel ? _buildSideLayout() : _buildStackLayout(),
      bottomNavigationBar:
          _showSidePanel ? null : _buildBottomBar(),
    );
  }

  // ── Layouts ─────────────────────────────────────────────────────────────────

  Widget _buildSideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.isDesktop ? 300 : 240,
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _FilterPanel(
                selectedDate: _selectedDate,
                selectedShift: _selectedShift,
                onDateChanged: (d) => setState(() => _selectedDate = d),
                onShiftChanged: (s) => setState(() => _selectedShift = s),
                onSearch: _fetchReport,
                vertical: true,
              ),
            ),
          ),
        ),
        Container(width: 1, color: Colors.grey.shade300),
        Expanded(child: _buildReportContent()),
      ],
    );
  }

  Widget _buildStackLayout() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _FilterPanel(
            selectedDate: _selectedDate,
            selectedShift: _selectedShift,
            onDateChanged: (d) => setState(() => _selectedDate = d),
            onShiftChanged: (s) => setState(() => _selectedShift = s),
            onSearch: _fetchReport,
            vertical: false,
          ),
        ),
        Container(height: 1, color: Colors.grey.shade300),
        Expanded(child: _buildReportContent()),
      ],
    );
  }

  // ── Report Content ───────────────────────────────────────────────────────────

  Widget _buildReportContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: CustomColorStyle.appBarBackground()),
            const SizedBox(height: 12),
            Text('Memuat laporan...', style: CustomTextStyle.blackMedium()),
          ],
        ),
      );
    }

    if (_reportData == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('Pilih tanggal & shift lalu tekan Cari',
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.isDesktop ? 40 : (context.isTablet ? 24 : 16),
        vertical: 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: context.isDesktop ? 760 : double.infinity),
          child: _ReportPreview(data: _reportData!),
        ),
      ),
    );
  }

  // ── Bottom Bar ───────────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    if (_reportData == null) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        height: 46,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColorStyle.appBarBackground(),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.print_outlined),
          label: Text('Cetak Laporan',
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w600)),
          onPressed: _handlePrint,
        ),
      ),
    );
  }

  void _handlePrint() {
    // TODO: integrate with ESC/POS printer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fitur cetak akan segera tersedia'),
        backgroundColor: CustomColorStyle.appBarBackground(),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ── Filter Panel ──────────────────────────────────────────────────────────────

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.selectedDate,
    required this.selectedShift,
    required this.onDateChanged,
    required this.onShiftChanged,
    required this.onSearch,
    required this.vertical,
  });

  final DateTime selectedDate;
  final String selectedShift;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onShiftChanged;
  final VoidCallback onSearch;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final dateWidget = _buildDatePicker(context);
    final shiftWidget = _buildShiftSelector(context);
    final searchBtn = _buildSearchButton(context);

    if (vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Filter Laporan',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          const SizedBox(height: 20),
          Text('Tanggal',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          dateWidget,
          const SizedBox(height: 16),
          Text('Shift',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          shiftWidget,
          const SizedBox(height: 24),
          searchBtn,
        ],
      );
    }

    // Horizontal layout
    return Row(
      children: [
        dateWidget,
        const SizedBox(width: 12),
        Expanded(child: shiftWidget),
        const SizedBox(width: 12),
        SizedBox(
          height: 40,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColorStyle.appBarBackground(),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            icon: const Icon(Icons.search, size: 18),
            label: Text('Cari',
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w500)),
            onPressed: onSearch,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    return InkWell(
      onTap: () async {
        final firstDate = DateTime.now().subtract(const Duration(days: 365));
        final result = await showCalendarDatePicker2Dialog(
          context: context,
          dialogSize: const Size(325, 400),
          dialogBackgroundColor: Colors.white,
          config: CalendarDatePicker2WithActionButtonsConfig(
            firstDate: firstDate,
            lastDate: DateTime.now(),
            selectedDayHighlightColor: CustomColorStyle.bluePrimary(),
            daySplashColor: Colors.lightBlue,
            calendarType: CalendarDatePicker2Type.single,
          ),
          value: [selectedDate],
        );
        if (result != null && result.isNotEmpty && result[0] != null) {
          onDateChanged(result[0]!);
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade50,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 16, color: CustomColorStyle.appBarBackground()),
            const SizedBox(width: 8),
            Text(fmt.format(selectedDate),
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftSelector(BuildContext context) {
    const shifts = [
      ('Shift 1', '1'),
      ('Shift 2', '2'),
      ('Full Day', 'FULLDAY'),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: shifts.map((e) {
        final isSelected = selectedShift == e.$2;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: GestureDetector(
            onTap: () => onShiftChanged(e.$2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? CustomColorStyle.appBarBackground()
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? CustomColorStyle.appBarBackground()
                      : Colors.grey.shade300,
                ),
              ),
              child: Text(
                e.$1,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColorStyle.appBarBackground(),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.search),
        label: Text('Cari Laporan',
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w500)),
        onPressed: onSearch,
      ),
    );
  }
}

// ── Report Preview ────────────────────────────────────────────────────────────

class _ReportPreview extends StatelessWidget {
  const _ReportPreview({required this.data});
  final XSalesReportData data;

  static final _currency = NumberFormat('#,##0', 'id_ID');
  static final _dateHdr = DateFormat('dd MMM yyyy, HH:mm');

  String _fmt(num v) => _currency.format(v);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeaderCard(),
        const SizedBox(height: 12),
        _buildSalesSummaryCard(),
        const SizedBox(height: 12),
        _buildPaymentMediaCard(),
        const SizedBox(height: 12),
        _buildTotalsCard(),
        const SizedBox(height: 12),
        _buildVoidCard(),
        const SizedBox(height: 12),
        _buildSettlementCard(),
        const SizedBox(height: 12),
        _buildNetSalesCard(),
        const SizedBox(height: 12),
        _buildBillsCard(),
        const SizedBox(height: 12),
        _buildGroupSalesCard(),
        const SizedBox(height: 12),
        _buildGroupFocCard(),
        const SizedBox(height: 12),
        _buildSalesCategoryCard(),
        const SizedBox(height: 12),
        _buildDiscountCard(),
        const SizedBox(height: 12),
        _buildSalesCashCard(),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Cards ──────────────────────────────────────────────────────────────────

  Widget _buildHeaderCard() {
    return _Card(
      child: Column(
        children: [
          Text(data.outletName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 4),
          Text('RESTAURANT . LOUNGE & BAR',
              style: GoogleFonts.poppins(
                  fontSize: 11, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 12),
          _InfoRow(label: 'Report', value: data.reportTitle),
          _InfoRow(label: 'Tanggal', value: _dateHdr.format(data.reportDate)),
          _InfoRow(label: 'Report No', value: data.reportNo),
          _InfoRow(label: 'Group', value: data.group),
        ],
      ),
    );
  }

  Widget _buildSalesSummaryCard() {
    final s = data.summary;
    return _Card(
      title: 'Ringkasan Penjualan',
      child: Column(
        children: [
          _TableHeader(),
          _TableRow(label: 'ItemSales', sign: '+', qty: s.itemSalesQty, amount: s.itemSalesAmount),
          _TableRow(label: 'ItemDiscount', sign: '-', qty: s.itemDiscountQty, amount: s.itemDiscountAmount),
          _TableRow(label: 'BillDiscount', sign: '-', qty: s.billDiscountQty, amount: s.billDiscountAmount),
          _TableRow(label: 'FOC Item', sign: '-', qty: s.focItemQty, amount: s.focItemAmount),
          _TableRow(label: 'FOC Bill', sign: '-', qty: s.focBillQty, amount: s.focBillAmount),
          const Divider(height: 16),
          _TableRow(label: 'Total Sales', qty: s.totalQty, amount: s.totalAmount, isBold: true),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: Text('Estimated Sales', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600))),
              Text(_fmt(s.estimatedSales), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMediaCard() {
    return _Card(
      title: 'Media Pembayaran',
      child: Column(
        children: [
          _TableHeader(),
          ...data.paymentMedia.items.map((e) => _TableRow(label: e.name, qty: e.qty, amount: e.amount)),
        ],
      ),
    );
  }

  Widget _buildTotalsCard() {
    final t = data.totals;
    return _Card(
      title: 'Total per Jenis',
      child: Column(
        children: [
          _SummaryRow(label: 'Total CARD', qty: t.cardQty, amount: t.cardAmount, color: Colors.blue.shade700),
          _SummaryRow(label: 'Total CASH', qty: t.cashQty, amount: t.cashAmount, color: Colors.green.shade700),
          _SummaryRow(label: 'Total VOUCHER', qty: t.voucherQty, amount: t.voucherAmount, color: Colors.orange.shade700),
        ],
      ),
    );
  }

  Widget _buildVoidCard() {
    final v = data.voidData;
    return _Card(
      title: 'Void / Refund',
      child: Column(
        children: [
          _TableHeader(),
          _TableRow(label: 'Pre-Send Void', qty: v.preSendQty, amount: v.preSendAmount),
          _TableRow(label: 'Post-Send Void', qty: v.postSendQty, amount: v.postSendAmount),
        ],
      ),
    );
  }

  Widget _buildSettlementCard() {
    final s = data.settlement;
    final tn = data.taxNet;
    return _Card(
      title: 'Settlement',
      child: Column(
        children: [
          _TableHeader(),
          _TableRow(label: 'ExtCollection', qty: s.extCollectionQty, amount: s.extCollectionAmount),
          _TableRow(label: 'ExtCollection + FOC', qty: s.extCollectionFocQty, amount: s.extCollectionFocAmount),
          const Divider(height: 16),
          _InfoRow(label: 'PB1', value: _fmt(tn.pb1Amount)),
          _InfoRow(label: 'Service Charge', value: _fmt(tn.scAmount)),
        ],
      ),
    );
  }

  Widget _buildNetSalesCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColorStyle.appBarBackground(),
            CustomColorStyle.bluePrimary(),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: CustomColorStyle.appBarBackground().withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          const Icon(Icons.monetization_on_outlined,
              color: Colors.white, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Net Sales',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                AutoSizeText(
                  'Rp ${_fmt(data.taxNet.netSales)}',
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsCard() {
    final b = data.bills;
    return _Card(
      title: 'Tagihan',
      child: Column(
        children: [
          _InfoRow(label: 'Bills Pending', value: b.pending.toString(), valueColor: b.pending > 0 ? Colors.red.shade600 : Colors.green.shade600),
          const Divider(height: 16),
          _InfoRow(label: 'Total # Bills', value: b.totalCount.toString()),
          _InfoRow(label: 'Total Bills', value: 'Rp ${_fmt(b.totalAmount)}'),
          _InfoRow(label: 'Total # Covers', value: b.totalCovers.toString()),
          _InfoRow(label: 'Avg Covers', value: 'Rp ${_fmt(b.avgCovers)}'),
          const Divider(height: 16),
          _InfoRow(label: 'Best Receipt #', value: b.bestReceiptNo),
          _InfoRow(label: '2nd Receipt #', value: b.secondReceiptNo),
        ],
      ),
    );
  }

  Widget _buildGroupSalesCard() {
    final gs = data.groupSales;
    return _Card(
      title: 'Group Sales',
      child: Column(
        children: [
          _TableHeader(showQty: false),
          ...gs.items.map((e) => _TableRow(label: e.name, qty: e.qty, amount: e.amount, showQty: false)),
          const Divider(height: 16),
          _TableRow(label: 'Total Group', amount: gs.total, isBold: true, showQty: false),
        ],
      ),
    );
  }

  Widget _buildGroupFocCard() {
    final gf = data.groupFoc;
    return _Card(
      title: 'Group FOC',
      child: Column(
        children: [
          _TableHeader(showQty: false),
          ...gf.items.map((e) => _TableRow(label: e.name, qty: e.qty, amount: e.amount, showQty: false)),
          const Divider(height: 16),
          _TableRow(label: 'Total FOC', amount: gf.total, isBold: true, showQty: false),
        ],
      ),
    );
  }

  Widget _buildSalesCategoryCard() {
    return _Card(
      title: 'Sales Category',
      child: Column(
        children: [
          _TableHeader(),
          ...data.salesCategory.items.map((e) => _TableRow(label: e.name, qty: e.qty, amount: e.amount)),
        ],
      ),
    );
  }

  Widget _buildDiscountCard() {
    final d = data.discount;
    return _Card(
      title: 'Diskon / Promosi',
      child: Column(
        children: [
          _TableHeader(),
          ...d.items.map((e) => _TableRow(label: e.name, qty: e.qty, amount: e.amount)),
          const Divider(height: 16),
          _TableRow(label: 'Total Diskon', amount: d.total, isBold: true, showQty: false),
        ],
      ),
    );
  }

  Widget _buildSalesCashCard() {
    return _Card(
      title: 'Sales Cash',
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text('Cash In Drawer', style: GoogleFonts.poppins(fontSize: 13))),
          Text(
            'Rp ${_fmt(data.cash.salesCash)}',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade700),
          ),
        ],
      ),
    );
  }
}

// ── Shared Sub-Widgets ────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child, this.title});
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: CustomColorStyle.appBarBackground()
                    .withValues(alpha: 0.08),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14)),
              ),
              child: Text(
                title!,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: CustomColorStyle.appBarBackground(),
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({this.showQty = true});
  final bool showQty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
              child: Text('Keterangan',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600))),
          if (showQty)
            SizedBox(
              width: 40,
              child: Text('Qty',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600)),
            ),
          SizedBox(
            width: 110,
            child: Text('Amount',
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.label,
    this.sign,
    this.qty = 0,
    required this.amount,
    this.isBold = false,
    this.showQty = true,
  });

  final String label;
  final String? sign;
  final int qty;
  final num amount;
  final bool isBold;
  final bool showQty;

  static final _currency = NumberFormat('#,##0', 'id_ID');

  @override
  Widget build(BuildContext context) {
    final amtStr = amount == 0 ? '-' : _currency.format(amount);
    final baseStyle = GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      color: isBold ? Colors.black87 : Colors.black54,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (sign != null)
            SizedBox(
              width: 16,
              child: Text(sign!,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: sign == '+'
                          ? Colors.green.shade600
                          : Colors.red.shade400,
                      fontWeight: FontWeight.w600)),
            ),
          Expanded(child: Text(label, style: baseStyle)),
          if (showQty)
            SizedBox(
              width: 40,
              child: Text(qty == 0 ? '-' : qty.toString(),
                  textAlign: TextAlign.center,
                  style: baseStyle.copyWith(fontSize: 12)),
            ),
          SizedBox(
            width: 110,
            child: Text(amtStr,
                textAlign: TextAlign.right,
                style: baseStyle.copyWith(
                    fontFeatures: [
                      const FontFeature.tabularFigures(),
                    ])),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: Colors.black54))),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? Colors.black87)),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.qty,
    required this.amount,
    required this.color,
  });

  final String label;
  final int qty;
  final num amount;
  final Color color;

  static final _currency = NumberFormat('#,##0', 'id_ID');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color)),
                Text('${qty == 0 ? 0 : qty} transaksi',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Text(
            'Rp ${_currency.format(amount)}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
