import 'package:flutter/material.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/providers.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';

class FingerpintAuth{


  Future<bool> requestFingerprintAuth()async{
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      if(availableBiometrics.isEmpty){
        BuildContext? ctx = GetIt.instance<NavigationService>().navigatorKey.currentContext;
        if(ctx!= null && ctx.mounted){
          debugPrint('DEBUGGING MASUK pw');
          final pwResult = await requestPasswordAuth(ctx);
          return pwResult;
        }else{
          showToastError('Gagal memunculkan verifikasi');
          return false;
        }
      }
    
    try {
      final bool didAuthenticate = await auth.authenticate(localizedReason: 'Verifikasi Biometric Diperlukan',options: const AuthenticationOptions(biometricOnly: false));
      return didAuthenticate;
    } catch (e) {
      return false;
    }

    } catch (e) {
      debugPrint('DEBUGGING GAGAL DISINI GAEEss $e');
      return false;
    }
  }

  Future<bool> requestPasswordAuth(BuildContext context) async {
  try {
    final TextEditingController passwordController =
        TextEditingController();

    bool obscureText = true;
    String? errorText;
    bool isLoading = false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
              titlePadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              backgroundColor: Colors.white,

              title: Text(
                'Masukkan password untuk verifikasi',
                style: CustomTextStyle.titleAlertDialog(),
                textAlign: TextAlign.center,
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: passwordController,
                      obscureText: obscureText,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: "Password",
                        errorText: errorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.pop(dialogContext, false);
                              },
                        style: CustomButtonStyle.cancel(),
                        child: Text(
                          'Batal',
                          style: CustomTextStyle.whiteStandard(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                // 🔥 validasi kosong
                                if (passwordController.text.isEmpty) {
                                  setState(() {
                                    errorText =
                                        "Password tidak boleh kosong";
                                  });
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                  errorText = null;
                                });

                                final userProv =
                                    GlobalProviders.read(userProvider);

                                final loginState = await ApiRequest()
                                    .loginFO(
                                        userProv.userId,
                                        passwordController.text);

                                if (!dialogContext.mounted) return;

                                setState(() {
                                  isLoading = false;
                                });

                                if (loginState.state ?? false) {
                                  Navigator.pop(dialogContext, true);
                                } else {
                                  setState(() {
                                    errorText =
                                        loginState.message ??
                                            "Password salah";
                                  });
                                }
                              },
                        style: CustomButtonStyle.confirm(),
                        child: isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Submit',
                                style: CustomTextStyle.whiteStandard(),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    return result ?? false;
  } catch (e, stackTrace) {
    debugPrint('Error input password $e $stackTrace');
    showToastError('Gagal verifikasi password $e');
    return false;
  }
}

}