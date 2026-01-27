import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/operational/operational_page.dart';
import 'package:front_office_2/page/profile/profile_page.dart';
import 'package:front_office_2/page/report/report_page.dart';
import 'package:front_office_2/page/status/state_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/tools/permissions.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  
  void _updateCheck()async{
    try{
      final currentVersion = await PackageInfo.fromPlatform();
      
    }catch(e){
      showToastWarning('Gagal cek versi');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    notifPermissionState();

    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      bottomNavigationBar: NavigationBar(
        height: 55,
        backgroundColor: CustomColorStyle().hexToColor('#FEFEFE'),
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
          const StatePage(),
          const ReportPage(),
          const ProfilePage()
        ][currentPageIndex],
    );
  }
}