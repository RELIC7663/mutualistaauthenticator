import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Model/user.dart';
import 'package:mutualistaauthenticator/Views/view_auth.dart';
import 'package:mutualistaauthenticator/Views/view_otp.dart';
import 'package:mutualistaauthenticator/Views/view_cod_ver.dart';
import 'package:mutualistaauthenticator/Views/view_login_pin.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtiene la ruta inicial
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            // Maneja cualquier error que ocurra durante la obtención de la ruta inicial
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            // Configura la ruta inicial basada en el valor devuelto por getInitialRoute()
            return MaterialApp(
              title: 'Mutualista Imabura',
              initialRoute: snapshot.data ??
                  '/', // Usa '/' como ruta por defecto si snapshot.data es nulo
              routes: {
                '/': (context) => const VistaIdentificacionWidget(),
                '/generarOTP': (context) => const VistaOTPWidget(),
                '/cod_ver': (context) => const Vista_cod_ver(),
                '/pin': (context) => const VistaIdentificacionWidget1(),
              },
            );
          }
        }
      },
    );
  }

  static Future<String> getInitialRoute() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;

    List<User> userList = await databaseHelper.getUsers();

    int pinLength = userList.isNotEmpty ? userList[0].pin.length : 0;

    if (pinLength > 4) {
      return '/pin';
    } else {
      return '/';
    }
  }
}
