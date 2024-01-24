import 'package:flutter/material.dart';
import 'package:front_office_2/page/dialog/configuration_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/encryption.dart';
import 'package:front_office_2/tools/fingerprint.dart';
import 'package:front_office_2/tools/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const nameRoute = '/reservation';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: CustomTextfieldStyle.characterNormal(),
              ),
              const SizedBox(
                height: 29,
              ),
              TextField(
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
                      onPressed: () {
                        try {
                        const password = 'Sandal123';
                        final encryptedPassword = EncryptionService.encrypt(password);
                        final decryptionPassword = EncryptionService.decrypt(encryptedPassword);

                        print('password: $password encryptedPassword: $encryptedPassword decryptionPassword: $decryptionPassword '); 
                        } catch (e) {
                          print('ERRORRRR '+e.toString());  
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
    );
  }
}
