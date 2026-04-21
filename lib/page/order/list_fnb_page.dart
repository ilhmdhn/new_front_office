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
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/dialog/fnb_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
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

  Widget _desktopLandscapePage(List<SendOrderModel> orderProv){
    return Row(children: [
      Expanded(
        child: Column(
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
        )
      ), 
      Expanded(
        child: Column(
          children: [
            Text('Item Ditambahkan', style: CustomTextStyle.blackMediumSize(21),),
            isNullOrEmpty(orderProv)?
            Expanded(child: Center(child: AddOnWidget.empty())):
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: orderProv.length,
                      itemBuilder: (ctxList, index,){
                        final thisItem = orderProv[index];
                        return Container(
                          decoration: CustomContainerStyle.whiteList(),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: AutoSizeText(
                                      thisItem.name,
                                      maxLines: 2,
                                      minFontSize: 9,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (thisItem.qty > 1) {
                                            GlobalProviders.read(inputOrderProvider.notifier).updateQty(thisItem.invCode, thisItem.qty - 1);
                                          } else {
                                            final state = await ConfirmationDialog.confirmation(ctxList, 'Hapus ${thisItem.name}?');
                                            if (state == true) {
                                              GlobalProviders.read(inputOrderProvider.notifier).deleteAt(thisItem.invCode);
                                            }
                                          }
                                        },
                                        child: SizedBox(
                                          height: 32,
                                          width: 32,
                                          child: Image.asset('assets/icon/minus.png'),
                                        ),
                                      ),
                                      const SizedBox(width: 9),
                                      AutoSizeText(
                                        thisItem.qty.toString(),
                                        style: CustomTextStyle.blackMediumSize(21),
                                      ),
                                      const SizedBox(width: 9),
                                      InkWell(
                                        onTap: () {
                                          GlobalProviders.read(inputOrderProvider.notifier).updateQty(thisItem.invCode, thisItem.qty + 1);
                                        },
                                        child: SizedBox(
                                          height: 32,
                                          width: 32,
                                          child: Image.asset(
                                              'assets/icon/plus.png'),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      final noteResult = await FnBDialog.note(context, thisItem.name, thisItem.note);
                                      if (noteResult != null) {
                                        GlobalProviders.read(inputOrderProvider.notifier).addNote(thisItem.invCode, noteResult);
                                      }
                                    },
                                    child: const Icon(Icons.notes),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: AutoSizeText(
                                      thisItem.note,
                                      style: CustomTextStyle.blackStandard(),
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: CustomButtonStyle.cancel(),
                          child: AutoSizeText(
                            'Clear',
                            style: CustomTextStyle.whiteSizeMedium(16),
                          ),
                          onPressed: () async {
                            final confirmed = await ConfirmationDialog.confirmation(context, 'Hapus Semua?');
                            if(confirmed){
                              GlobalProviders.read(inputOrderProvider.notifier).clear();
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 36,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: CustomButtonStyle.blueAppbar(),
                          child: AutoSizeText(
                            'SEND ORDER',
                            style: CustomTextStyle.whiteSizeMedium(16),
                          ),
                          onPressed: () async {
                            try {
                              final PostSoResponse orderState = await ApiRequest().sendOrder(widget.detailCheckin.roomCode, widget.detailCheckin.reception, widget.detailCheckin.roomType, widget.detailCheckin.minuteRemaining, orderProv);
                              if (!orderState.state) {
                                showToastError(orderState.message??'SO error');
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
                                        await PrintExecutor.printDoResto(orderState,widget.detailCheckin.roomCode, widget.detailCheckin.memberName, widget.detailCheckin.pax);
                                      }else{
                                        showToastError('Ada error ${doState.message}');
                                      }
                                    }
                                  }
                                } else {
                                  // await PrintExecutor.printLastSo(rcp, roomCode, checkinDetail.data?.memberName ?? 'Guest', checkinDetail.data?.pax ?? 1);
                                  await PrintExecutor.printLastSo(widget.detailCheckin.reception, widget.detailCheckin.roomCode, widget.detailCheckin.memberName, widget.detailCheckin.pax);
                                }
                              });
                            } catch (e) {
                              showToastError('Error: $e');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      )
    ],
    );
  }

  @override
  void dispose() {
    _fnbPagingController.dispose();
    super.dispose();
  }
}