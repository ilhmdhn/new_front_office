import 'package:front_office_2/data/model/fingerprint_result.dart';
import 'package:local_auth/local_auth.dart';

class FingerpintAuth{


  Future<FingeprintResult> requestFingerprintAuth()async{
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      if(!canAuthenticateWithBiometrics || !canAuthenticate){
        return FingeprintResult(
            state: false,
            message: 'Device not supported'
        );
      }
      final bool didAuthenticate = await auth.authenticate(localizedReason: 'Ferivikasi sidik jari untuk melanjutkan',options: const AuthenticationOptions(biometricOnly: true));
      return FingeprintResult(
        state: didAuthenticate,
        message: availableBiometrics.toString()
      );
    } catch (e) {
      return FingeprintResult(
        state: true,
        message: e.toString()
      );
    }
  }
}