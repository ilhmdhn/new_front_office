import 'package:front_office_2/tools/toast.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuth{
  Future<bool> getBiometricVerfication()async{
     final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Gunakan sidik jari untuk verifikasi',
          options: const AuthenticationOptions(useErrorDialogs: false));
      return didAuthenticate;
    } catch (e) {
      showToastError(e.toString());
      return false;
    }
  }
}