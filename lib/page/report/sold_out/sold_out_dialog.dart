import 'package:flutter/material.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SoldOutDialog {
  static Future<List<FnBModel>> showSoldOutSelector(BuildContext context) async {
    final PagingController<int, FnBModel> pagingController = PagingController(firstPageKey: 1);
    final TextEditingController searchController = TextEditingController();
    final List<FnBModel> itemSold = [];

    Future<void> fetchPage(int pageKey) async {
      try {
        String searchQuery = searchController.text.trim();
        final getFnb = await ApiRequest().fnbPage(pageKey, '', searchQuery);
        if (getFnb.state != true) {
          throw getFnb.message.toString();
        }
        List<FnBModel> listFnb = getFnb.data ?? [];
        if (listFnb.length < 10) {
          pagingController.appendLastPage(listFnb);
        } else {
          pagingController.appendPage(listFnb, pageKey + 1);
        }
      } catch (e) {
        showToastWarning(e.toString());
        pagingController.error = e;
      }
    }

    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });

    final List<FnBModel>? result = await showDialog<List<FnBModel>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final isDesktopLandscape = context.isDesktop && context.isLandscape;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(isDesktopLandscape ? 40 : 20),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktopLandscape ? 600 : 500,
                  maxHeight: isDesktopLandscape ? context.height * 0.85 : context.height * 0.8,
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
                    _buildHeader(context, searchController, pagingController, isDesktopLandscape),
                    // Content
                    Flexible(
                      child: _buildContent(
                        context,
                        pagingController,
                        itemSold,
                        setState,
                        isDesktopLandscape,
                      ),
                    ),
                    // Actions
                    _buildActions(context, itemSold),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    pagingController.dispose();
    searchController.dispose();

    return result ?? [];
  }

  static Widget _buildHeader(
    BuildContext context,
    TextEditingController searchController,
    PagingController<int, FnBModel> pagingController,
    bool isDesktopLandscape,
  ) {
    return Container(
      padding: EdgeInsets.all(isDesktopLandscape ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade600, Colors.orange.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set Stok Habis',
                      style: GoogleFonts.poppins(
                        fontSize: isDesktopLandscape ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Pilih menu yang sudah tidak tersedia',
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
          const SizedBox(height: 16),
          // Search Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) => pagingController.refresh(),
              decoration: InputDecoration(
                hintText: 'Cari menu...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.orange.shade600),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildContent(
    BuildContext context,
    PagingController<int, FnBModel> pagingController,
    List<FnBModel> itemSold,
    StateSetter setState,
    bool isDesktopLandscape,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: PagedListView<int, FnBModel>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<FnBModel>(
          itemBuilder: (ctx, item, index) {
            final bool isSelected = itemSold.any((e) => e.invCode == item.invCode) || item.soldOut == true;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange.shade50 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.orange.shade300 : Colors.grey.shade200,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    if (!isSelected) {
                      itemSold.add(item);
                    } else {
                      if (item.soldOut == true) {
                        final confirmed = await ConfirmationDialog.confirmation(
                          context,
                          'Stok ${item.name} tersedia?',
                        );
                        if (confirmed != true) return;

                        final modifState = await ApiRequest().setSoldOut(item.invCode!, false);
                        if (modifState.state != true) {
                          showToastWarning(modifState.message.toString());
                          return;
                        }
                        item.soldOut = false;
                      }
                      itemSold.removeWhere((e) => e.invCode == item.invCode);
                    }
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.all(isDesktopLandscape ? 14 : 12),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.orange.shade500 : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected ? Colors.orange.shade500 : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name ?? '-',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.invCode ?? '',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                        if (item.soldOut == true)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Sold Out',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          firstPageProgressIndicatorBuilder: (context) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: CircularProgressIndicator(color: Colors.orange.shade600),
            ),
          ),
          newPageProgressIndicatorBuilder: (context) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CircularProgressIndicator(color: Colors.orange.shade600, strokeWidth: 2),
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'Menu tidak ditemukan',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          firstPageErrorIndicatorBuilder: (context) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'Error loading data',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => pagingController.refresh(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildActions(BuildContext context, List<FnBModel> itemSold) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          if (itemSold.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${itemSold.length} dipilih',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade800,
                ),
              ),
            ),
          const Spacer(),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Batal'),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, itemSold),
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Simpan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
