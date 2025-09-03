import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptionService {
 static String encrypt(String data) {
    final secretKey = dotenv.env['secret_key']!;
    final ivt = dotenv.env['iv']!;
  
    final key = Key.fromUtf8(secretKey);
    final iv = IV.fromBase64(ivt);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  static String decrypt(String data) {
    final secretKey = dotenv.env['secret_key']!;
    final ivt = dotenv.env['iv']!;
    final key = Key.fromUtf8(secretKey);
    final iv = IV.fromBase64(ivt);
    final encrypter = Encrypter(AES(key));
    final encrypted = Encrypted.fromBase64(data);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
