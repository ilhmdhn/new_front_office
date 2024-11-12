import 'package:flutter/material.dart';
import 'package:front_office_2/page/dashboard/dashboard_page.dart';
import 'package:front_office_2/page/profile/profile_page.dart';
import 'package:front_office_2/page/report/report_page.dart';
import 'package:front_office_2/page/room/room_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:front_office_2/tools/permissions.dart';
import 'package:front_office_2/tools/toast.dart';

class MainPage extends StatefulWidget {
  static const nameRoute = '/main';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {

  int currentPageIndex = 0;

  void notifPermissionState()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if(settings.authorizationStatus.toString() != 'AuthorizationStatus.authorized'){
      showToastWarningLong('Berikan Izin Notifikasi');
      Permissions().getNotificationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    notifPermissionState();

    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColorStyle.background(),
        bottomNavigationBar: NavigationBar(
          height: 51,
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
            icon: const Icon(Icons.dashboard_outlined, size: 26,),
            selectedIcon: Icon(Icons.dashboard_outlined, size: 26, color: CustomColorStyle.bluePrimary(),),
            label: 'Dashboard'),
            NavigationDestination(
              icon: Image.asset('assets/icon/reception_grey.png', width: 31,), 
              selectedIcon: Image.asset('assets/icon/reception_blue.png', width: 31,),
              label: 'Room'
            ),
            NavigationDestination(
              icon: Icon(Icons.sticky_note_2_outlined, color: Colors.grey.shade800, size: 26), 
              selectedIcon: const Icon(Icons.sticky_note_2_outlined, color: Colors.blue, size: 26),
              label: 'Report'
            ),
            NavigationDestination(
              icon: Icon(Icons.person, color: Colors.grey.shade800, size: 26), 
              selectedIcon: const Icon(Icons.person, color: Colors.blue, size: 26),
              label: 'Profile'
            ),
          ]),
          body: <Widget>[
            const DashboardPage(),
            const RoomPage(),
            const ReportPage(),
            const ProfilePage()
          ][currentPageIndex],
      ),
    );
  }
}