import 'package:flutter/material.dart';
import 'package:front_office_2/page/operational/operational_page.dart';
import 'package:front_office_2/page/profile/profile_page.dart';
import 'package:front_office_2/page/report/report_page.dart';
import 'package:front_office_2/page/status/status_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';

class MainPage extends StatefulWidget {
  static const nameRoute = '/main';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex= 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColorStyle.background(),
        bottomNavigationBar: NavigationBar(
          height: 55,
          backgroundColor: Colors.grey.shade300,
          onDestinationSelected: (int index){
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: null,
          selectedIndex: currentPageIndex,
          destinations: [
            NavigationDestination(
              icon: Image.asset('assets/icon/reception_grey.png', width: 36,), 
              selectedIcon: Image.asset('assets/icon/reception_blue.png', width: 36,),
              label: 'Reception'
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline, color: Colors.grey.shade800), 
              selectedIcon: const Icon(Icons.info_outline, color: Colors.blue),
              label: 'Status'
            ),
            NavigationDestination(
              icon: Icon(Icons.sticky_note_2_outlined, color: Colors.grey.shade800), 
              selectedIcon: const Icon(Icons.sticky_note_2_outlined, color: Colors.blue),
              label: 'Report'
            ),
            NavigationDestination(
              icon: Icon(Icons.person, color: Colors.grey.shade800), 
              selectedIcon: const Icon(Icons.person, color: Colors.blue),
              label: 'Profile'
            ),
          ]),
          body: <Widget>[
            const OperationalPage(),
            const StatusPage(),
            const ReportPage(),
            const ProfilePage()
          ][currentPageIndex],
      ),
    );
  }
}