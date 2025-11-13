import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/setting/printer/printer_page.dart';
import 'package:front_office_2/page/setting/printer/printer_style.dart';
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
  UserDataModel user = PreferencesData.getUser();

  @override
  Widget build(BuildContext context) {
    bool isBiometric = PreferencesData.getBiometricLoginState();
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      appBar: AppBar(
        backgroundColor: CustomColorStyle.appBarBackground(),
        title: Text('Profile', style: CustomTextStyle.titleAppBar(),),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
                  width: 97,
                  height: 97,
                  child: CircleAvatar(
                    backgroundImage: Image.asset('assets/icon/user.png').image,
                  ),
            ),
            const SizedBox(height: 6,),
            AutoSizeText(user.userId??'user', style: CustomTextStyle.blackMediumSize(21),),
            // const SizedBox(height: 6,),
            AutoSizeText(user.level??'level', style: CustomTextStyle.blackMediumSize(18),),
        
            const SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
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
                        child: Image.asset('assets/icon/fingerprint.png')
                      ),
                    Expanded(
                      // width: widthTextButton,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        child: AutoSizeText('Autentikasi Biometric', style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 2),
                      )),
                    SizedBox(
                      width: 26,
                      child: Checkbox(
                        value: isBiometric, 
                        onChanged: (value){
                          PreferencesData.setBiometricLogin(value??false);
                          setState(() {
                            isBiometric = PreferencesData.getLoginState();
                          });
                        }
                      )
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6,),
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
                      color: Colors.grey.withValues(alpha: 0.2),
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
              onTap: () async {
                Navigator.pushNamed(context, PrinterStylePage.nameRoute);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
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
                        child: Image.asset('assets/icon/edit_invoice.png')),
                    Expanded(
                        // width: widthTextButton,
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      child: AutoSizeText('Printer Style',
                          style: CustomTextStyle.blackMediumSize(19),
                          minFontSize: 14,
                          wrapWords: false,
                          maxLines: 2),
                    )),
                    const SizedBox(
                        width: 26,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.green,
                        )),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
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
                      color: Colors.grey.withValues(alpha: 0.2),
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
                  /*final logoutState = await ConfirmationDialog.confirmation(context, 'Logout?');
                  if(logoutState != true){
                    return;
                  }*/
                  PreferencesData.setLoginState(false);
                  FirebaseMessaging.instance.deleteToken();
                  if(context.mounted){
                    Navigator.pushNamedAndRemoveUntil(context, LoginPage.nameRoute, (route) => false);
                  }else{
                    showToastWarning('Gagal berpindah halaman');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
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
      ),
    );
  }
}