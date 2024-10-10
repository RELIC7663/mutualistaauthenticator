import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Model/dbenty.dart';
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

    List<Dbenty> userList = await databaseHelper.getDbenty();

    // Busca un objeto Dbenty con la clave "Pin" en la lista userList
    Dbenty pinEntry = userList.firstWhere(
      (entry) => entry.keys == 'PIN',
      orElse: () => Dbenty(
          keys: '',
          value: ''), // Si no se encuentra, crea un objeto Dbenty vacío
    );
    Dbenty idEntry = userList.firstWhere(
      (entry) => entry.keys == 'USER_ID', // Cambia 'ID' por la clave que uses para el ID del usuario
      orElse: () => Dbenty(keys: '', value: ''), // Si no se encuentra, crea un objeto vacío
    );
 
    // Verifica si la longitud del valor del pin es mayor a 4
    if (idEntry.value.length > 9) {
      // Aquí puedes retornar la ruta que desees, por ejemplo:
      if (pinEntry.value.length > 4) {
        return '/pin';
      } 
      return '/generarOTP'; // O la ruta que necesites cuando el ID es mayor a 9 caracteres
    } else {
      return '/';
    }

  }
}
