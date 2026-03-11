import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/enum/pos_type.dart';
import 'package:front_office_2/data/model/fnb_model.dart';
import 'package:front_office_2/data/model/post_so_response.dart';
import 'package:front_office_2/data/model/station_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/printer/print_executor.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';

class FnBDialog{
  
  static Future<String?> note(BuildContext ctx, String name, String note){
    Completer<String?> completer = Completer<String?>();
    showDialog(
      context: ctx,
      builder: (ctxDialog){
        TextEditingController tfNoteController = TextEditingController();
        tfNoteController.text = note;
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            width: ScreenSize.getSizePercent(ctxDialog, 80),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText('Tulis Catatan Pesanan', style: CustomTextStyle.blackStandard(), maxLines: 2, minFontSize: 12, textAlign: TextAlign.center,),
                AutoSizeText(name, style: CustomTextStyle.titleAlertDialogSize(16), maxLines: 2, minFontSize: 12, textAlign: TextAlign.center,),
                const SizedBox(height: 12,),
                TextField(
                  decoration: CustomTextfieldStyle.characterNormal(),
                  minLines: 1,
                  maxLines: 3,
                  controller: tfNoteController,
                ),
                const SizedBox(height: 6,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pop(ctx, null);
                        },
                        style: CustomButtonStyle.cancel(),
                        child: AutoSizeText('CANCEL', style: CustomTextStyle.whiteSize(16), maxLines: 1, textAlign: TextAlign.center,),
                      ),
                    ),
                    const SizedBox(width: 19,),
                    Flexible(
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pop(ctx, tfNoteController.text);
                        },
                        style: CustomButtonStyle.confirm(),
                        child: AutoSizeText('CONFIRM', style: CustomTextStyle.whiteSize(16), maxLines: 1, textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).then((value) => completer.complete(value));
      return completer.future;
  }

