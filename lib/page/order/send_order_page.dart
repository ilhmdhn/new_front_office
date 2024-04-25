import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:google_fonts/google_fonts.dart';

class SendOrderPage extends StatefulWidget {
  final String roomCode;
  const SendOrderPage({super.key, required this.roomCode});

  @override
  State<SendOrderPage> createState() => _SendOrderPageState();
}

class _SendOrderPageState extends State<SendOrderPage> {

  OrderResponse? apiResult;

  void getData()async{
    apiResult = await ApiRequest().getOrder(widget.roomCode);

    if(isNotNullOrEmpty(apiResult?.data)){
      apiResult?.data?.sort((a, b) {
        // Mengurutkan berdasarkan sol
        int solComparison = a.sol!.compareTo(b.sol!);
        if (solComparison != 0) {
          return solComparison;
        }
        // Jika sol sama, maka urutkan berdasarkan name
        return a.name!.compareTo(b.name!);
      });
    }

    setState(() {
      apiResult;
    });
  }

  @override
  void didChangeDependencies() {
    getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    Set<String> listSol= <String>{};

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body:
      apiResult == null?
      AddOnWidget.loading():
      apiResult?.state != true?
      AddOnWidget.error(apiResult?.message):
      isNullOrEmpty(apiResult?.data)?
      AddOnWidget.empty():
      Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: apiResult?.data?.length,
          shrinkWrap: true,
          itemBuilder: (ctxList, index){
            OrderedModel order = apiResult!.data![index];
            final isInitiated = listSol.where((element) => element == order.sol).toList();
            listSol.add(order.sol??'');
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
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
                          InkWell(onTap: (){
                          
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
                                      // listOrder.removeAt(index);
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
                              const Icon(Icons.notes_outlined, color: Colors.black,),
                              AutoSizeText(order.notes??'', style: CustomTextStyle.blackStandard(), maxLines: 1,),
                            ],
                          ),
                          Container(
                            decoration: CustomContainerStyle.confirmButton(),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text('SUBMIT', style: CustomTextStyle.whiteStandard(),),
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