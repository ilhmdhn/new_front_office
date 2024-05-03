import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/dialog/configuration_dialog.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/fingerprint.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const nameRoute = '/reservation';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;
  TextEditingController tfUser = TextEditingController();
  TextEditingController tfPassword = TextEditingController();
  bool isLoading = true;

  @override
  void initState(){
    loginState();
    super.initState();
  }

  Future<void> insertLogin()async{
    final response = await CloudRequest.insertLogin();
    if(response.state != true){
      showToastError(' Error upload fcm tokent ${response.message}');
    }
  }

  void doLogin(String user, String pass)async{
    setState(() {
      isLoading = true;
    });
    final loginResult = await ApiRequest().loginFO(user, pass);
    if(loginResult.state == true){
      if(user != PreferencesData.getUser().userId){
          PreferencesData.setBiometricLogin(false);
      }

      PreferencesData.setUser(loginResult.data!, pass);
      PreferencesData.setLoginState(true);

      await insertLogin();
      BuildContext ctx = context;
      if(ctx.mounted){
        Navigator.pushNamedAndRemoveUntil(ctx, MainPage.nameRoute, (route) => false);
      }else{
        showToastError('Gagal, jangan berpindah halaman');
      }
    }else{
      showToastWarning(loginResult.message??'Gagal Login');
    }
    setState(() {
      isLoading = false;
    });
  }

  void loginState()async{
    final apiResponse = await ApiRequest().cekSign();
    final user = PreferencesData.getUser();
    final loginState = PreferencesData.getLoginState();
    if(apiResponse.state == true && isNotNullOrEmpty(user.userId) && isNotNullOrEmpty(user.level) && isNotNullOrEmpty(user.token) && loginState == true){
      getIt<NavigationService>().pushNamedAndRemoveUntil(MainPage.nameRoute);
    }else{
      setState((){
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColorStyle.background(),
        body: 
        
        isLoading == true?
        Center(
          child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground(),),
        ):
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText('Login FO', style: GoogleFonts.poppins(fontSize: 36, color: CustomColorStyle.appBarBackground(), fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username:', style: CustomTextStyle.blackStandard(),),
                      SizedBox(
                        height: 36,
                        child: TextField(
                          style: GoogleFonts.poppins(),
                          controller: tfUser,
                          autofillHints: const [AutofillHints.username],
                          decoration: CustomTextfieldStyle.characterNormal(),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text('Password:', style: CustomTextStyle.blackStandard(),),
                      SizedBox(
                        height: 36,
                        child: TextField(
                          controller: tfPassword,
                          style: GoogleFonts.poppins(),
                          autofillHints: const [AutofillHints.password],
                          obscureText: showPassword? false: true,
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.symmetric(vertical: 40.0),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: -10.0, horizontal: 12),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                 showPassword = !showPassword;  
                                });
                              },
                              icon: Icon(showPassword? Icons.visibility:Icons.visibility_off),)
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: (){
                                doLogin(tfUser.text, tfPassword.text);
                              },
                              child: Container(
                                decoration: CustomContainerStyle.confirmButton(),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: Text('Login', style: CustomTextStyle.whiteSize(19),))),
                          const SizedBox(width: 12,),
                          InkWell(
                            onTap: ()async{
                              final biometricState = PreferencesData.getBiometricLoginState();
                              if(biometricState != true){
                                showToastWarning('Autentikasi Biometric Belum Diaktifkan');
                                return;
                              }

                              final biometricRequest = await FingerpintAuth().requestFingerprintAuth();
                              if(biometricRequest != true){
                                return;
                              }
                              final user = PreferencesData.getUser();
                              doLogin(user.userId??'', user.pass??'');
                            },
                            child: SizedBox(
                              height: 46,
                              width: 46,
                              child: Image.asset('assets/icon/fingerprint.png'),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: InkWell(
                    onTap: (){
                      ConfigurationDialog().setUrl(context);
                    },
                    child: Text('Konfigurasi', style: CustomTextStyle.blackMedium(),),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tfUser.dispose();
    tfPassword.dispose();
    super.dispose();
  }
}