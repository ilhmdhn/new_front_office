import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/report/sold_out/sold_out_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SoldOutPage extends StatefulWidget {
  const SoldOutPage({super.key});
  static const nameRoute = '/SoldOut';

  @override
  State<SoldOutPage> createState() => _SoldOutPageState();
}

class _SoldOutPageState extends State<SoldOutPage> {
  final PagingController<int, FnBModel> _fnbPagingController = PagingController(firstPageKey: 1);
  FnBResultModel? response;
  

  @override
  void initState() {
    super.initState();
    debugPrint('init sold out');
    _fnbPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey)async{
    try{
      debugPrint('fetch page $pageKey');
      final getFnb = await ApiRequest().fnbSoldOutPage(pageKey, '', '');
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
      showToastError(e.toString());
      _fnbPagingController.error = e;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color:  Colors.white, //change your color here
        ),
        title: Text('Sold Out Items', style: CustomTextStyle.titleAppBar(),),
        backgroundColor: CustomColorStyle.appBarBackground(),        
      ),
      backgroundColor: CustomColorStyle.background(),
      floatingActionButton: InkWell(
        onTap: () async{
          final soldOutItems = await SoldOutDialog.showSoldOutSelector(context);
          if(isNotNullOrEmpty(soldOutItems)){
            final soldOutState = await ApiRequest().setSoldOutList(soldOutItems);
            if(soldOutState.state != true){
              showToastError('Gagal menyimpan data sold out ${soldOutState.message}');
            }
          }
          _fnbPagingController.refresh();
        },
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            color: CustomColorStyle.appBarBackground(),
            borderRadius: BorderRadius.circular(23)
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 36),),
      ),
      body:
      PagedListView<int, FnBModel>(
        pagingController: _fnbPagingController,
        builderDelegate: PagedChildBuilderDelegate<FnBModel>(
          firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
          noItemsFoundIndicatorBuilder: (context) => AddOnWidget.empty(),
          itemBuilder: (ctxPaging, item, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.white
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/icon/sold_out.png', height: 36, fit: BoxFit.cover,),
                      SizedBox(width: 12,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(item.name??'', style: CustomTextStyle.blackMedium(), minFontSize: 14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                          AutoSizeText(item.invCode??'', style: CustomTextStyle.blackStandard(), minFontSize: 14, maxLines: 1, overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: CustomButtonStyle.cancelSoft(),
                    onPressed: ()async{
                      final confirmed = await ConfirmationDialog.confirmation(context, 'Stok ${item.name} tersedia?');
                      if(confirmed == true){
                        final result = await ApiRequest().setSoldOut(item.invCode??'', false);
                        if(result.state == true){
                          _fnbPagingController.refresh();
                        }else{
                          showToastError('Gagal mengubah status stok ${item.name} ${result.message}');
                        }
                      }
                    }, 
                    child: Text('Hapus', style: CustomTextStyle.whiteSize(14),)
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}