import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class ApprovalListPage extends StatefulWidget {
  static const nameRoute = '/approval';
  const ApprovalListPage({super.key});

  @override
  State<ApprovalListPage> createState() => _ApprovalListPageState();
}

class _ApprovalListPageState extends State<ApprovalListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approval', style: CustomTextStyle.titleAppBar(),),
        iconTheme: const IconThemeData(
            color:  Colors.white, //change your color here
        ),
        backgroundColor: CustomColorStyle.appBarBackground(),
      ),
      backgroundColor: CustomColorStyle.background(),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}