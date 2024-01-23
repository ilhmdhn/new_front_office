import 'package:front_office_2/model/fingerprint_result.dart';
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
      final bool didAuthenticate = await auth.authenticate(localizedReason: 'Please authenticate to show account balance',options: const AuthenticationOptions(biometricOnly: true));
      return FingeprintResult(
        state: didAuthenticate,
        message: availableBiometrics.toString()
      );
    } catch (e) {
      print('EKSEPSION');
      return FingeprintResult(
        state: true,
        message: e.toString()
      );
    }
  }
}