import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// ── Models ────────────────────────────────────────────────────────────────────

class ProductionItem {
  final String name;
  final int qty;
  const ProductionItem(this.name, this.qty);
}

class ProductionDept {
  final String name;
  final List<ProductionItem> items;
  const ProductionDept(this.name, this.items);
  int get totalQty => items.fold(0, (s, e) => s + e.qty);
}

class ProductionGroup {
  final String name;
  final List<ProductionDept> depts;
  const ProductionGroup(this.name, this.depts);
  int get totalQty => depts.fold(0, (s, e) => s + e.totalQty);
}

class ProductionReportData {
  final String outletName;
  final DateTime reportDate;
  final String reportNo;
  final List<ProductionGroup> groups;
  const ProductionReportData({
    required this.outletName,
    required this.reportDate,
    required this.reportNo,
    required this.groups,
  });
}

// ── Dummy Data ────────────────────────────────────────────────────────────────

final _dummyReport = ProductionReportData(
  outletName: 'TUTTU BONO\nRESTO BAR',
  reportNo: 'P-20267',
  reportDate: DateTime(2026, 4, 20, 12, 48),
  groups: [
    ProductionGroup('BEVERAGE', [
      ProductionDept('BEER', [
        ProductionItem('Bintang Botol', 25),
        ProductionItem('Bintang Draught', 15),
        ProductionItem('Heineken Botol', 8),
        ProductionItem('Corona Extra', 6),
        ProductionItem('Hoegaarden', 4),
      ]),
      ProductionDept('COCKTAIL', [
        ProductionItem('Mojito', 12),
        ProductionItem('Margarita', 8),
        ProductionItem('Cosmopolitan', 5),
        ProductionItem('Long Island Ice Tea', 9),
        ProductionItem('Blue Lagoon', 3),
      ]),
      ProductionDept('SOFT DRINK', [
        ProductionItem('Coca Cola', 30),
        ProductionItem('Sprite', 18),
        ProductionItem('Fanta Merah', 12),
        ProductionItem('Air Mineral 600ml', 45),
        ProductionItem('Teh Botol', 22),
      ]),
      ProductionDept('JUICE', [
        ProductionItem('Jus Alpukat', 14),
        ProductionItem('Jus Mangga', 10),
        ProductionItem('Jus Jeruk', 8),
        ProductionItem('Jus Semangka', 6),
      ]),
    ]),
    ProductionGroup('ALCOHOL', [
      ProductionDept('WINE', [
        ProductionItem('Red Wine Glass', 20),
        ProductionItem('White Wine Glass', 15),
        ProductionItem('Rosé Wine Glass', 8),
        ProductionItem('Sparkling Wine', 5),
      ]),
      ProductionDept('SPIRIT', [
        ProductionItem('Vodka Shot', 18),
        ProductionItem('Whiskey On The Rock', 12),
        ProductionItem('Rum & Coke', 7),
        ProductionItem('Gin Tonic', 9),
      ]),
      ProductionDept('TEQUILA', [
        ProductionItem('Tequila Shot', 10),
        ProductionItem('Patron Silver', 5),
        ProductionItem('Jose Cuervo', 4),
      ]),
    ]),
    ProductionGroup('FOOD', [
      ProductionDept('APPETIZER', [
        ProductionItem('French Fries', 20),
        ProductionItem('Chicken Wings', 15),
        ProductionItem('Spring Roll', 8),
        ProductionItem('Calamari', 6),
      ]),
      ProductionDept('MAIN COURSE', [
        ProductionItem('Nasi Goreng Special', 25),
        ProductionItem('Pasta Carbonara', 10),
        ProductionItem('Grilled Chicken', 12),
        ProductionItem('Beef Steak', 7),
        ProductionItem('Mie Goreng', 18),
      ]),
      ProductionDept('DESSERT', [
        ProductionItem('Ice Cream Scoop', 12),
        ProductionItem('Chocolate Lava Cake', 8),
        ProductionItem('Pudding Coklat', 6),
      ]),
      ProductionDept('SNACK', [
        ProductionItem('Nachos & Salsa', 14),
        ProductionItem('Edamame', 22),
        ProductionItem('Mixed Nuts', 9),
      ]),
    ]),
    ProductionGroup('SPECIAL', [
      ProductionDept('PROMO', [
        ProductionItem('Promo Happy Hour Package', 8),
        ProductionItem('Couple Deal Package', 4),
        ProductionItem('Birthday Package', 2),
      ]),
      ProductionDept('EVENT', [
        ProductionItem('Event Tutubono Package', 6),
        ProductionItem('Corporate Package', 3),
      ]),
    ]),
  ],
);

