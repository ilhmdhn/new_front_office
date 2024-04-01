import 'package:front_office_2/tools/toast.dart';
import 'package:local_auth/local_auth.dart';

class FingerpintAuth{


  Future<bool> requestFingerprintAuth()async{
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      if(!canAuthenticateWithBiometrics || !canAuthenticate){
        showToastError('Perangkat tidak didukung');
        return false;
      }
      final bool didAuthenticate = await auth.authenticate(localizedReason: 'Ferivikasi sidik jari untuk melanjutkan',options: const AuthenticationOptions(biometricOnly: true));
      return didAuthenticate;
    } catch (e) {
      showToastError(e.toString());
      return false;
    }
  }
}