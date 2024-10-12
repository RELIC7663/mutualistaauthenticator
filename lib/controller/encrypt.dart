import 'dart:async';
import 'dart:convert'; // Para jsonDecode
import 'package:encrypt/encrypt.dart' as encrypt; // Asegúrate de tener este paquete

class Secure {
  static final encrypt.Key key = encrypt.Key.fromUtf8('01234567890123456789012345678901'); // Clave de 32 caracteres para AES-256
  static final encrypt.IV iv = encrypt.IV.fromLength(16); // IV de 16 bytes

  // Método para desencriptar una cadena en base64
  static String decryptString(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}