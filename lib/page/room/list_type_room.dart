import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class ListRoomTypePage extends StatelessWidget {
  static const nameRoute = '/list-room-type';
  const ListRoomTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Room Type', style: CustomTextStyle.titleAppBar(),),
        backgroundColor: CustomColorStyle.appBarBackground(),
      ),
      backgroundColor: CustomColorStyle.appBarBackground(),
      body: Column(
        children: [
          Text('nganu')
        ],
      ),
    );
  }
}