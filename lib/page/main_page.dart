import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/app_update_response.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/dialog/update_dialog.dart';
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
      final updateData = await CloudRequest.getVersion();
      int updateLevel = 0;
      bool isUpdateAvailable = false; 
      debugPrint('update option ${updateData.option} update force ${updateData.force}');
      if(updateData.state){
        if(int.parse(currentVersion.buildNumber) < updateData.force){
          isUpdateAvailable = true;
          updateLevel = 2;
          debugPrint('Update DUA');
        } else if(num.parse(currentVersion.buildNumber) < updateData.option){
          isUpdateAvailable = true;
          updateLevel = 1;
          debugPrint('Update SATU');
        }
      }

    final updateDialogData = AppUpdateInfo(
      // isForceUpdate: updateLevel>1? true: false,
      isForceUpdate: updateLevel>1? true: false,
      version: (updateLevel>1?updateData.force:updateData.option).toString(),
      releaseNotes: updateData.desc,
      storeUrl: updateData.url,
    );

    // Logic sederhana: Anggap selalu ada update untuk demo ini

    if (isUpdateAvailable && mounted) {
      showDialog(
        context: context,
        barrierDismissible: updateLevel>1? true: false, // Cegah tap di luar dialog
        builder: (context) => UpdateDialog(updateInfo: updateDialogData),
      );
    }

    }catch(e, stackTrace){
      debugPrint('Error ${e.toString()} $stackTrace');
      showToastWarning('Gagal cek versi');
    }
  }
  
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCheck();
    });
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