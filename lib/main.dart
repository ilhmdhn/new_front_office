import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front_office_2/page/auth/approval_list_page.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/page/bill/bill_page.dart';
import 'package:front_office_2/page/bill/payment_page.dart';
import 'package:front_office_2/page/checkin/edit_checkin_page.dart';
import 'package:front_office_2/page/checkin/list_room_checkin_page.dart';
import 'package:front_office_2/page/extend/extend_room_page.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/operational/operational_page.dart';
import 'package:front_office_2/page/order/fnb_main_page.dart';
import 'package:front_office_2/page/profile/profile_page.dart';
import 'package:front_office_2/page/report/call/call_service_history_page.dart';
import 'package:front_office_2/page/report/cash_detail/cash_detail_page.dart';
import 'package:front_office_2/page/report/invoice/reprint_invoice.dart';
import 'package:front_office_2/page/report/report_page.dart';
import 'package:front_office_2/page/report/sales/sales_report_page.dart';
import 'package:front_office_2/page/room/list_room_page.dart';
import 'package:front_office_2/page/room/list_type_room.dart';
import 'package:front_office_2/page/setting/password/change_password_page.dart';
import 'package:front_office_2/page/setting/printer/printer_page.dart';
import 'package:front_office_2/page/setting/printer/printer_style.dart';
import 'package:front_office_2/page/status/state_page.dart';
import 'package:front_office_2/page/transfer/list_room_transfer_page.dart';
import 'package:front_office_2/page/transfer/reason_transfer_page.dart';
import 'package:front_office_2/tools/background_service.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/event_bus.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:get_it/get_it.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: ".env");
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String? signalType = message.data['type'];
    String? signalCode = message.data['code'];
    bool state = false;
  
    if (message.data['state'] == 'true') {
      state = true;
    }

    if (signalType == '1') {
      eventBus.fire(ConfirmationSignalModel(code: signalCode ?? '', state: state));
    } else if (signalType == '2') {
      SendNotification.notif(message);
      eventBus.fire(RefreshApprovalCount());
    } else if (signalType == '3') {
      eventBus.fire(RefreshApprovalCount());
    } else if(signalType == 'room_call'){
      debugPrint('DEBUGGING room_call received');
      showRoomCallDialog(message);
    }
  });

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
      debugShowCheckedModeBanner: true,
      title: 'Happy Puppy POS',
      initialRoute: LoginPage.nameRoute,
      routes: {
        LoginPage.nameRoute: (context) => const LoginPage(),
        MainPage.nameRoute: (context) => const MainPage(),
        OperationalPage.nameRoute: (context) => const OperationalPage(),
        StatePage.nameRoute: (context) => const StatePage(),
        ReportPage.nameRoute: (context) => const ReportPage(),
        ProfilePage.nameRoute: (context) => const ProfilePage(),
        PrinterPage.nameRoute: (context) => const PrinterPage(),
        MySalesPage.nameRoute: (context) => const MySalesPage(),
        ListRoomTypePage.nameRoute: (context) => const ListRoomTypePage(),
        ListRoomReadyPage.nameRoute: (context) => const ListRoomReadyPage(),
        EditCheckinPage.nameRoute: (context) => const EditCheckinPage(),
        RoomCheckinListPage.nameRoute: (context) => const RoomCheckinListPage(),
        ExtendRoomPage.nameRoute: (context) => const ExtendRoomPage(),
        ApprovalListPage.nameRoute: (context) => const ApprovalListPage(),
        TransferReasonPage.nameRoute: (context) => const TransferReasonPage(),
        ListRoomTransferPage.nameRoute: (context)=> const ListRoomTransferPage(),
        BillPage.nameRoute: (context) => const BillPage(),
        PaymentPage.nameRoute: (context) => const PaymentPage(),
        FnbMainPage.nameRoute: (context) => const FnbMainPage(),
        CashDetailPage.nameRoute: (context) => const CashDetailPage(),
        ReprintInvoicePage.nameRoute: (context) => const ReprintInvoicePage(),
        PrinterStylePage.nameRoute: (context) => const PrinterStylePage(),
        CallServiceHistoryPage.nameRoute: (context) => const CallServiceHistoryPage(),
        ChangePasswordPage.routeName: (context) => const ChangePasswordPage(),
      },
    );
  }
}