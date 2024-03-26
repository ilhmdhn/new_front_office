import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/page/checkin/edit_checkin_page.dart';
import 'package:front_office_2/page/checkin/list_room_checkin_page.dart';
import 'package:front_office_2/page/extend/extend_room_page.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/operational/operational_page.dart';
import 'package:front_office_2/page/profile/profile_page.dart';
import 'package:front_office_2/page/report/report_page.dart';
import 'package:front_office_2/page/report/sales/sales_report_page.dart';
import 'package:front_office_2/page/room/list_room_page.dart';
import 'package:front_office_2/page/room/list_type_room.dart';
import 'package:front_office_2/page/setting/printer/printer_page.dart';
import 'package:front_office_2/page/status/status_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front_office_2/tools/background_service.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'firebase_options.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  await PreferencesData.initialize();
  setupLocator();
  runApp(const FrontOffice());
}

class FrontOffice extends StatelessWidget {
  const FrontOffice({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Happy Puppy POS',
      initialRoute: LoginPage.nameRoute,
      routes: {
        LoginPage.nameRoute: (context) => const LoginPage(),
        MainPage.nameRoute: (context) => const MainPage(),
        OperationalPage.nameRoute: (context) => const OperationalPage(),
        StatusPage.nameRoute: (context) => const StatusPage(),
        ReportPage.nameRoute: (context) => const ReportPage(),
        ProfilePage.nameRoute: (context) => const ProfilePage(),
        PrinterPage.nameRoute: (context) => const PrinterPage(),
        MySalesPage.nameRoute: (context) => const MySalesPage(),
        ListRoomTypePage.nameRoute: (context) => const ListRoomTypePage(),
        ListRoomReadyPage.nameRoute: (context) => const ListRoomReadyPage(),
        EditCheckinPage.nameRoute: (context) => const EditCheckinPage(),
        RoomCheckinListPage.nameRoute: (context) => const RoomCheckinListPage(),
        ExtendRoomPage.nameRoute: (context) => const ExtendRoomPage()
      },
    );
  }
}