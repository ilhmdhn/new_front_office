import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SoldOutDialog {

static Future<List<FnBModel>> showSoldOutSelector(BuildContext context) async {
    
    final PagingController<int, FnBModel> pagingController = PagingController(firstPageKey: 1);
    final TextEditingController searchController = TextEditingController();
    final List<FnBModel> itemSold = [];

    Future<void> fetchPage(int pageKey)async{
      try{
        String searchQuery = searchController.text.trim();
        final getFnb = await ApiRequest().fnbPage(pageKey, '', searchQuery);
        if(getFnb.state != true){
          throw getFnb.message.toString();
        }
        List<FnBModel> listFnb = List.empty(growable: true);
        listFnb = getFnb.data??List.empty();
        if(listFnb.length < 10){
          pagingController.appendLastPage(listFnb);
        }else{
          pagingController.appendPage(listFnb, pageKey+1);
        }
      }catch(e){
        showToastWarning(e.toString());
        pagingController.error = e;
      }
    }

    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });

    final List<FnBModel>? result = await showDialog<List<FnBModel>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              titlePadding: EdgeInsets.zero,
              backgroundColor: CustomColorStyle.background(),
              title: Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Set Stok Habis',
                      style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pilih menu yang sudah tidak tersedia',
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey[600], fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 12,),
                    TextField(
                      controller: searchController,
                      onChanged: (value) {
                        pagingController.refresh();
                      },
                      style: CustomTextStyle.blackStandard(),
                      decoration: InputDecoration(
                        hintText: 'Cari...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBDBD),
                            width: 0.4,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    )
                  ],
                ),
              ),
              content: Container(
                width: double.maxFinite,
                constraints: const BoxConstraints(
                  maxHeight: 400,
                  minHeight: 200,
                ),
                child: PagedListView<int, FnBModel>(
                  shrinkWrap: true,
                  pagingController: pagingController, 
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (ctxPaginng, item, index){
                      return Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9)
                        ),
                        child: CheckboxListTile(
                          activeColor: const Color(0xFF1976D2),
                          checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          title: Text(
                            item.name ?? '-',
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          subtitle: Text(item.invCode ?? '', style: const TextStyle(fontSize: 12)),
                          value: itemSold.any((e) => e.invCode == item.invCode) || item.soldOut == true,
                          onChanged: (bool? value) async{
                                        
                            if(value == true){
                              itemSold.add(item);
                            } else {
                              if(item.soldOut == true){
                                final confirmed = await ConfirmationDialog.confirmation(context, 'Stok ${item.name} tersedia?');
                                if(confirmed != true){
                                  return;
                                }
                                final modifState = await ApiRequest().setSoldOut(item.invCode!, value??false);                          
                                  if(modifState.state != true){
                                  showToastWarning(modifState.message.toString());
                                  return;
                                }
                                item.soldOut = false;
                              }
                              itemSold.remove(item);
                            }
                            setState(() {
                              itemSold;
                              item;
                            });
                          },
                        ),
                      );
                  
                    }
                  )
                )
              ),
              // actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                ElevatedButton(
                  style: CustomButtonStyle.cancel(),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 4,),
                ElevatedButton(
                  style: CustomButtonStyle.bluePrimary(),
                  onPressed: () => Navigator.pop(context, itemSold),
                  child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
    return result ?? [];
  }
}