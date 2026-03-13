import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/enum/pos_type.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/order_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';

class DoneOrderPage extends StatefulWidget {
  final DetailCheckinModel detailCheckin;
  const DoneOrderPage({super.key, required this.detailCheckin});

  @override
  State<DoneOrderPage> createState() => _DoneOrderPageState();
}

class _DoneOrderPageState extends State<DoneOrderPage> {

  OrderResponse? apiResult;
  bool isLoading = true;
  List<OrderedModel> listOrder = List.empty(growable: true);

  void getData()async{
    setState(() {
      isLoading = true;
    });
    apiResult = await ApiRequest().getOrder(widget.detailCheckin.roomCode);

    if(isNotNullOrEmpty(apiResult?.data)){

      listOrder = apiResult!.data!.where((element) => element.orderState == '5' &&  (element.qty??0) - (element.cancelQty??0) >0).toList();

      apiResult?.data?.sort((a, b) {
        int solComparison = a.sol!.compareTo(b.sol!);
        if (solComparison != 0) {
          return solComparison;
        }
        return a.name!.compareTo(b.name!);
      });
    }

    setState(() {
      isLoading = false;
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
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body: 
        apiResult == null ?
          AddOnWidget.loading():
        apiResult?.state != true?
          AddOnWidget.error(apiResult?.message):
        isNullOrEmpty(listOrder)?
          AddOnWidget.empty():
        Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: listOrder.length,
            shrinkWrap: true,
            itemBuilder: (ctxList, index){
              final order = listOrder[index];
              num price = (order.price??0) * ((order.qty??0) - (order.cancelQty??0));
              int qty = (order.qty??0) - (order.cancelQty??0);
              return InkWell(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (ctxDialog) {
                      // Fungsi helper lokal agar baris informasi terlihat rapi
                      Widget buildDetailRow(String label, String value) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: AutoSizeText(
                                  label,
                                  style: CustomTextStyle.blackStandard().copyWith(
                                    color: Colors.blueGrey.shade700,
                                  ),
                                  maxLines: 1,
                                  minFontSize: 12,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: AutoSizeText(
                                  value,
                                  textAlign: TextAlign.right,
                                  style: CustomTextStyle.blackStandard(),
                                  maxLines: 2,
                                  minFontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: CustomColorStyle.background(), // Nuansa light blue utama
                        elevation: 4,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue.shade200, width: 1.5),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bagian Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.receipt_long_rounded, color: Colors.blue.shade700),
                                      const SizedBox(width: 8),
                                      AutoSizeText(
                                        'Detail Order',
                                        style: CustomTextStyle.blackMedium(),
                                        maxLines: 1,
                                        minFontSize: 14,
                                      ),
                                    ],
                                  ),
                                  // Tombol Close (X)
                                  GestureDetector(
                                    onTap: () => Navigator.of(ctxDialog).pop(),
                                    child: Icon(Icons.close_rounded, color: Colors.blue.shade400, size: 22),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 12),
                              Divider(color: Colors.blue.shade200, thickness: 1),
                              const SizedBox(height: 16),

                              // Bagian Konten
                              buildDetailRow('Terkirim', order.deliveredAt != null ? Formatter.formatDateTime(order.deliveredAt!) : '-'),
                              buildDetailRow('User', order.user ?? '-'),
                              buildDetailRow('Room', order.roomCode ?? '-'),
                              buildDetailRow('SO', order.sol ?? '-'),
                              
                              const SizedBox(height: 12),
                              
                              // Tombol Tutup (Opsional, bisa dihapus jika cukup pakai (X) di atas)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(ctxDialog).pop(),
                                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    Container(
                      decoration: CustomContainerStyle.whiteList(),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                child: AutoSizeText(order.sol??'sol null', style: CustomTextStyle .blackStandard(), maxLines: 1, minFontSize: 9,)
                              ),
                              Flexible(
                                flex: 1,
                                child: AutoSizeText(Formatter.formatRupiah(price), style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
                              ),
                            ],
                          ),
                          const SizedBox(height: 12,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: AutoSizeText('${qty}x ${order.name} ', style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
                              ),
                              ElevatedButton(
                                onPressed: ()async{
                                  final userLevel = GlobalProviders.read(userProvider).level;
                              
                                  final pos = GlobalProviders.read(posTypeProvider);
                                  final isSpecialOutlet = pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased;
                                  
                                  final allowedRoles = ['KASIR', 'ACCOUNTING', 'SUPERVISOR', 'KAPTEN'];
                                  if (!isSpecialOutlet && !allowedRoles.contains(userLevel)) {
                                    showToastWarning('$userLevel Tidak memiliki akses');
                                    return;
                                  }
                                  
                                  final cancelQty = await ConfirmationDialog.confirmationCancelDo(context, order.name.toString(), qty, widget.detailCheckin);
                                  if(cancelQty > 0){
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final cancelState = await ApiRequest().cancelDo(widget.detailCheckin.roomCode, order, cancelQty);
                                    if(cancelState.state !=true){
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }else{
                                      getData();
                                    }
                                  }
                                },
                                style: CustomButtonStyle.cancel(),
                                child: Text('CANCEL', style: CustomTextStyle.whiteSize(16),),
                              )
                            ],
                          ),
                        isNotNullOrEmpty(order.notes)?
                        Row(
                          children: [
                            AutoSizeText('note: ${order.notes??''}', style: CustomTextStyle.blackStandard(), maxLines: 3,),
                          ],
                        ): const SizedBox()
                        ],
                      ),
                    ),
                    const SizedBox(height: 6,)
                  ],
                ),
              );
            }),
        ),
    );
  }
}