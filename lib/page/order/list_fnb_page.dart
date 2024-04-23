import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListFnbPage extends StatefulWidget {
  const ListFnbPage({super.key});
  static const nameRoute = '/list-fnb';

  @override
  State<ListFnbPage> createState() => _ListFnbPageState();
}

class _ListFnbPageState extends State<ListFnbPage> {

  final PagingController _fnbPagingController = PagingController(firstPageKey: 1);
  String category = '';
  final TextEditingController _searchController = TextEditingController();
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
      final getFnb = await ApiRequest().fnbPage(pageKey, category, _searchController.text);
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

  List<FnBModel> listOrder = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body:
      isLoading == true?
      Center(
        child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground(),),
      ):
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: PagedListView(
          pagingController: _fnbPagingController,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, item, index) {
              final fnb = item as FnBModel;
              return SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(fnb.name.toString(), style: CustomTextStyle.blackStandard(), minFontSize: 11, maxLines: 1,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Formatter.formatRupiah(fnb.price??0), style: CustomTextStyle.blackStandard(),),
                        InkWell(
                          onTap: (){
                            listOrder.add(
                              FnBModel(
                                invCode: item.invCode,
                                name: item.name,
                                price: item.price,
                                location: item.location,
                                globalId: item.globalId
                              )
                            );
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
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fnbPagingController.dispose();
    super.dispose();
  }
}