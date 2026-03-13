import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/list_approval_request.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/event_bus.dart';
import 'package:front_office_2/tools/fingerprint.dart';
import 'package:front_office_2/tools/helper.dart';

class ApprovalListPage extends StatefulWidget {
  static const nameRoute = '/approval';
  const ApprovalListPage({super.key});

  @override
  State<ApprovalListPage> createState() => _ApprovalListPageState();
}

class _ApprovalListPageState extends State<ApprovalListPage> {
  RequestApprovalResponse? apiResponse;
  StreamSubscription? _eventSubscription;


  void getData()async{
    final result = await CloudRequest.approvalList();
    if(mounted){
      setState(() {
        apiResponse = result;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    getData();

    _eventSubscription = eventBus.on<RefreshApprovalCount>().listen((event) {
      if(mounted){
        getData();
      }
    });
  }

  @override
  void dispose(){
    _eventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Approval Request', style: CustomTextStyle.titleAppBar(),),
        iconTheme: const IconThemeData(
            color:  Colors.white, //change your color here
        ),
        backgroundColor: CustomColorStyle.appBarBackground(),
      ),
      backgroundColor: CustomColorStyle.background(),
      body: apiResponse == null?
      Center(
        child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground(),),
      ):
      apiResponse?.state != true?
      Center(
        child: Text(apiResponse?.message ?? 'Gagal mendapatkan data'),):
      ListView.builder(
        shrinkWrap: true,
        itemCount: apiResponse?.data.length,
        itemBuilder:  (lvCtx, index){
          final approval = apiResponse?.data[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
            decoration:  BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 0.7,
              ),
              borderRadius: BorderRadius.circular(10), // Bentuk border
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${approval?.user} (${approval?.room})', style: CustomTextStyle.blackMedium(),),
                Text(approval?.note??'note', style: CustomTextStyle.blackStandard()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: isNotNullOrEmpty(apiResponse?.data[index].reason)?
                    InkWell(
                      onTap: (){
                        showDialog(
                          context: context,
                          // fullscreenDialog: false, // Catatan: showDialog bawaan Flutter biasanya tidak memiliki properti ini. Jika error, baris ini bisa dihapus.
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              // Mencegah warna header menutupi lengkungan (border radius) dialog
                              clipBehavior: Clip.antiAlias, 
                              // Menghilangkan padding bawaan agar header membentang penuh
                              titlePadding: EdgeInsets.zero, 
                              contentPadding: EdgeInsets.zero, 
                              
                              // --- BAGIAN HEADER BARU ---
                              title: Container(
                                color: CustomColorStyle.appBarBackground(), // Latar belakang nuansa biru soft
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Informasi", // Silakan ubah judul ini sesuai kebutuhan
                                      style: CustomTextStyle.whiteStandard(),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.of(context).pop(), // Fungsi tombol close
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100, // Warna tombol close
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              content: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        apiResponse?.data[index].reason ??'',
                                        style: CustomTextStyle.blackMedium(),
                                        textAlign: TextAlign.start
                                      ),
                                  ],
                                )
                              ),
                            );
                          },
                        );
                      },
                    child: 
                      AutoSizeText('note: ${(apiResponse?.data[index].reason??'')}', style: CustomTextStyle.blackStandard(), minFontSize: 12, maxLines: 2,),
                    ):
                    const SizedBox.shrink(),
                    ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: ()async{
                              final bioResult = await FingerpintAuth().requestFingerprintAuth();
                              if(bioResult == true){
                                await CloudRequest.rejectApproval(approval?.idApproval??'');
                                getData();
                              }
                            },
                            style: CustomButtonStyle.cancel(),
                            child: Text('Tolak', style: CustomTextStyle.whiteSize(14),),
                          ),
                          const SizedBox(width: 6,),
                          ElevatedButton(
                            onPressed: ()async{
                              final bioResult = await FingerpintAuth().requestFingerprintAuth();
                              if(bioResult == true){
                                await CloudRequest.confirmApproval(approval?.idApproval??'');
                                getData();
                              }
                            },
                            style: CustomButtonStyle.confirm(),
                            child: Text('Approve', style: CustomTextStyle.whiteSize(14),),
                              ),
                        ],
                      ),
                  ],
                )
              ],
            ),
          );
        }),
    );
  }
}