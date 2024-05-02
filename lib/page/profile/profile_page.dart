import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/setting/printer/printer_page.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';

class ProfilePage extends StatefulWidget {
  static const nameRoute = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColorStyle.background(),
        appBar: AppBar(
          backgroundColor: CustomColorStyle.appBarBackground(),
          title: Text('Profile', style: CustomTextStyle.titleAppBar(),),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  8.0),
              child: InkWell(
                onTap: ()async{
                  Navigator.pushNamed(context, PrinterPage.nameRoute);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 36,
                          child: Image.asset('assets/icon/printer.png')
                        ),
                      Expanded(
                        // width: widthTextButton,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          child: AutoSizeText('Setting Printer', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 2),
                        )),
                      const SizedBox(
                        width: 26,
                        child: Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                    ],
                  ),
                ), 
                ),
            ),
            const SizedBox(height: 6,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: ()async{
                  showToastWarning('Belum tersedia');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 36,
                          child: Image.asset('assets/icon/reset_password.png')
                        ),
                      Expanded(
                        // width: widthTextButton,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          child: AutoSizeText('Reset Password', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 2),
                        )),
                      const SizedBox(
                        width: 26,
                        child: Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                    ],
                  ),
                ), 
                ),
            ),
            const SizedBox(height: 6,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: ()async{
                  final logoutState = await ConfirmationDialog.confirmation(context, 'Logout?');
                  if(logoutState != true){
                    return;
                  }
                  PreferencesData.clearUser();
                  Navigator.pushNamedAndRemoveUntil(context, LoginPage.nameRoute, (route) => false);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 36,
                          child: Image.asset('assets/icon/logout.png')
                        ),
                      Expanded(
                        // width: widthTextButton,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          child: AutoSizeText('Logout', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 2),
                        )),
                      const SizedBox(
                        width: 26,
                        child: Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                    ],
                  ),
                ), 
                ),
            ),
          ],
        ),
      )
    );
  }
}