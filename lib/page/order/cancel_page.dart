import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/cancel_order_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/formatter.dart';
import 'package:front_office_2/tools/helper.dart';

class CancelOrderPage extends StatefulWidget {
  final String invoiceCode;
  const CancelOrderPage({super.key, required this.invoiceCode});

  @override
  State<CancelOrderPage> createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {

  CancelOrderResponse? apiResult;
  List<CancelOrderModel> listOrder = List.empty(growable: true);

  void getData()async{
    apiResult = await ApiRequest().getCancelOrder(widget.invoiceCode);

    if(isNotNullOrEmpty(apiResult?.data)){

      listOrder = (apiResult?.data)??[];

      apiResult?.data?.sort((a, b) {
        int solComparison = a.cancelCode.compareTo(b.cancelCode);
        if (solComparison != 0) {
          return solComparison;
        }
        return a.name.compareTo(b.name);
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
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body: 
      apiResult == null?
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
            return Column(
              children: [
                InkWell(
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (ctxDialog) {
                        return showDetail(ctxDialog ,order);
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: AutoSizeText(order.slipCode, style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
                            ),
                            Flexible(
                              flex: 1,
                              child: AutoSizeText(Formatter.formatRupiah((order.price) * (order.cancelQty)), style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
                            ),
                          ],
                        ),
                        const SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: AutoSizeText('${order.cancelQty}x ${order.name}', style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6,)
              ],
            );
          }),
      )
      ,
    );
  }

  Dialog showDetail(BuildContext ctxDialog, CancelOrderModel order){
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
          border: Border.all(color: Colors.redAccent, width: 1.5),
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
                    Icon(Icons.receipt_long_rounded, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    AutoSizeText(
                      'Detail Pembatalan',
                      style: CustomTextStyle.blackMedium(),
                      maxLines: 1,
                      minFontSize: 14,
                    ),
                  ],
                ),
                // Tombol Close (X)
                GestureDetector(
                  onTap: () => Navigator.of(ctxDialog).pop(),
                  child: Icon(Icons.close_rounded, color: Colors.redAccent, size: 22),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.redAccent, thickness: 1),
            const SizedBox(height: 16),

            // Bagian Konten
            _buildDetailRow('Dibatalkan', Formatter.formatDateTime(order.date)),
            _buildDetailRow('User', order.user),
            _buildDetailRow('Room', order.room),
            _buildDetailRow('SO', order.slipCode),

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
  }

  Widget _buildDetailRow(String label, String value) {
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
}