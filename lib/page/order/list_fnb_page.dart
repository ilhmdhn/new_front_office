import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/enum/pos_type.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/data/model/post_so_response.dart';
import 'package:front_office_2/data/model/station_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/dialog/fnb_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/order/input_order_provider.dart';
import 'package:front_office_2/riverpod/provider_container.dart';
import 'package:front_office_2/riverpod/server_config_provider.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/printer/print_executor.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListFnbPage extends ConsumerStatefulWidget {
  final DetailCheckinModel detailCheckin;
  const ListFnbPage({super.key, required this.detailCheckin});

  @override
  ConsumerState<ListFnbPage> createState() => _ListFnbPageState();
}

class _ListFnbPageState extends ConsumerState<ListFnbPage> {

  final PagingController<int, FnBModel> _fnbPagingController = PagingController(firstPageKey: 1);
  String category = '';
  String _searchFnb = '';
  StationModel? choosedStation;

  @override
  void initState() {
    super.initState();
    _fnbPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey)async{
    try{
      if(choosedStation != null){
        category = choosedStation?.id.toString() ?? '';
      }else {
        category = '';
      }
      final getFnb = await ApiRequest().fnbPage(pageKey, category, _searchFnb);
      if(getFnb.state != true){
        throw getFnb.message.toString();
      }
      List<FnBModel> listFnb = List.empty(growable: true);
      listFnb = getFnb.data??List.empty();
      if(listFnb.length < 10){
        _fnbPagingController.appendLastPage(listFnb);
      }else{
        _fnbPagingController.appendPage(listFnb, pageKey+1);
      }
    }catch(e){
      showToastWarning(e.toString());
      _fnbPagingController.error = e;
    }
  }


  final posType = GlobalProviders.read(posTypeProvider);
  

