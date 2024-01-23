import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/tools/fingerprint.dart';
import 'package:front_office_2/tools/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const nameRoute = '/reservation';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            ),
            TextField(),
            ElevatedButton(onPressed: (){}, style: CustomButtonStyle.blueButton(), child: const Text('Login')),
            IconButton(onPressed: () async {
              final fingerResult = await FingerpintAuth().requestFingerprintAuth();
              print('DEBUGGINGG \n state ${fingerResult.state} message ${fingerResult.message}');

            }, icon: const Icon(Icons.fingerprint_outlined), iconSize: 56,)
          ]),
      ),
    );
  }
}