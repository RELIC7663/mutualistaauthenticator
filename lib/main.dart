import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Model/Responses.dart';
import 'package:mutualistaauthenticator/Model/dbenty.dart';
import 'package:mutualistaauthenticator/Views/view_auth.dart';
import 'package:mutualistaauthenticator/Views/no_connection.dart';
import 'package:mutualistaauthenticator/Views/view_otp.dart';
import 'package:mutualistaauthenticator/Views/view_cod_ver.dart';
import 'package:mutualistaauthenticator/Views/view_login_pin.dart';
import 'package:mutualistaauthenticator/Views/loading.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';
import 'package:mutualistaauthenticator/Services/generalServies.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mutualista Imabura',
      home: FutureBuilder<String>(
        future: getInitialRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CargandoScreen(); // Pantalla de carga
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            // Redirigir a la pantalla adecuada
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, snapshot.data!);
            });
            return const SizedBox(); // Pantalla en blanco mientras se navega
          }
        },
      ),
      routes: {
        '/generarOTP': (context) => const VistaOTPWidget(),
        '/cod_ver': (context) => const Vista_cod_ver(),
        '/pin': (context) => const VistaIdentificacionWidget1(),
        '/SinConexion': (context) => const SinConexionScreen(),
        '/Loading': (context) => const CargandoScreen(),
        '/Login': (context) => const VistaIdentificacionWidget(),
      },
    );
  }
                                                     
  static Future<String> getInitialRoute() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    final Generalservies _app_services = Generalservies();
    List<Dbenty> userList = await databaseHelper.getDbenty();

    // Busca un objeto Dbenty con la clave "Pin" en la lista userList
    Dbenty pinEntry = userList.firstWhere(
      (entry) => entry.keys == 'PIN',
      orElse: () => Dbenty(
          keys: '',
          value: ''), // Si no se encuentra, crea un objeto Dbenty vacío
    );
    Dbenty idEntry = userList.firstWhere(
      (entry) => entry.keys == 'ID', // Cambia 'ID' por la clave que uses para el ID del usuario
      orElse: () => Dbenty(keys: '', value: ''), // Si no se encuentra, crea un objeto vacío
    );
    
     Response asd =await _app_services.checkConnection();
    
    if (idEntry.value.length > 9 && asd.isSuccess==true) {
      
      if (pinEntry.value.length > 4) {
        return '/pin';
      } 
      return '/generarOTP';
    } else if (asd.isSuccess==false) {
      return '/SinConexion';
    }
    else {
      return '/Login';
    }

  }
}
