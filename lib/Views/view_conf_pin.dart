import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Views/view_login_pin.dart';
import 'package:mutualistaauthenticator/Model/dbenty.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';
import 'package:pin_code_fields/pin_code_fields.dart'; // Importa el paquete necesario

class CreatePinView extends StatelessWidget {
  CreatePinView({Key? key}) : super(key: key);

  String _pinCode1 = '';
  String _pinCode2 = '';
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
                      'Ingrese el pin de inicio de sesión',
                      style: TextStyle(
                        color: Color.fromARGB(255, 228, 226, 226),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) {
                        // Manejar el cambio en el PIN ingresado
                        print(value);
                      },
                      textStyle: TextStyle(
                          color: Colors
                              .white), // Establece el color del texto a blanco
                      pinTheme: PinTheme(
                        fieldHeight: 50,
                        fieldWidth: 40,
                        borderWidth: 2,
                        borderRadius: BorderRadius.circular(12),
                        shape: PinCodeFieldShape.box,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white,
                        selectedColor: Colors.white,
                        activeFillColor: Colors.transparent,
                        inactiveFillColor: Colors.transparent,
                        selectedFillColor: Colors.transparent,
                      ),
                      obscureText:
                          true, // Hace que los caracteres del PIN sean ocultos
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        // Validar que el PIN tenga una longitud de 6 caracteres
                        if (value!.length != 6) {
                          return 'El PIN debe tener 6 dígitos';
                        }
                        return null; // Retorna null si la validación es exitosa
                      },
                      // Almacena el valor ingresado en la variable pinCode1
                      // para su posterior comparación
                      onCompleted: (value) {
                        // Almacenar el PIN completado en la variable pinCode1
                        _pinCode1 = value;
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'Confirme el pin de inicio de sesión',
                      style: TextStyle(
                        color: Color.fromARGB(255, 228, 226, 226),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) {
                        // Manejar el cambio en el PIN ingresado
                        print(value);
                      },
                      textStyle: TextStyle(
                          color: Colors
                              .white), // Establece el color del texto a blanco
                      pinTheme: PinTheme(
                        fieldHeight: 50,
                        fieldWidth: 40,
                        borderWidth: 2,
                        borderRadius: BorderRadius.circular(12),
                        shape: PinCodeFieldShape.box,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white,
                        selectedColor: Colors.white,
                        activeFillColor: Colors.transparent,
                        inactiveFillColor: Colors.transparent,
                        selectedFillColor: Colors.transparent,
                      ),
                      obscureText:
                          true, // Hace que los caracteres del PIN sean ocultos
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        // Validar que el PIN tenga una longitud de 6 caracteres
                        if (value!.length != 6) {
                          return 'El PIN debe tener 6 dígitos';
                        }
                        return null; // Retorna null si la validación es exitosa
                      },
                      // Almacena el valor ingresado en la variable pinCode2
                      // para su posterior comparación
                      onCompleted: (value) {
                        // Almacenar el PIN completado en la variable pinCode2
                        _pinCode2 = value;
                      },
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Acción para confirmar la creación del PIN
                      // Esto puede incluir navegación a la siguiente vista
                      if (_pinCode1 != _pinCode2) {
                        // Si los PINs no coinciden, mostrar un mensaje de error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Los PINs no coinciden'),
                          ),
                        );
                        return;
                      }
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
                                  bool pinExists = await checkIfPinExists();
                                  if (!pinExists) {
                                    await createPinDbenty();
                                  }
                                  await updatePIN(_pinCode1);
                                  // Navegar a otra vista
                                  Navigator.pushReplacement(
                                    
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

  Future<bool> checkIfPinExists() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    List<Dbenty> userList = await databaseHelper.getDbenty();
    return userList.any((entry) => entry.keys == 'PIN');
  }

  Future<void> createPinDbenty() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    await databaseHelper.insertDbenty(Dbenty(keys: 'PIN'));
  }
  
    Future<void> updatePIN(String pin) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    await databaseHelper.updateDbenty(Dbenty(keys: 'PIN', value: pin));
  }
}
