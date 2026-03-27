import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/enum/pos_type.dart';
import 'package:front_office_2/data/model/cancel_model.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/data/model/order_oldroom_response.dart';
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
  OrderOldRoomResponse? oldResult;
  bool isLoading = true;
  List<OrderedModel> listOrder = List.empty(growable: true);
  List<OldRoomOrderDataModel> oldRoomList = [];
  
  void getData()async{
    setState(() {
      isLoading = true;
    });
    apiResult = await ApiRequest().getOrder(widget.detailCheckin.roomCode);
    oldResult = await ApiRequest().getOldOrder(widget.detailCheckin.invoice);

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
    if(isNotNullOrEmpty(oldResult?.data)){
      oldRoomList  =  oldResult!.data!.expand((order) => order.data).toList();
    }

    if(mounted){
      setState(() {
        isLoading = false;
        apiResult;
        oldRoomList;
      });
    }
    debugPrint('DEBUGGING $oldRoomList');
  }

  @override
  void didChangeDependencies() {
    getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final combinedList = [
      ...listOrder.map((e) => {'type': 'new', 'data': e}),
      ...oldRoomList.map((e) => {'type': 'old', 'data': e}),
    ];
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body: 
        apiResult == null || oldResult == null?
          AddOnWidget.loading():
        apiResult?.state != true?
          AddOnWidget.error(apiResult?.message):
        isNullOrEmpty(combinedList)?
          AddOnWidget.empty():
        Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: combinedList.length,
            shrinkWrap: true,
            itemBuilder: (ctxList, index){
              if(combinedList[index]['type'] == 'new'){
                return _newListItem(combinedList[index]['data'] as OrderedModel);
              }else{
                return _oldListItem(combinedList[index]['data'] as OldRoomOrderDataModel);
              }
            }
          ),
        ),
    );
  }

  Widget _newListItem(OrderedModel order){
    num price = (order.price??0) * ((order.qty??0) - (order.cancelQty??0));
    int qty = (order.qty??0) - (order.cancelQty??0);
    return InkWell(
      onTap: (){
        _showDialogNew(order);
      },
      child: Container(
        decoration: CustomContainerStyle.whiteList(),
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        margin: const EdgeInsets.only(bottom: 8),
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
                    
                    final CancelModel cancelResult = await ConfirmationDialog.confirmationCancelDo(context, order.name.toString(), qty, widget.detailCheckin);
                    if(cancelResult.qty > 0){
                      setState(() {
                        isLoading = true;
                      });
                      final cancelState = await ApiRequest().cancelDo(widget.detailCheckin.roomCode, order, cancelResult.qty, reason: cancelResult.reason);
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
                Flexible(child: AutoSizeText('note: ${order.notes??''}', style: CustomTextStyle.blackStandard(), maxLines: 3, minFontSize: 12,)),
              ],
            ): const SizedBox(),
          ],
        ),
      ),
    );      
  }
  
  Widget _oldListItem(OldRoomOrderDataModel fnbNya){
    return InkWell(
      onTap: (){
        _showDialogOld(fnbNya);
      },
      child: Container(
        decoration: CustomContainerStyle.whiteList(),
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: AutoSizeText(fnbNya.slipOrder, style: CustomTextStyle .blackStandard(), maxLines: 1, minFontSize: 9,)
                ),
                Flexible(
                  flex: 1,
                  child: AutoSizeText(Formatter.formatRupiah(fnbNya.price), style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
                ),
              ],
            ),
            const SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AutoSizeText('${fnbNya.qty}x ${fnbNya.name} ', style: CustomTextStyle.blackStandard(), maxLines: 1, minFontSize: 9,)
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
                    
                    final cancelResult = await ConfirmationDialog.confirmationCancelDo(context, fnbNya.name.toString(), fnbNya.qty, widget.detailCheckin);
                    if(cancelResult.qty > 0){
                      setState(() {
                        isLoading = true;
                      });
                      final cancelState = await ApiRequest().cancelDoOld(fnbNya.rcpCode, fnbNya, cancelResult.qty, reason: cancelResult.reason);
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
            isNotNullOrEmpty(fnbNya.note)?
            Row(
              children: [
                Flexible(child: AutoSizeText('note: ${fnbNya.note}', style: CustomTextStyle.blackStandard(), maxLines: 3, minFontSize: 12,)),
              ],
            ): const SizedBox()
          ],
        ),
      ),
    );
  }
  
  void _showDialogNew(OrderedModel order){
    showDialog(
      context: context,
      builder: (ctxDialog) {  
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
              
                _buildDetailRow('Terkirim', order.deliveredAt != null ? Formatter.formatDateTime(order.deliveredAt!) : '-'),
                _buildDetailRow('User', order.user ?? '-'),
                _buildDetailRow('Room', order.roomCode ?? '-'),
                _buildDetailRow('SO', order.sol ?? '-'),
                isNotNullOrEmpty(order.notes)?
                _buildDetailRow('note:', order.notes ?? '-'):SizedBox.shrink(),
                const SizedBox(height: 12),
                
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
  }

  void _showDialogOld(OldRoomOrderDataModel order){
    showDialog(
      context: context,
      builder: (ctxDialog) {  
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
              
                _buildDetailRow('Terkirim', Formatter.formatDateTime(order.date)),
                _buildDetailRow('User', order.user),
                _buildDetailRow('Room', order.roomCode),
                _buildDetailRow('SO', order.slipOrder),
                isNotNullOrEmpty(order.note)?
                _buildDetailRow('note:', order.note):SizedBox.shrink(),
                const SizedBox(height: 12),
                
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
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: AutoSizeText(label, style: CustomTextStyle.blackStandard().copyWith( color: Colors.blueGrey.shade700,), maxLines: 1, minFontSize: 12,),
            ),
            Expanded(
              flex: 3,
              child: AutoSizeText(
                value,
                textAlign: TextAlign.right,
                style: CustomTextStyle.blackStandard(),
                // maxLines: 2,
                minFontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  } 
}