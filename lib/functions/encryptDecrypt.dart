import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_dotenv/flutter_dotenv.dart';

String decrypt(String text) {
  final key = enc.Key.fromUtf8(dotenv.get('encryptKey')); //32 chars
  final iv = enc.IV.fromUtf8('put16characters!'); //16 chars

  final e = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final decrypted_data = e.decrypt(enc.Encrypted.fromBase64(text), iv: iv);
  return decrypted_data;
}

String encrypt(String text) {
  final key = enc.Key.fromUtf8(dotenv.get('encryptKey')); //32 chars
  final iv = enc.IV.fromUtf8('put16characters!'); //16 chars

  final e = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final encrypted_data = e.encrypt(text, iv: iv);
  return encrypted_data.base64;
}
