import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/page/auth/login_page.dart';
import 'package:front_office_2/page/dialog/confirmation_dialog.dart';
import 'package:front_office_2/page/setting/printer/printer_page.dart';
import 'package:front_office_2/page/setting/printer/printer_style.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/toast.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static const nameRoute = '/profile';
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserDataModel user = ref.watch(userProvider);
    bool biometricProv = ref.watch(biometricLoginProvider);
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
              width: 75,
              height: 75,
              child: CircleAvatar(
                backgroundImage: Image.asset('assets/icon/user.png').image,
              ),
            ),
            const SizedBox(height: 4,),
            AutoSizeText(user.userId, style: CustomTextStyle.blackMediumSize(18),),
            AutoSizeText(user.level, style: CustomTextStyle.blackMediumSize(15),),
            const SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
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
                      width: 30,
                        child: Image.asset('assets/icon/fingerprint.png')
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        child: AutoSizeText('Autentikasi Biometric', style: CustomTextStyle.blackMediumSize(16),  minFontSize: 12, wrapWords: false,maxLines: 2),
                      )),
                    SizedBox(
                      width: 26,
                      child: Checkbox(
                        checkColor: CustomColorStyle.bluePrimary(),
                        activeColor: CustomColorStyle.background(),
                        value: biometricProv,
                        onChanged: (value){
                          ref.read(biometricLoginProvider.notifier).setBiometricLogin(value ?? false);
                        }
                      )
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  8.0),
              child: InkWell(
                onTap: ()async{
                  Navigator.pushNamed(context, PrinterPage.nameRoute);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
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
                        width: 30,
                          child: Image.asset('assets/icon/printer.png')
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          child: AutoSizeText('Setting Printer', style: CustomTextStyle.blackMediumSize(16),  minFontSize: 12, wrapWords: false,maxLines: 2),
                        )),
                      const SizedBox(
                        width: 26,
                        child: Icon(Icons.arrow_forward_ios, color: Colors.green, size: 14,)),
                    ],
                  ),
                ),
                ),
            ),
            const SizedBox(height: 4,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () async {
                  Navigator.pushNamed(context, PrinterStylePage.nameRoute);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
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
                          width: 30,
                          child: Image.asset('assets/icon/edit_invoice.png')),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        child: AutoSizeText('Printer Style',
                            style: CustomTextStyle.blackMediumSize(16),
                            minFontSize: 12,
                            wrapWords: false,
                            maxLines: 2),
                      )),
                      const SizedBox(
                          width: 26,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.green,
                            size: 14,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4,),
            /*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: ()async{
                  getIt<NavigationService>().pushNamed(ChangePasswordPage.routeName);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
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
                        width: 30,
                          child: Image.asset('assets/icon/reset_password.png')
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          child: AutoSizeText('Reset Password', style: CustomTextStyle.blackMediumSize(16),  minFontSize: 12, wrapWords: false,maxLines: 2),
                        )),
                      const SizedBox(
                        width: 26,
                        child: Icon(Icons.arrow_forward_ios, color: Colors.green, size: 14,)),
                    ],
                  ),
                ),
                ),
            ),
            const SizedBox(height: 4,),
            */Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: ()async{
                  final confirm = await ConfirmationDialog.confirmation(context, 'Logout Akun?');
                  if(confirm != true){
                    return;
                  }

                  // Logout menggunakan Riverpod
                  ref.read(loginStateProvider.notifier).setLoginState(false);
                  await ref.read(fcmTokenProvider.notifier).deleteToken();

                  if(context.mounted){
                    Navigator.pushNamedAndRemoveUntil(context, LoginPage.nameRoute, (route) => false);
                  }else{
                    showToastWarning('Gagal berpindah halaman');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
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
                        width: 30,
                          child: Image.asset('assets/icon/logout.png')
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          child: AutoSizeText('Logout', style: CustomTextStyle.blackMediumSize(16),  minFontSize: 12, wrapWords: false,maxLines: 2),
                        )),
                      const SizedBox(
                        width: 26,
                        child: Icon(Icons.arrow_forward_ios, color: Colors.green, size: 14,)),
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