  @override
  Widget build(BuildContext context) {
    final orderProv = ref.watch(inputOrderProvider) ?? [];
    final roomCode = widget.detailCheckin.roomCode;

    final totalItems = orderProv.fold(0, (sum, e) => sum + e.qty);

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: context.isLandscape && context.isDesktop
              ? _desktopLandscapePage(orderProv)
              : _defaultPage(orderProv),
        ),
      ),

      floatingActionButton: orderProv.isNotEmpty && !(context.isDesktop && context.isLandscape)? Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: ElevatedButton(
          onPressed: () async {
            FnBDialog.order(context, roomCode, widget.detailCheckin.memberName);
          },
          style: CustomButtonStyle.confirm(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                'Order $totalItems items',
                style: CustomTextStyle.whiteStandard(),
              ),
              const RotatedBox(
                quarterTurns: 90,
                child: Icon(Icons.expand_circle_down_rounded, color: Colors.white),
              )
            ],
          ),
          ),
        )
              : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _defaultPage(List<SendOrderModel> orderProv){
    return Column(
            children: [
              SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: SearchBar(
                        hintText: 'Cari FnB',
                        backgroundColor: WidgetStateColor.resolveWith((states) => Colors.white),
                        surfaceTintColor: WidgetStateColor.resolveWith((states) => Colors.white),
                        shadowColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
                        onChanged: ((value){
                          if(_searchFnb != value){
                            _searchFnb = value;
                            _fnbPagingController.refresh();
                          }
                        }),
                        trailing: Iterable.generate(
                          1, (index) => const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child:  Icon(Icons.search)
                          )
                        ),
                      ),
                    ),
                    posType == PosType.restoOnlyOld || posType == PosType.restoOnlyWebBased?
                    IconButton(onPressed: ()async{
                      final currentStation = choosedStation;
                      choosedStation = await FnBDialog.getStationModel(context, choosedStation);
                      if(currentStation?.id != choosedStation?.id){
                        _fnbPagingController.refresh();
                      }
                    }, icon: FaIcon(FontAwesomeIcons.filter, color: CustomColorStyle.bluePrimary())): SizedBox.shrink()
                  ],
                ),
              ),
              const SizedBox(height: 6),
              choosedStation != null ?
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        choosedStation = null;
                        _fnbPagingController.refresh();
                      });
                    },
                    style: CustomButtonStyle.bluePrimary(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close, size: 19, color: Colors.white, fill: 1,),
                        SizedBox(width: 6,),
                        AutoSizeText(choosedStation?.name ?? '', style: CustomTextStyle.whiteSizeMedium(16),),
                      ],
                    ),
                  ),
                  SizedBox(height: 6,)
                ],
              ): SizedBox.shrink(),
              Flexible(
                child: PagedListView<int, FnBModel>(
                  shrinkWrap: true,
                  pagingController: _fnbPagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (ctxPaging, item, index) {
                      final fnb = item;
                      final indexAdded = orderProv.indexWhere(((element) => element.invCode == item.invCode));
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white
                          ),
                          
                          margin: EdgeInsets.only(
                            bottom: index == (_fnbPagingController.itemList?.length??0)-1? 56: 0
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(fnb.name.toString(), style: CustomTextStyle.blackMedium(), minFontSize: 11, maxLines: 1,),
                              const SizedBox(height: 8,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(Formatter.formatRupiah(fnb.price??0), style: CustomTextStyle.blackStandard(),),
                                  fnb.soldOut == true ?
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child:  Image.asset('assets/icon/sold_out.png', width: 64,),
                                  ):
                                  indexAdded != -1 ?
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: ()async{
                                          if(orderProv[indexAdded].qty>1){
                                            ref.read(inputOrderProvider.notifier).updateQty(orderProv[indexAdded].invCode, orderProv[indexAdded].qty - 1);
                                          }else{
                                              final state = await ConfirmationDialog.confirmation(ctxPaging, 'Hapus ${orderProv[indexAdded].name}?');
                                              if(state == true){
                                                ref.read(inputOrderProvider.notifier).deleteAt(orderProv[indexAdded].invCode);
                                              }
                                          }
                                        },
                                        child: SizedBox(
                                          height: 32,
                                          width: 32,
                                          child: Image.asset(
                                            'assets/icon/minus.png'),
                                        )
                                      ),
                                      const SizedBox(width: 9,),
                                      AutoSizeText(orderProv[indexAdded].qty.toString(), style: CustomTextStyle.blackMediumSize(21), maxLines: 1, minFontSize: 11,),
                                      const SizedBox(width: 9,),
                                      InkWell(
                                        onTap: (){
                                          ref.read(inputOrderProvider.notifier).updateQty(orderProv[indexAdded].invCode, orderProv[indexAdded].qty + 1);
                                        },
                                        child: SizedBox(
                                          height: 32,
                                          width: 32,
                                          child: Image.asset(
                                            'assets/icon/plus.png'),
                                        )
                                      ),
                                    ],
                                  ):
                                  ElevatedButton(
                                    onPressed: (){
                                      ref.read(inputOrderProvider.notifier).addedFood(
                                        SendOrderModel(
                                          invCode: item.invCode??'',
                                          qty: 1,
                                          note: '',
                                          price: item.price??0,
                                          name: item.name ??'',
                                          location: item.location??0
                                        )
                                      );
                                    },
                                    style: CustomButtonStyle.confirm(),
                                    child: Text('TAMBAHKAN', style: CustomTextStyle.whiteStandard(),),
                                  )
                                ],
                              ),
                             ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }

  Widget _desktopLandscapePage(List<SendOrderModel> orderProv) {
    final totalItems = orderProv.fold(0, (sum, e) => sum + e.qty);
    final totalPrice = orderProv.fold<num>(0, (sum, e) => sum + (e.price * e.qty));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Panel - Menu List
          Expanded(
            flex: 3,
            child: _buildMenuPanel(orderProv),
          ),
          const SizedBox(width: 16),
          // Right Panel - Cart
          Expanded(
            flex: 2,
            child: _buildCartPanel(orderProv, totalItems, totalPrice),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuPanel(List<SendOrderModel> orderProv) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Compact Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: CustomColorStyle.bluePrimary(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.restaurant_menu, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text('Menu', style: CustomTextStyle.whiteSizeMedium(18)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.detailCheckin.roomCode,
                    style: CustomTextStyle.whiteSize(12),
                  ),
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        if (_searchFnb != value) {
                          _searchFnb = value;
                          _fnbPagingController.refresh();
                        }
                      },
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Cari menu...',
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                if (posType == PosType.restoOnlyOld || posType == PosType.restoOnlyWebBased) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () async {
                      final currentStation = choosedStation;
                      choosedStation = await FnBDialog.getStationModel(context, choosedStation);
                      if (currentStation?.id != choosedStation?.id) {
                        _fnbPagingController.refresh();
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: choosedStation != null ? CustomColorStyle.bluePrimary() : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: choosedStation != null ? Colors.white : CustomColorStyle.bluePrimary(),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Active Filter
          if (choosedStation != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: CustomColorStyle.bluePrimary(),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(choosedStation?.name ?? '', style: CustomTextStyle.whiteSize(12)),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            setState(() {
                              choosedStation = null;
                              _fnbPagingController.refresh();
                            });
                          },
                          child: const Icon(Icons.close, color: Colors.white, size: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          // Menu List - Simple Rows
          Expanded(
            child: PagedListView<int, FnBModel>(
              pagingController: _fnbPagingController,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              builderDelegate: PagedChildBuilderDelegate<FnBModel>(
                itemBuilder: (context, fnb, index) {
                  return _buildMenuItemRow(fnb, orderProv);
                },
                firstPageProgressIndicatorBuilder: (_) => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(CustomColorStyle.bluePrimary()),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Text('Menu tidak ditemukan', style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemRow(FnBModel fnb, List<SendOrderModel> orderProv) {
    final indexAdded = orderProv.indexWhere((e) => e.invCode == fnb.invCode);
    final isAdded = indexAdded != -1;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isAdded ? CustomColorStyle.bluePrimary().withAlpha(12) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: isAdded ? Border.all(color: CustomColorStyle.bluePrimary().withAlpha(60)) : null,
      ),
      child: Row(
        children: [
          // Name & Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  fnb.name ?? '',
                  style: CustomTextStyle.blackMediumSize(14),
                  maxLines: 1,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  Formatter.formatRupiah(fnb.price ?? 0),
                  style: TextStyle(
                    fontSize: 13,
                    color: CustomColorStyle.bluePrimary(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Action
          if (fnb.soldOut == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('Habis', style: TextStyle(color: Colors.red.shade700, fontSize: 11, fontWeight: FontWeight.w600)),
            )
          else if (isAdded)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQtyButtonSmall(
                  icon: Icons.remove,
                  onTap: () async {
                    if (orderProv[indexAdded].qty > 1) {
                      ref.read(inputOrderProvider.notifier).updateQty(orderProv[indexAdded].invCode, orderProv[indexAdded].qty - 1);
                    } else {
                      final state = await ConfirmationDialog.confirmation(context, 'Hapus ${orderProv[indexAdded].name}?');
                      if (state) ref.read(inputOrderProvider.notifier).deleteAt(orderProv[indexAdded].invCode);
                    }
                  },
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 28),
                  alignment: Alignment.center,
                  child: Text(orderProv[indexAdded].qty.toString(), style: CustomTextStyle.blackMediumSize(14)),
                ),
                _buildQtyButtonSmall(
                  icon: Icons.add,
                  onTap: () {
                    ref.read(inputOrderProvider.notifier).updateQty(orderProv[indexAdded].invCode, orderProv[indexAdded].qty + 1);
                  },
                ),
              ],
            )
          else
            InkWell(
              onTap: () {
                ref.read(inputOrderProvider.notifier).addedFood(
                  SendOrderModel(
                    invCode: fnb.invCode ?? '',
                    qty: 1,
                    note: '',
                    price: fnb.price ?? 0,
                    name: fnb.name ?? '',
                    location: fnb.location ?? 0,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CustomColorStyle.bluePrimary(),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('+ Tambah', style: CustomTextStyle.whiteSize(12)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQtyButtonSmall({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: CustomColorStyle.bluePrimary(),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildCartPanel(List<SendOrderModel> orderProv, int totalItems, num totalPrice) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Compact Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.orange.shade400,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text('Keranjang', style: CustomTextStyle.whiteSizeMedium(16)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(60),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('$totalItems', style: CustomTextStyle.whiteSize(12)),
                ),
                const Spacer(),
                if (orderProv.isNotEmpty)
                  InkWell(
                    onTap: () async {
                      final confirmed = await ConfirmationDialog.confirmation(context, 'Hapus Semua?');
                      if (confirmed) GlobalProviders.read(inputOrderProvider.notifier).clear();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                    ),
                  ),
              ],
            ),
          ),
          // Cart Items - Compact List
          Expanded(
            child: isNullOrEmpty(orderProv)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Text('Keranjang Kosong', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: orderProv.length,
                  itemBuilder: (context, index) => _buildCartItemCompact(orderProv[index]),
                ),
          ),
          // Footer - Total & Send Order
          if (orderProv.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                      Text(
                        Formatter.formatRupiah(totalPrice),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColorStyle.bluePrimary()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => _sendOrder(orderProv),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send, size: 18),
                          const SizedBox(width: 8),
                          Text('Kirim Order', style: CustomTextStyle.whiteSizeMedium(14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartItemCompact(SendOrderModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Name, Price & Note
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  item.name,
                  style: CustomTextStyle.blackMediumSize(13),
                  maxLines: 1,
                  minFontSize: 11,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      Formatter.formatRupiah(item.price * item.qty),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    if (item.note.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final noteResult = await FnBDialog.note(context, item.name, item.note);
                            if (noteResult != null) {
                              GlobalProviders.read(inputOrderProvider.notifier).addNote(item.invCode, noteResult);
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.notes, size: 12, color: Colors.amber.shade700),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  item.note,
                                  style: TextStyle(fontSize: 11, color: Colors.amber.shade800),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Note button (only if no note)
          if (item.note.isEmpty)
            InkWell(
              onTap: () async {
                final noteResult = await FnBDialog.note(context, item.name, item.note);
                if (noteResult != null) {
                  GlobalProviders.read(inputOrderProvider.notifier).addNote(item.invCode, noteResult);
                }
              },
              child: Icon(Icons.notes, size: 18, color: Colors.grey.shade400),
            ),
          const SizedBox(width: 8),
          // Qty controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildQtyButtonSmall(
                icon: Icons.remove,
                onTap: () async {
                  if (item.qty > 1) {
                    GlobalProviders.read(inputOrderProvider.notifier).updateQty(item.invCode, item.qty - 1);
                  } else {
                    final state = await ConfirmationDialog.confirmation(context, 'Hapus ${item.name}?');
                    if (state) GlobalProviders.read(inputOrderProvider.notifier).deleteAt(item.invCode);
                  }
                },
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 24),
                alignment: Alignment.center,
                child: Text(item.qty.toString(), style: CustomTextStyle.blackMediumSize(13)),
              ),
              _buildQtyButtonSmall(
                icon: Icons.add,
                onTap: () {
                  GlobalProviders.read(inputOrderProvider.notifier).updateQty(item.invCode, item.qty + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _sendOrder(List<SendOrderModel> orderProv) async {
    try {
      final PostSoResponse orderState = await ApiRequest().sendOrder(
        widget.detailCheckin.roomCode,
        widget.detailCheckin.reception,
        widget.detailCheckin.roomType,
        widget.detailCheckin.minuteRemaining,
        orderProv,
      );
      if (!orderState.state) {
        showToastError(orderState.message ?? 'SO error');
        return;
      }
      GlobalProviders.read(inputOrderProvider.notifier).clear();
      Future.microtask(() async {
        final pos = GlobalProviders.read(posTypeProvider);
        if (pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased) {
          if (isNotNullOrEmpty(orderState.data)) {
            final lastSoState = await ApiRequest().latestSo(widget.detailCheckin.reception);
            if (lastSoState.state == true) {
              final soCode = lastSoState.data;
              final filteredData = (orderState.data ?? []).where((e) => e.sol == soCode).toList();
              final doState = await ApiRequest().confirmDo(widget.detailCheckin.roomCode, filteredData);
              if (doState.state == true) {
                await PrintExecutor.printDoResto(
                  orderState,
                  widget.detailCheckin.roomCode,
                  widget.detailCheckin.memberName,
                  widget.detailCheckin.pax,
                );
              } else {
                showToastError('Ada error ${doState.message}');
              }
            }
          }
        } else {
          await PrintExecutor.printLastSo(
            widget.detailCheckin.reception,
            widget.detailCheckin.roomCode,
            widget.detailCheckin.memberName,
            widget.detailCheckin.pax,
          );
        }
      });
    } catch (e) {
      showToastError('Error: $e');
    }
  }

  @override
  void dispose() {
    _fnbPagingController.dispose();
    super.dispose();
  }
}