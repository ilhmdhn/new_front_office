import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/list_approval_request.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/fingerprint.dart';
import 'package:front_office_2/tools/event_bus.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    isNotNullOrEmpty(apiResponse?.data[index].reason)?
                    InkWell(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              surfaceTintColor: Colors.white,
                              backgroundColor:CustomColorStyle.white(),
                              content: Container(
                                constraints: const BoxConstraints(
                                  maxWidth:300,
                                  maxHeight:150,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: CustomColorStyle.white(),
                                ),
                                child: Center(
                                  child: Text(
                                    apiResponse?.data[index].reason ??'',
                                    style: CustomTextStyle.blackStandard(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    child: AutoSizeText('note: ${(apiResponse?.data[index].reason??'')}', style: CustomTextStyle.blackStandard(), minFontSize: 12,),
                    ):
                    const SizedBox(),
                    Row(
                      children: [
                        InkWell(
                          onTap: ()async{
                            final bioResult = await FingerpintAuth().requestFingerprintAuth();
                            if(bioResult == true){
                              await CloudRequest.rejectApproval(approval?.idApproval??'');
                              getData();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.redAccent.shade400,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              child: Text('Tolak', style: CustomTextStyle.whiteSize(14),),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6,),
                        InkWell(
                          onTap: ()async{
                            final bioResult = await FingerpintAuth().requestFingerprintAuth();
                            if(bioResult == true){
                              await CloudRequest.confirmApproval(approval?.idApproval??'');
                              getData();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                  child: Text('Approve', style: CustomTextStyle.whiteSize(14),),
                                ),
                                const Icon(Icons.fingerprint, color: Colors.white,)
                              ],
                            ),
                          ),
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