// ── Page ──────────────────────────────────────────────────────────────────────

class RestoItemProductionReportPage extends StatefulWidget {
  const RestoItemProductionReportPage({super.key});
  static const nameRoute = '/resto-item-production-report';

  @override
  State<RestoItemProductionReportPage> createState() =>
      _RestoItemProductionReportPageState();
}

class _RestoItemProductionReportPageState
    extends State<RestoItemProductionReportPage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedShift = 'FULLDAY';
  ProductionReportData? _reportData;
  bool _isLoading = false;

  // semua dept dari dummy data
  late final List<String> _allDepts;
  late final Set<String> _selectedDepts;

  @override
  void initState() {
    super.initState();
    _allDepts = _dummyReport.groups
        .expand((g) => g.depts.map((d) => d.name))
        .toSet()
        .toList()
      ..sort();
    _selectedDepts = Set.from(_allDepts);
    _fetchReport();
  }

  void _fetchReport() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _reportData = _dummyReport;
        _isLoading = false;
      });
    });
  }

  bool get _showSidePanel => context.isTablet && context.isLandscape;

  List<ProductionGroup> get _filteredGroups {
    if (_reportData == null) return [];
    return _reportData!.groups
        .map((g) => ProductionGroup(
              g.name,
              g.depts.where((d) => _selectedDepts.contains(d.name)).toList(),
            ))
        .where((g) => g.depts.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomColorStyle.appBarBackground(),
        title: Text('Laporan Produksi Item', style: CustomTextStyle.titleAppBar()),
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
      bottomNavigationBar: _showSidePanel ? null : _buildBottomBar(),
    );
  }

  // ── Layouts ──────────────────────────────────────────────────────────────────

  Widget _buildSideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.isDesktop ? 300 : 250,
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _FilterPanel(
                selectedDate: _selectedDate,
                selectedShift: _selectedShift,
                allDepts: _allDepts,
                selectedDepts: _selectedDepts,
                onDateChanged: (d) => setState(() => _selectedDate = d),
                onShiftChanged: (s) => setState(() => _selectedShift = s),
                onDeptsChanged: (set) => setState(() => _selectedDepts
                  ..clear()
                  ..addAll(set)),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: _FilterPanel(
            selectedDate: _selectedDate,
            selectedShift: _selectedShift,
            allDepts: _allDepts,
            selectedDepts: _selectedDepts,
            onDateChanged: (d) => setState(() => _selectedDate = d),
            onShiftChanged: (s) => setState(() => _selectedShift = s),
            onDeptsChanged: (set) => setState(() => _selectedDepts
              ..clear()
              ..addAll(set)),
            onSearch: _fetchReport,
            vertical: false,
          ),
        ),
        Container(height: 1, color: Colors.grey.shade300),
        Expanded(child: _buildReportContent()),
      ],
    );
  }

  // ── Content ───────────────────────────────────────────────────────────────────

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
            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('Pilih filter lalu tekan Cari',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    final filtered = _filteredGroups;
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_list_off, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('Tidak ada data untuk dept yang dipilih',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade500)),
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
              maxWidth: context.isDesktop ? 720 : double.infinity),
          child: _ReportPreview(
            data: _reportData!,
            filteredGroups: filtered,
          ),
        ),
      ),
    );
  }

  // ── Bottom Bar ────────────────────────────────────────────────────────────────

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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.print_outlined),
          label: Text('Cetak Laporan',
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
          onPressed: _handlePrint,
        ),
      ),
    );
  }

  void _handlePrint() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fitur cetak akan segera tersedia'),
        backgroundColor: CustomColorStyle.appBarBackground(),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ── Filter Panel ──────────────────────────────────────────────────────────────

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.selectedDate,
    required this.selectedShift,
    required this.allDepts,
    required this.selectedDepts,
    required this.onDateChanged,
    required this.onShiftChanged,
    required this.onDeptsChanged,
    required this.onSearch,
    required this.vertical,
  });

  final DateTime selectedDate;
  final String selectedShift;
  final List<String> allDepts;
  final Set<String> selectedDepts;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onShiftChanged;
  final ValueChanged<Set<String>> onDeptsChanged;
  final VoidCallback onSearch;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
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
          _label('Tanggal'),
          const SizedBox(height: 6),
          _DateButton(date: selectedDate, onChanged: onDateChanged),
          const SizedBox(height: 16),
          _label('Shift'),
          const SizedBox(height: 8),
          _ShiftSelector(selected: selectedShift, onChanged: onShiftChanged),
          const SizedBox(height: 16),
          _label('Sub Kategori (Dept)'),
          const SizedBox(height: 8),
          _DeptDropdown(
            allDepts: allDepts,
            selectedDepts: selectedDepts,
            onChanged: onDeptsChanged,
            fullWidth: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColorStyle.appBarBackground(),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.search),
              label: Text('Cari Laporan',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w500)),
              onPressed: onSearch,
            ),
          ),
        ],
      );
    }

    // Horizontal (mobile/portrait)
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _DateButton(date: selectedDate, onChanged: onDateChanged),
            const SizedBox(width: 10),
            Expanded(
              child: _ShiftSelector(selected: selectedShift, onChanged: onShiftChanged),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColorStyle.appBarBackground(),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                icon: const Icon(Icons.search, size: 18),
                label: Text('Cari',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                onPressed: onSearch,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.filter_list, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 6),
            Text('Dept:',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(width: 8),
            Expanded(
              child: _DeptDropdown(
                allDepts: allDepts,
                selectedDepts: selectedDepts,
                onChanged: onDeptsChanged,
                fullWidth: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _label(String text) => Text(text,
      style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500));
}

// ── Date Button ───────────────────────────────────────────────────────────────

class _DateButton extends StatelessWidget {
  const _DateButton({required this.date, required this.onChanged});
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    return InkWell(
      onTap: () async {
        final result = await showCalendarDatePicker2Dialog(
          context: context,
          dialogSize: const Size(325, 400),
          dialogBackgroundColor: Colors.white,
          config: CalendarDatePicker2WithActionButtonsConfig(
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now(),
            selectedDayHighlightColor: CustomColorStyle.bluePrimary(),
            daySplashColor: Colors.lightBlue,
            calendarType: CalendarDatePicker2Type.single,
          ),
          value: [date],
        );
        if (result != null && result.isNotEmpty && result[0] != null) {
          onChanged(result[0]!);
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
                size: 15, color: CustomColorStyle.appBarBackground()),
            const SizedBox(width: 7),
            Text(fmt.format(date),
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

// ── Shift Selector ────────────────────────────────────────────────────────────

class _ShiftSelector extends StatelessWidget {
  const _ShiftSelector({required this.selected, required this.onChanged});
  final String selected;
  final ValueChanged<String> onChanged;

  static const _shifts = [('Shift 1', '1'), ('Shift 2', '2'), ('Full Day', 'FULLDAY')];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _shifts.map((e) {
        final isSelected = selected == e.$2;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: GestureDetector(
            onTap: () => onChanged(e.$2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              child: Text(e.$1,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black54)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Dept Dropdown Checkbox ────────────────────────────────────────────────────

class _DeptDropdown extends StatelessWidget {
  const _DeptDropdown({
    required this.allDepts,
    required this.selectedDepts,
    required this.onChanged,
    required this.fullWidth,
  });

  final List<String> allDepts;
  final Set<String> selectedDepts;
  final ValueChanged<Set<String>> onChanged;
  final bool fullWidth;

  String get _label {
    if (selectedDepts.length == allDepts.length) return 'Semua Dept';
    if (selectedDepts.isEmpty) return 'Tidak ada';
    return '${selectedDepts.length} Dept dipilih';
  }

  void _openSheet(BuildContext context) {
    final temp = Set<String>.from(selectedDepts);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _DeptSheet(
        allDepts: allDepts,
        initial: temp,
        onApply: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final btn = InkWell(
      onTap: () => _openSheet(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade50,
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Icon(Icons.category_outlined,
                size: 15, color: CustomColorStyle.appBarBackground()),
            const SizedBox(width: 7),
            Flexible(
              child: Text(_label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selectedDepts.isEmpty
                          ? Colors.red.shade400
                          : Colors.black87)),
            ),
            const SizedBox(width: 6),
            Icon(Icons.arrow_drop_down, size: 18, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
    return fullWidth ? btn : btn;
  }
}

// ── Dept Bottom Sheet ─────────────────────────────────────────────────────────

class _DeptSheet extends StatefulWidget {
  const _DeptSheet({
    required this.allDepts,
    required this.initial,
    required this.onApply,
  });
  final List<String> allDepts;
  final Set<String> initial;
  final ValueChanged<Set<String>> onApply;

  @override
  State<_DeptSheet> createState() => _DeptSheetState();
}

class _DeptSheetState extends State<_DeptSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initial);
  }

  bool get _allSelected => _selected.length == widget.allDepts.length;

  void _toggleAll() {
    setState(() {
      if (_allSelected) {
        _selected.clear();
      } else {
        _selected = Set.from(widget.allDepts);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.75;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxH),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4)),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
            child: Row(
              children: [
                Text('Pilih Sub Kategori (Dept)',
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const Spacer(),
                TextButton(
                  onPressed: _toggleAll,
                  child: Text(_allSelected ? 'Batal Semua' : 'Pilih Semua',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: CustomColorStyle.appBarBackground(),
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // List
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.allDepts.length,
              itemBuilder: (_, i) {
                final dept = widget.allDepts[i];
                final checked = _selected.contains(dept);
                return CheckboxListTile(
                  value: checked,
                  dense: true,
                  activeColor: CustomColorStyle.appBarBackground(),
                  title: Text(dept,
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
                  onChanged: (_) => setState(() {
                    if (checked) {
                      _selected.remove(dept);
                    } else {
                      _selected.add(dept);
                    }
                  }),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Footer buttons
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 12, 16, MediaQuery.of(context).padding.bottom + 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Batal',
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.black54)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColorStyle.appBarBackground(),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      widget.onApply(_selected);
                      Navigator.pop(context);
                    },
                    child: Text('Terapkan',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Report Preview ────────────────────────────────────────────────────────────

class _ReportPreview extends StatelessWidget {
  const _ReportPreview({required this.data, required this.filteredGroups});
  final ProductionReportData data;
  final List<ProductionGroup> filteredGroups;

  static final _dateFmt = DateFormat('dd MMM yyyy, HH:mm');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeaderCard(),
        const SizedBox(height: 12),
        ...filteredGroups.map((g) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GroupCard(group: g),
            )),
        _buildGrandTotalCard(filteredGroups),
        const SizedBox(height: 24),
      ],
    );
  }

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
          const SizedBox(height: 2),
          Text('RESTAURANT . LOUNGE & BAR',
              style: GoogleFonts.poppins(
                  fontSize: 11, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 12),
          _InfoRow(label: 'Laporan', value: 'X F&B Day Report'),
          _InfoRow(
              label: 'Tanggal', value: _dateFmt.format(data.reportDate)),
          _InfoRow(label: 'Report No', value: data.reportNo),
        ],
      ),
    );
  }

  Widget _buildGrandTotalCard(List<ProductionGroup> groups) {
    final total = groups.fold(0, (s, g) => s + g.totalQty);
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
            color: CustomColorStyle.appBarBackground().withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.summarize_outlined, color: Colors.white, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Text('Grand Total Produksi',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500)),
          ),
          Text('$total item',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }
}

// ── Group Card ────────────────────────────────────────────────────────────────

class _GroupCard extends StatefulWidget {
  const _GroupCard({required this.group});
  final ProductionGroup group;

  @override
  State<_GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<_GroupCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    return Container(
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
        children: [
          // Group header (tap to expand/collapse)
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(14),
              bottom: _expanded ? Radius.zero : const Radius.circular(14),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColorStyle.appBarBackground().withValues(alpha: 0.12),
                    CustomColorStyle.appBarBackground().withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(14),
                  bottom: _expanded ? Radius.zero : const Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: CustomColorStyle.appBarBackground(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'GROUP: ${group.name}',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: CustomColorStyle.appBarBackground()),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: CustomColorStyle.appBarBackground(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('${group.totalQty}',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: CustomColorStyle.appBarBackground(),
                  ),
                ],
              ),
            ),
          ),
          // Dept list
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                children: group.depts
                    .map((d) => _DeptSection(dept: d))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Dept Section ──────────────────────────────────────────────────────────────

class _DeptSection extends StatelessWidget {
  const _DeptSection({required this.dept});
  final ProductionDept dept;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        // Dept header
        Row(
          children: [
            Icon(Icons.subdirectory_arrow_right,
                size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Dept: ${dept.name}',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
            ),
            Text('${dept.totalQty}',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 6),
        // Items
        ...dept.items.map((item) => _ItemRow(item: item)),
        // Dept divider
        const Divider(height: 16, thickness: 0.5),
      ],
    );
  }
}

// ── Item Row ──────────────────────────────────────────────────────────────────

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});
  final ProductionItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const SizedBox(width: 18),
          Expanded(
            child: Text(item.name,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: item.qty > 0
                  ? CustomColorStyle.appBarBackground().withValues(alpha: 0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${item.qty}',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: item.qty > 0
                      ? CustomColorStyle.appBarBackground()
                      : Colors.grey.shade400),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

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
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
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
                  color: Colors.black87)),
        ],
      ),
    );
  }
}
