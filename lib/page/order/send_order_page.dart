import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/dialog/fnb_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/execute_printer.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';

class SendOrderPage extends StatefulWidget {
  final DetailCheckinModel detailCheckin;
  const SendOrderPage({super.key, required this.detailCheckin});

  @override
  State<SendOrderPage> createState() => _SendOrderPageState();
}

class _SendOrderPageState extends State<SendOrderPage> {

  OrderResponse? apiResult;
  List<OrderedModel> listOrdered = List.empty(growable: true);
  List<OrderedModel> listOrderedFix = List.empty(growable: true);

  bool isLoading = true;

  void getData()async{
    setState(() {
      isLoading = true;
    });
    listOrderedFix = [];
    apiResult = await ApiRequest().getOrder(widget.detailCheckin.roomCode);
    if(isNotNullOrEmpty(apiResult?.data)){

      listOrdered =  apiResult?.data?.where((element) => element.orderState == '1' || element.orderState == '2' || element.orderState == '3').toList()??List.empty();

    listOrdered.sort((a, b) {
       // Mengurutkan berdasarkan orderState secara ascending
  int orderStateComparison = a.orderState!.compareTo(b.orderState!);
  if (orderStateComparison != 0) {
    return orderStateComparison;
  }

  // Jika orderState sama, maka urutkan berdasarkan orderSol secara descending
  int orderSolComparison = b.sol!.compareTo(a.sol!);
  if (orderSolComparison != 0) {
    return orderSolComparison;
  }

  // Jika orderSol sama, maka urutkan berdasarkan orderUrutan secara ascending
  return a.queue!.compareTo(b.queue!);  
    });
    }

    for(var item in listOrdered){
      listOrderedFix.add(
        OrderedModel(
          sol: item.sol,
          invCode: item.invCode,
          qty: item.qty,
          queue: item.queue,
          idGlobal: item.idGlobal,
          location: item.location,
          orderState: item.orderState,
          cancelQty: item.cancelQty,
          name: item.name,
          notes: item.notes,
          price: item.price,
        )
      );
    }

    setState(() {
      isLoading = false;
      listOrdered;
      apiResult;
      listOrderedFix;
    });
  }

  @override
  void didChangeDependencies() {
    getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final DetailCheckinModel detailCheckin = widget.detailCheckin;
    Set<String> listSol= <String>{};

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body:
      isLoading == true?
      AddOnWidget.loading():
      apiResult?.state != true?
      AddOnWidget.error(apiResult?.message):
      isNullOrEmpty(listOrdered)?
      AddOnWidget.empty():
      Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: listOrdered.length,
          shrinkWrap: true,
          itemBuilder: (ctxList, index){
            OrderedModel order = listOrdered[index];
            final isInitiated = listSol.where((element) => element == order.sol).toList();
            listSol.add(order.sol??'');
            return 
            
            order.orderState != '2'?
            
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: AutoSizeText(order.name??'name', style: CustomTextStyle.blackStandard(), maxLines: 1,)
                          ),
                          Flexible(
                            flex: 3,
                            child: AutoSizeText(order.sol??'', style: GoogleFonts.poppins(), maxLines: 1,),
                          )
                        ],
                      ),
                      const SizedBox(height: 3,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isNullOrEmpty(isInitiated)? 
                          InkWell(onTap: ()async{
                            final approve = await ConfirmationDialog.confirmation(context, 'reprint SO?');
                            if(approve == true){
                              DoPrint.printSo(order.sol??'', detailCheckin.roomCode, detailCheckin.memberName, detailCheckin.pax);
                            }
                          }, child: const Icon(Icons.print)): const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: ()async{
                                  if(order.qty! > 1){
                                    order.qty = order.qty! - 1;
                                  }else{
                                    final state = await ConfirmationDialog.confirmation(ctxList, 'Hapus ${order.name}?');
                                    if(state == true){
                                      
                                      setState(() {
                                        isLoading = true;
                                      });
                                      
                                      final removeState = await ApiRequest().cancelSo(order.invCode.toString(), order.sol??'', detailCheckin.reception, listOrderedFix[index].qty.toString());
                                      if(removeState.state != true){
                                        showToastError(removeState.message.toString());
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }else{
                                        getData();
                                      }
                                    }
                                  }
                                  
                                  setState((){
                                    // listOrder;
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
                              AutoSizeText(order.qty.toString(), style: CustomTextStyle.blackMediumSize(21), maxLines: 1, minFontSize: 11,),
                              const SizedBox(width: 9,),
                              InkWell(
                                onTap: (){
                                  setState((){
                                    order.qty = order.qty! + 1;
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
                          )
                        ],
                      ),
                      const SizedBox(height: 3,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: ()async{
                                  final noteState = await FnBDialog.note(context, order.name??'FnB Name', order.notes??'');
                                  if(noteState != null){
                                    setState(() {
                                      order.notes = noteState;
                                    });
                                  }
                                },
                                child: const Icon(Icons.notes_outlined, color: Colors.black,)
                              ),
                              const SizedBox(width: 6,),
                              AutoSizeText(order.notes??'', style: CustomTextStyle.blackStandard(), maxLines: 1,),
                            ],
                          ),
                          InkWell(
                            onTap: ()async{

                              final confirmEdit = await ConfirmationDialog.confirmation(context, 'Simpan edit order?');
                              if(confirmEdit != true){
                                return;
                              }

                              final newData = OrderedModel(invCode: order.invCode,notes: order.notes,qty: order.qty);
                              setState(() {
                                isLoading = true;
                              });

                              final revisionState = await ApiRequest().revisiOrder(newData, order.sol??'', detailCheckin.reception, listOrderedFix[index].qty.toString());
                              if(revisionState.state == true){
                                getData();
                              }else{
                                showToastError(revisionState.message??'Gagal revisi order');
                                setState(() {
                                  isLoading = false;
                                });
                              }

                            },
                            child: Container(
                              decoration: CustomContainerStyle.confirmButton(),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text('SUBMIT', style: CustomTextStyle.whiteStandard(),),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 6,)
              ],
            ):
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: AutoSizeText(order.name??'name', style: CustomTextStyle.blackStandard(), maxLines: 1,)
                          ),
                          Flexible(
                            flex: 3,
                            child: AutoSizeText(order.sol??'', style: GoogleFonts.poppins(), maxLines: 1,),
                          )
                        ],
                      ),
                      const SizedBox(height: 6,),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: CustomContainerStyle.cancelButton(),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Text('Dibatalkan', style: CustomTextStyle.whiteSize(16),),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 6,)
              ],
            );
          }),
      )
    );
  }
}