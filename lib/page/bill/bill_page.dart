import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';

class BillPage extends StatefulWidget {
  static const nameRoute = '/bill';
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: CustomColorStyle.background(),
        body: Column(),
      ),);
  }
}