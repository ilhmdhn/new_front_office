import 'package:front_office_2/tools/toast.dart';
import 'package:local_auth/local_auth.dart';

class FingerpintAuth{


  Future<bool> requestFingerprintAuth()async{
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      // final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      if(!canAuthenticateWithBiometrics || !canAuthenticate){
        showToastError('Perangkat tidak didukung');
        return false;
      }
    
    try {
      final bool didAuthenticate = await auth.authenticate(localizedReason: 'Verifikasi Biometric Diperlukan',options: const AuthenticationOptions(biometricOnly: true));
      return didAuthenticate;
    } catch (e) {
      showToastError(e.toString());
      return false;
    }

    } catch (e) {
      return false;
    }
  }
}