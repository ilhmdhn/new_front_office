import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/dialog/configuration_dialog.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
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
      setState((){
        isLoading = false;
      });
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CustomColorStyle.appBarBackground().withOpacity(0.1),
              CustomColorStyle.background(),
              CustomColorStyle.appBarBackground().withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: isLoading == true
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircularProgressIndicator(
                      color: CustomColorStyle.appBarBackground(),
                      strokeWidth: 3,
                    ),
                  ),
                )
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo/Title Section
                  
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: CustomColorStyle.appBarBackground().withOpacity(0.1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: CustomColorStyle.appBarBackground().withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.business,
                            size: 48,
                            color: CustomColorStyle.appBarBackground(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AutoSizeText(
                          'Happy Puppy Group POS',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            color: CustomColorStyle.appBarBackground(),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // Login Form
                  Container(
                    padding: const EdgeInsets.all(32),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Username Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: tfUser,
                                autofillHints: const [AutofillHints.username],
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: CustomColorStyle.appBarBackground(),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: CustomColorStyle.appBarBackground(),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: 'Masukkan username',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
              
                        const SizedBox(height: 24),
              
                        // Password Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: tfPassword,
                                autofillHints: const [AutofillHints.password],
                                obscureText: !showPassword,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: CustomColorStyle.appBarBackground(),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    icon: Icon(
                                      showPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: CustomColorStyle.appBarBackground(),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: 'Masukkan password',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
              
                        const SizedBox(height: 32),
              
                        // Login Buttons
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      CustomColorStyle.appBarBackground(),
                                      CustomColorStyle.appBarBackground().withOpacity(0.8),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CustomColorStyle.appBarBackground().withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (isNullOrEmpty(tfUser.text) ||
                                          isNullOrEmpty(tfPassword.text)) {
                                        showToastWarning('Lengkapi User dan Password');
                                        return;
                                      }
                                      doLogin(tfUser.text, tfPassword.text);
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      child: Center(
                                        child: Text(
                                          'Login',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
              
                            const SizedBox(width: 16),
              
                            // Biometric Button
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: CustomColorStyle.appBarBackground().withOpacity(0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    final biometricState =
                                        PreferencesData.getBiometricLoginState();
                                    if (biometricState != true) {
                                      showToastWarning(
                                          'Autentikasi Biometric Belum Diaktifkan');
                                      return;
                                    }
              
                                    final biometricRequest =
                                        await FingerpintAuth().requestFingerprintAuth();
                                    if (biometricRequest != true) {
                                      return;
                                    }
                                    final user = PreferencesData.getUser();
                                    doLogin(user.userId ?? '', user.pass ?? '');
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/icon/fingerprint.png',
                                      width: 28,
                                      height: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              
                  const SizedBox(height: 40),
              
                  // Configuration Link
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          ConfigurationDialog().setUrl(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CustomColorStyle.appBarBackground().withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.settings_outlined,
                                size: 18,
                                color: CustomColorStyle.appBarBackground(),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Konfigurasi',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColorStyle.appBarBackground(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              
                  const SizedBox(height: 20),
                ],
              ),
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