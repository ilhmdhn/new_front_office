import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_office_2/data/model/checkin_params.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/auth/approval_list_page.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/page/button_menu/button_menu_list.dart';
import 'package:front_office_2/page/checkin/edit_checkin_page.dart';
import 'package:front_office_2/page/checkin/list_room_checkin_page.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/room/list_type_room.dart';
import 'package:front_office_2/page/setting/printer/printer_page.dart';
import 'package:front_office_2/page/style/custom_button.dart';
// import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/background_service.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class OperationalPage extends StatelessWidget {
  static const nameRoute = '/operational';
  const OperationalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final spaceCenter = ScreenSize.getSizePercent(context, 2);
    final paddingEdgeSize = ScreenSize.getSizePercent(context, 3);
    final widthButton = ScreenSize.getSizePercent(context, 45);
    final widthTextButton = ScreenSize.getSizePercent(context, 26);
    final widthIconButton = ScreenSize.getSizePercent(context, 10);
    final widthArrowButton = ScreenSize.getSizePercent(context, 3);
    final heightUser = ScreenSize.getSizePercent(context, 3);
    final heightMenu = ScreenSize.getSizePercent(context, 3);
    final spacerpaddingButton = ScreenSize.getSizePercent(context, 3);
    final paddingButtonText = ScreenSize.getSizePercent(context, 1);
    final userData = PreferencesData.getUser();
    
    final widget = ButtonMenuWidget(context: context);
    List<Widget> listMenuWidget = [widget.checkin(), widget.checkinReservation(), widget.editCheckin(), widget.extend(), widget.transfer()];
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColorStyle.appBarBackground(),
        foregroundColor: Colors.white,
        title: Text('Operasional', style: CustomTextStyle.titleAppBar(),selectionColor: Colors.white,),
        actions: [
          IconButton(onPressed: (){}, icon: Badge(label: Text('11') ,child: const Icon(Icons.notifications,)),)
        ],
      ),
      backgroundColor: CustomColorStyle.background(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingEdgeSize),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 55,
                  child: CircleAvatar(
                    backgroundImage: Image.asset('assets/icon/user.png').image,
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userData.userId??'No Named', style: CustomTextStyle.blackMedium()),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.black,
                      ),
                      Text(userData.level??'Unknown', style: CustomTextStyle.blackMedium()),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: spaceCenter,
                crossAxisSpacing: spaceCenter,
                childAspectRatio: 20/9
              ),
              itemCount: listMenuWidget.length,
              itemBuilder: (context, index){
                return SizedBox(
                  width: widthButton,
                  child: Center(child: AutoSizeText('Checkoutssssssz1233456', style: GoogleFonts.poppins(fontSize: 21, color: Colors.black, fontWeight: FontWeight.w500),  minFontSize: 1, maxLines: 1)),
                );
              }),
          ],
        ),
      )
      );
  }
}