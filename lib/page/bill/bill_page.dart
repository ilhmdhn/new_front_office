import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/bill_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class BillPage extends StatefulWidget {
  static const nameRoute = '/bill';
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  String roomCode = '';
  bool isLoading = true;

  PreviewBillResponse result = PreviewBillResponse(state: false, message: 'loading');

  void getData()async{
    result = await ApiRequest().previewBill(roomCode);
    setState(() {
      result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    if(isLoading){
      getData();
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color:  Colors.white, //change your color here
          ),
          title: Text(roomCode, style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        backgroundColor: CustomColorStyle.background(),
        body: 
        
        isLoading == true?
          Center(child: CircularProgressIndicator(backgroundColor: CustomColorStyle.appBarBackground(),),):
        result.state != true?
          Center(
            child: Text(result.message),):
          Column(
            children: [
              Text('anu')
            ],
          )
        ,
      ),);
  }
}