import 'package:flutter/material.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/preferences.dart';

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
            ElevatedButton(
              onPressed: (){
                PreferencesData.clearUser();
                Navigator.pushNamedAndRemoveUntil(context, LoginPage.nameRoute, (route) => false);
              }, 
              style: CustomButtonStyle.confirm(),
              child: Text('Logout', style: CustomTextStyle.whiteStandard(),))
          ],
        ),
      )
    );
  }
}