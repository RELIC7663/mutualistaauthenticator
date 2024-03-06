import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Views/view_auth.dart';
import 'package:mutualistaauthenticator/Views/view_otp.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mutualista Imabura',
      initialRoute: '/',
      routes: {
        '/': (context) => VistaIdentificacionWidget(),
        '/generarOTP': (context) =>
            VistaOTPWidget(), // Nueva ruta para la vista de generación de OTP
      },
    );
  }
}
