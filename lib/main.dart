import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Views/view_auth.dart';
import 'package:mutualistaauthenticator/Views/view_otp.dart';
import 'package:mutualistaauthenticator/Views/view_cod_ver.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mutualista Imabura',
      initialRoute: '/',
      routes: {
        '/': (context) => const VistaIdentificacionWidget(),
        '/generarOTP': (context) => const VistaOTPWidget(),
        '/cod_ver': (context) => const Vista_cod_ver(),
      },
    );
  }
}
