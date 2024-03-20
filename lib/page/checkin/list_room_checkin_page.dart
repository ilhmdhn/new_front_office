import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class RoomCheckinListPage extends StatefulWidget {
  static const nameRoute = '/list-room-checkin';
  const RoomCheckinListPage({super.key});

  @override
  State<RoomCheckinListPage> createState() => _RoomCheckinListPageState();
}

class _RoomCheckinListPageState extends State<RoomCheckinListPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColorStyle.background(),
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color:  Colors.white, //change your color here
          ),
          title: Text('List Room Checkin', style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
          actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
            },
          ),
        ],
        ),
        body: Column(
          children: [
            SearchBar(
              hintText: 'Cari Room',
              surfaceTintColor: MaterialStateColor.resolveWith((states) => Colors.white),
              shadowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
              trailing: Iterable.generate(
                1, (index) => const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child:  Icon(Icons.search))),
            ),
            
          ],
        ),
      ));
  }
}