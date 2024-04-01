import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/list_approval_request.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/biometric.dart';
import 'package:front_office_2/tools/fingerprint.dart';
import 'package:front_office_2/tools/toast.dart';

class ApprovalListPage extends StatefulWidget {
  static const nameRoute = '/approval';
  const ApprovalListPage({super.key});

  @override
  State<ApprovalListPage> createState() => _ApprovalListPageState();
}

class _ApprovalListPageState extends State<ApprovalListPage> {
  RequestApprovalResponse? apiResponse;


  void getData()async{
    apiResponse = await CloudRequest.approvalList();
    setState(() {
      apiResponse;
    });
  }

  @override
  void initState(){
    getData();
    super.initState();
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
            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
            decoration:  BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 0.7,
              ),
              borderRadius: BorderRadius.circular(10), // Bentuk border
            ),
            child: Column(
              children: [
                Text('Room Code'),
                Text(approval?.note??'note'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: ()async{
                      },
                      style: CustomButtonStyle.confirm(), 
                      child: Text('Verifikasi', style: CustomTextStyle.whiteStandard())),
                    IconButton(onPressed: ()async{
                      final bioResult = await FingerpintAuth().requestFingerprintAuth();
                        if(bioResult == true){
                          showToastWarning('disetujui');
                        }else{
                          showToastWarning('ditolak');
                        }

                    }, icon: const Icon(Icons.fingerprint))
                  ],
                )
              ],
            ),
          );
        }),
    );
  }
}