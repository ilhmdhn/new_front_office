import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/dialog/fnb_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListFnbPage extends StatefulWidget {
  final String roomCode;
  const ListFnbPage({super.key, required this.roomCode});

  @override
  State<ListFnbPage> createState() => _ListFnbPageState();
}

class _ListFnbPageState extends State<ListFnbPage> {

  final PagingController _fnbPagingController = PagingController(firstPageKey: 1);
  String category = '';
  String _searchFnb = '';
  String roomCode = '';
  bool isLoading = true;


  @override
  void initState() {
    _fetchPage(1);
    _fnbPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey)async{
    try{
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
      if(isLoading == true){
        setState(() {
          isLoading = false;
        });
      }
    }catch(e){
      _fnbPagingController.error(e);
    }
  }

  List<OrderModel> listOrder = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    int totalItems = 0;

    for (var element in listOrder) {
      totalItems += element.qty;
    }

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body:
      isLoading == true?
      Center(
        child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground(),),
      ):
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
                height: ScreenSize.getHeightPercent(context, 10),
                child: SearchBar(
                  hintText: 'Cari Room',
                  surfaceTintColor: MaterialStateColor.resolveWith((states) => Colors.white),
                  shadowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                  onChanged: ((value){
                    if(_searchFnb != value){
                      _searchFnb = value;
                      _fnbPagingController.refresh();
                    }
                  }),
                  trailing: Iterable.generate(
                    1, (index) => const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child:  Icon(Icons.search))),
                ),
              ),
              const SizedBox(height: 6),
            Flexible(
              child: PagedListView(
                shrinkWrap: true,
                pagingController: _fnbPagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (ctxPaging, item, index) {
                    final fnb = item as FnBModel;
                    final indexAdded = listOrder.indexWhere(((element) => element.invCode == item.invCode));
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white
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
                                indexAdded != -1 ?
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: ()async{
                                        if(listOrder[indexAdded].qty>1){
                                          listOrder[indexAdded].qty = listOrder[indexAdded].qty - 1;
                                        }else{
                                            final state = await ConfirmationDialog.confirmation(ctxPaging, 'Hapus ${listOrder[indexAdded].name}?');
                                            if(state == true){
                                              listOrder.removeAt(indexAdded);
                                            }
                                        }
                                        setState((){
                                          listOrder;
                                        });
                                      },
                                      child: SizedBox(
                                        height: 32,
                                        width: 32,
                                        child: Image.asset(
                                          'assets/icon/minus.png'),
                                      )
                                    ),
                                    const SizedBox(width: 9,),
                                    AutoSizeText(listOrder[indexAdded].qty.toString(), style: CustomTextStyle.blackMediumSize(21), maxLines: 1, minFontSize: 11,),
                                    const SizedBox(width: 9,),
                                    InkWell(
                                      onTap: (){
                                        setState((){
                                            listOrder[indexAdded].qty = listOrder[indexAdded].qty + 1;
                                        });
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
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                    listOrder.add(
                                      OrderModel(
                                        invCode: item.invCode??'',
                                        qty: 1,
                                        note: '',
                                        price: item.price??0,
                                        name: item.name ??'',
                                        location: item.location??0
                                      )
                                    );
                                    });
                                  },
                                  child: Container(
                                    decoration: CustomContainerStyle.blueButton(),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    child: Text('TAMBAHKAN', style: CustomTextStyle.whiteStandard(),),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: 
      isNotNullOrEmpty(listOrder)?
      InkWell(
        onTap: ()async{
          final nganu = await FnBDialog.order(context, listOrder, roomCode);
          if(nganu == true){
            setState(() {
              listOrder.clear();
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            height: ScreenSize.getHeightPercent(context, 12),
            width: double.infinity,
            decoration: CustomContainerStyle.confirmButton(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText('Order $totalItems items', style: CustomTextStyle.whiteStandard(),),
                const RotatedBox(
                  quarterTurns: 90,
                  child: Icon(Icons.expand_circle_down_rounded, color: Colors.white,))
              ],
            ),
          ),
        ),
      ): const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    _fnbPagingController.dispose();
    super.dispose();
  }
}