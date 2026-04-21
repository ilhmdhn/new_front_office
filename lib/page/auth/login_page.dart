import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/core/extention/screen_extention.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/auth/login_potrait.dart';
import 'package:front_office_2/page/dialog/configuration_dialog.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/fingerprint.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  static const nameRoute = '/reservation';
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool showPassword = false;
  TextEditingController tfUser = TextEditingController();
  TextEditingController tfPassword = TextEditingController();
  bool isLoading = true;

  @override
  void initState(){
    loginState();
    super.initState();
  }

  void doLogin(String user, String pass)async{
    setState(() {
      isLoading = true;
    });
    debugPrint('DEBUGGING Attempting login with user: $user');
    final loginResult = await ApiRequest().loginFO(user, pass);
    debugPrint('DEBUGGING Login result state: ${loginResult.state}');
    if(loginResult.state == true){
      // Cek jika user berbeda, disable biometric
      final currentUser = ref.read(userProvider);
      if(user != currentUser.userId){
        ref.read(biometricLoginProvider.notifier).setBiometricLogin(false);
      }

      await ref.read(userProvider.notifier).setUser(loginResult.data!);
      ref.read(loginStateProvider.notifier).setLoginState(true);
      ref.read(outletProvider.notifier).updateOutlet(loginResult.data?.outlet??'');
      
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

    // Baca user dan login state dari Riverpod
    final user = ref.read(userProvider);
    final loginState = ref.read(loginStateProvider);

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
          gradient: !context.isLandscape?
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CustomColorStyle.appBarBackground().withAlpha(26),
              CustomColorStyle.background(),
              CustomColorStyle.appBarBackground().withAlpha(13),
            ],
          ): null,
          color: context.isLandscape? CustomColorStyle.background():null
        ),
        child: isLoading == true
            ? Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
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
            : 
            SafeArea(
              child:       context.isLandscape?
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text('Happy Puppy Group', style: CustomTextStyle.blackMedium()),
                          Text('Poin Of Sale', style: CustomTextStyle.blackSemi(),),
                          SizedBox(
                            width: context.isLandscape,
                            child: Wrap(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1/1,
                                  child: Image.asset('assets/hp_group/blackhole.png')),
                              ],
                            ),
                          )
                        ],
                      ),
                      _configurationButton()
                    ],
                  )),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        LoginForm(
                          tfUser: tfUser,
                          tfPassword: tfPassword,
                          showPassword: showPassword,
                    
                          onTogglePassword: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                    
                          onLogin: () {
                            if (isNullOrEmpty(tfUser.text) || isNullOrEmpty(tfPassword.text)) {
                              showToastWarning('Lengkapi User dan Password');
                              return;
                            }
                    
                            doLogin(tfUser.text, tfPassword.text);
                          },
                    
                          onFingerprint: () async {
                            final biometricState = ref.read(biometricLoginProvider);
                    
                            if (biometricState != true) {
                              showToastWarning('Autentikasi Biometric Belum Diaktifkan');
                              return;
                            }
                    
                            final biometricRequest =
                                await FingerpintAuth().requestFingerprintAuth();
                    
                            if (biometricRequest != true) return;
                    
                            final user = ref.read(userProvider);
                            doLogin(user.userId, user.pass);
                          },
                        ),
                      ],
                    ),
                  ))
              ],
            ):
            
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [            
                  Text(
                    'Poin Of Sales',
                    style: GoogleFonts.pridi(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: CustomColorStyle.appBarBackground(),
                    ),
                  ),      
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: CustomColorStyle.appBarBackground().withAlpha(26),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: CustomColorStyle.appBarBackground().withAlpha(51),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 112,
                            child: Image.asset(
                              'assets/icon/app_icon.png',
                            ),
                          ),
                        ),
                        ],
                    ),
                  ),
                  // Login Form
                  LoginForm(
                    tfUser: tfUser,
                    tfPassword: tfPassword,
                    showPassword: showPassword,
        
                    onTogglePassword: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
        
                    onLogin: () {
                      if (isNullOrEmpty(tfUser.text) ||
                          isNullOrEmpty(tfPassword.text)) {
                        showToastWarning('Lengkapi User dan Password');
                        return;
                      }
        
                      doLogin(tfUser.text, tfPassword.text);
                    },
        
                    onFingerprint: () async {
                      final biometricState = ref.read(biometricLoginProvider);
        
                      if (biometricState != true) {
                        showToastWarning('Autentikasi Biometric Belum Diaktifkan');
                        return;
                      }
        
                      final biometricRequest =
                          await FingerpintAuth().requestFingerprintAuth();
        
                      if (biometricRequest != true) return;
        
                      final user = ref.read(userProvider);
                      doLogin(user.userId, user.pass);
                    },
                  ),
                  const SizedBox(height: 20),
              
                ],
              ),
            ),
      
            )
      ),
    );
  }

  Widget _configurationButton(){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ConfigurationDialog().setUrl(context, ref);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(204),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CustomColorStyle.appBarBackground().withAlpha(51),
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
    );
  }

  @override
  void dispose() {
    tfUser.dispose();
    tfPassword.dispose();
    super.dispose();
  }
}