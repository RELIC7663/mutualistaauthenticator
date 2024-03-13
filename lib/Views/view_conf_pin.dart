import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Views/view_login_pin.dart';
import 'package:mutualistaauthenticator/Model/dbenty.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';

class CreatePinView extends StatelessWidget {
  CreatePinView({Key? key}) : super(key: key);

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222e7a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF112659),
        automaticallyImplyLeading: false,
        title: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.asset(
              'assets/images/Title.png',
              width: 217,
              height: 47,
              fit: BoxFit.contain,
              alignment: const Alignment(0, 0),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              height: 300, // Ajusta la altura según tus necesidades
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/asd.png',
                  fit: BoxFit
                      .contain, // Ajusta el modo de ajuste según tus necesidades
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'Ingrese el pin de inicio de secion',
                      style: TextStyle(
                        color: Color.fromARGB(255, 228, 226, 226),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_passwordController.text.isEmpty ||
                          _confirmPasswordController.text.isEmpty) {
                        // Mostrar un mensaje de error si algún campo está vacío
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ambos campos son requeridos'),
                          ),
                        );
                        return;
                      }
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        // Mostrar un mensaje de error si las contraseñas no coinciden
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Las contraseñas no coinciden!!'),
                          ),
                        );
                        return;
                      }
                      // Acción para confirmar la creación del PIN
                      // Esto puede incluir navegación a la siguiente vista
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('ADVERTENCIA!!'),
                            content: const Text(
                              '¿Está seguro de que desea establecer este PIN como su PIN de inicio de sesión? Una vez configurado, este PIN será necesario cada vez que inicie sesión en la aplicación. Por favor, asegúrese de recordar este PIN para acceder sin problemas en el futuro.',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  // Acción al presionar el botón de cancelar
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // Acción al presionar el botón de confirmar
                                  Navigator.of(context).pop();
                                  bool idExists = await checkIfIdExists();
                                  if (!idExists) {
                                    await createIdDbenty();
                                    await updateIdDbenty(
                                        _passwordController.text);
                                  } else {
                                    // Si la clave 'PIN' ya existe, actualizarla con el valor ingresado
                                    await updateIdDbenty(
                                        _passwordController.text);
                                  }
                                  // Navegar a otra vista
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VistaIdentificacionWidget1()),
                                  );
                                },
                                child: const Text('Confirmar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Confirmar'),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Acción para cancelar y regresar a la vista anterior
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkIfIdExists() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    List<Dbenty> userList = await databaseHelper.getDbenty();
    return userList.any((entry) => entry.keys == 'PIN');
  }

  Future<void> createIdDbenty() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    await databaseHelper.insertDbenty(Dbenty(keys: 'PIN'));
  }

  Future<void> updateIdDbenty(String value) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    await databaseHelper.updateDbenty(Dbenty(keys: 'PIN', value: value));
  }
}