  static Future<bool?> order(BuildContext ctx, List<SendOrderModel> orderlist, String roomCode, String custName)async{
    Completer<bool?> completer = Completer<bool?>();
    bool isLoading = false;
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext ctxDialog){
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (ctxWidget, StateSetter setState){
              if(orderlist.isEmpty){
                Navigator.pop(ctx, true);
              }
              return Dialog(
                backgroundColor: Colors.white,
                child: Container(
                  width: ScreenSize.getSizePercent(ctxDialog, 85),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: CustomColorStyle.background(),
                  ),
                  child: StatefulBuilder(
                    builder: (ctxStfl, setState){
                      
                      return
                      
                      isLoading == true?
                      SizedBox(
                        height: ScreenSize.getHeightPercent(ctx, 50),
                        child: Center(child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground(),),)):
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText('Konfirmasi Pesanan', style: CustomTextStyle.blackMediumSize(18), maxLines: 2, minFontSize: 12, textAlign: TextAlign.center,),
                          const SizedBox(height: 12,),
                        // Membungkus ListView.builder dengan Expanded
                          Flexible(
      fit: FlexFit.loose,
      child: ListView.builder(
        itemCount: orderlist.length,
        shrinkWrap: true,
        itemBuilder: (ctxList, index){
          final order = orderlist[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: CustomContainerStyle.whiteList(),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: AutoSizeText(order.name, maxLines: 2, minFontSize: 9,)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: ()async{
                                if(order.qty>1){
                                  order.qty = order.qty - 1;
                                }else{
                                  final state = await ConfirmationDialog.confirmation(ctxList, 'Hapus ${order.name}?');
                                    if(state == true){
                                      orderlist.removeAt(index);
                                    }
                                }
                                setState((){
                                  orderlist;
                                  }
                                );
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
                                  order.qty = order.qty + 1;
                                });
                              },
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: Image.asset(
                                  'assets/icon/plus.png'),
                              )
                            ),
                          ]
                        )
                      ],
                    ),
                    const SizedBox(height: 6,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: ()async{
                            final noteResult = await note(ctx, order.name, order.note);
                            if(noteResult != null){
                              setState((){
                                orderlist[index].note = noteResult;
                              });
                            }
                          },
                          child: const Icon(Icons.notes),
                        ),
                        const SizedBox(width: 2,),
                        AutoSizeText(order.note, style: CustomTextStyle.blackStandard(), maxLines: 3,)
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6,)
            ],
          );
        },
      ),
    ),
    const SizedBox(height: 6,),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: (){
              Navigator.pop(ctx, false);
            },
            style: CustomButtonStyle.cancelSoft(),
            child: AutoSizeText('CANCEL', style: CustomTextStyle.whiteSizeMedium(16), maxLines: 1, textAlign: TextAlign.center,),
          ),
        ),
        const SizedBox(width: 9,),
        Flexible(
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: ()async{
              setState((){
                isLoading = true;
              });
              final checkinDetail = await ApiRequest().getDetailRoomCheckin(roomCode);

              if(checkinDetail.state != true){
                setState((){
                  isLoading = false;
                });
                showToastError(checkinDetail.message);
                if(ctx.mounted){
                  Navigator.pop(ctx, false);
                }else{
                  showToastWarning('Gagal karena berpindah halaman');
                  return;
                }
              }

              final rcp = checkinDetail.data?.reception??'';
              final roomType = checkinDetail.data?.roomType??'';
              final checkinMinute = checkinDetail.data?.checkinMinute??0;
              bool finalState = false;
              
              final PostSoResponse orderState = await ApiRequest().sendOrder(roomCode, rcp, roomType, checkinMinute, orderlist);
              
              if(!orderState.state){
                showToastError('SO error ${orderState.message}');
              }
              
              finalState = orderState.state;
              final pos = GlobalProviders.read(posTypeProvider);
              if (pos == PosType.restoOnlyOld || pos == PosType.restoOnlyWebBased) {
                if(isNotNullOrEmpty(orderState.data)){
                  final lastSoState = await ApiRequest().latestSo(rcp);
                  
                  if (lastSoState.state == true) {
                    final soCode = lastSoState.data;
                    final filteredData = (orderState.data ?? []).where((dataSo) => dataSo.sol == soCode).toList();
                    final doState = await ApiRequest().confirmDo(roomCode, filteredData);
                    finalState = doState.state ?? false;

                    if (doState.state != true) {
                      showToastError('DO error ${doState.message}');
                    }else{
                      PrintExecutor.printDoResto(orderState, roomCode, custName);
                    }
                  }
                }
              }else{
                PrintExecutor.printLastSo(rcp, roomCode, checkinDetail.data?.memberName??'Guest', checkinDetail.data?.pax??1);
              }

              setState((){
                isLoading = false;
              });
              debugPrint('DEBUGGING final state: $finalState');
              if(finalState != true){
                if(ctx.mounted){
                 Navigator.pop(ctx, false);
                }else{
                  showToastWarning('Gagal berpindah halaman');
                }
              }else{
                if(ctx.mounted){
                  Navigator.pop(ctx, true);
                }else{
                  showToastWarning('Gagal berpindah halaman');
                }
              }
            },
            style: CustomButtonStyle.confirm(),
            child: AutoSizeText('SEND SO', style: CustomTextStyle.whiteSizeMedium(16), maxLines: 1, textAlign: TextAlign.center),
          ),
        ),
      ],
    ),
    const SizedBox(height: 6,)
  ],
);
                    }
                  ),
                ),
              );
            },
          ));
      }).then((value) => completer.complete(value));
      return completer.future;
  }

  static Future<StationModel?> getStationModel(BuildContext ctx, StationModel? choosed) async {
    // Tambahkan 'await' dan simpan hasilnya di dalam variabel
    choosed = await showDialog<StationModel>(
      context: ctx,
      barrierDismissible: true,
      builder: (BuildContext ctxDialog) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Opsional: Memperhalus sudut dialog
          child: Container(
            width: ScreenSize.getSizePercent(ctxDialog, 80),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText('Pilih Kategori', style: CustomTextStyle.blackMediumSize(17), maxLines: 2, textAlign: TextAlign.center),
                const SizedBox(height: 6),
                FutureBuilder<List<StationModel>>(
                  future: ApiRequest().getStation().then((response) => response.data ?? []),
                  builder: (ctxFuture, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: ScreenSize.getHeightPercent(ctx, 30),
                        child: Center(
                          child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground()),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return SizedBox(
                        height: ScreenSize.getHeightPercent(ctx, 30),
                        child: Center(
                          child: AutoSizeText(
                            'Gagal memuat data station',
                            style: CustomTextStyle.blackStandard(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final stationList = snapshot.data ?? [];
                      
                      // Menggunakan GridView.builder untuk 2 kolom
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return GridView.builder(
                            itemCount: stationList.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(), // Animasi scroll yang lebih halus
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,      // Jumlah kolom
                              crossAxisSpacing: 10,   // Jarak horizontal antar kotak
                              mainAxisSpacing: 10,    // Jarak vertikal antar kotak
                              childAspectRatio: 2.8,  // Rasio ukuran kotak (Lebar vs Tinggi). Ubah angka ini jika kotak terlalu tinggi/ceper
                            ),
                            itemBuilder: (ctxList, index) {
                              final station = stationList[index];
                              // Opsional: Cek apakah item ini adalah yang sedang dipilih
                              // bool isSelected = choosed?.id == station.id; 
                              
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                  choosed = station;
                                  });
                                },
                                child: Container(
                                  // Margin vertikal dihapus karena sudah diatur oleh mainAxisSpacing di GridView
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: station.id == choosed?.id ? CustomColorStyle.appBarBackground() : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: CustomColorStyle.appBarBackground(),
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.center, // Pusatkan teks di dalam kotak grid
                                  child: AutoSizeText(
                                    station.name, 
                                    style: station.id == choosed?.id ? CustomTextStyle.whiteStandard() : CustomTextStyle.blackStandard(), 
                                    maxLines: 2, // Dibuat 2 baris untuk jaga-jaga teks panjang karena lebar terbagi 2
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      );
                    } else {
                      return SizedBox(
                        height: ScreenSize.getHeightPercent(ctx, 30),
                        child: Center(
                          child: AutoSizeText(
                            'Tidak ada data station',
                            style: CustomTextStyle.blackStandard(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 12),
                  _buildActionButtons(ctxDialog, () => choosed),
              ],
            ),
          ),
        );
      },
    );
    return choosed; 
  }

    static Widget _buildActionButtons(BuildContext context, ValueGetter<StationModel?> getValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            style: CustomButtonStyle.cancelSoft(),
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: CustomTextStyle.whiteSize(17)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: CustomButtonStyle.bluePrimary(),
            onPressed: () => Navigator.pop(context, getValue()),
            child: Text('Ganti', style: CustomTextStyle.whiteSize(17)),
          ),
        ),
      ],
    );
  }
}