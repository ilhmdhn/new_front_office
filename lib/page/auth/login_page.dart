import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/dialog/configuration_dialog.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/fingerprint.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';

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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColorStyle.background(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: tfUser,
                  decoration: CustomTextfieldStyle.characterNormal(),
                ),
                const SizedBox(
                  height: 29,
                ),
                TextField(
                  controller: tfPassword,
                  obscureText: showPassword? false: true,
                  decoration: InputDecoration(
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
                const SizedBox(
                  height: 29,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                        onPressed: () async{
                          try {
                            final loginResult = await ApiRequest().loginFO(tfUser.text, tfPassword.text);
                            if(loginResult.state == true){
                              await PreferencesData.setUser(
                                loginResult.data!
                              );
                              if(context.mounted){
                                Navigator.pushNamedAndRemoveUntil(context, MainPage.nameRoute, (route) => false);
                              }
                            }else{
                              showToastWarning(loginResult.message??'Gagal Login');
                            }
                          } catch (e) {
                            showToastError('ERRORRRR $e');  
                          }
                        },
                        style: CustomButtonStyle.blueStandard(),
                        child: const Text('Login')),
                    IconButton(
                      onPressed: () async {
                        final fingerResult = await FingerpintAuth().requestFingerprintAuth();
                        if (!fingerResult.state) {
                          showToastWarning(fingerResult.message.toString());
                        }
                      },
                      icon: const Icon(Icons.fingerprint_outlined),
                      iconSize: 56,
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    ConfigurationDialog().setUrl(context);
                  },
                  child: Text('Konfigurasi'),
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
