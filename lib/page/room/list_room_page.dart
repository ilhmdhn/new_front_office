import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class ListRoomReadyPage extends StatefulWidget {
  static const nameRoute = '/list-room';
  const ListRoomReadyPage({super.key});

  @override
  State<ListRoomReadyPage> createState() => _ListRoomReadyPageState();
}

class _ListRoomReadyPageState extends State<ListRoomReadyPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
          color:  Colors.white, //change your color here
        ),
        title: Text('List Room Type', style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
      )
    );
  }
}