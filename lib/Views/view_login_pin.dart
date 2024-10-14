import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Views/view_otp.dart';
import 'package:mutualistaauthenticator/Model/dbenty.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VistaIdentificacionWidget1 extends StatefulWidget {
  const VistaIdentificacionWidget1({Key? key}) : super(key: key);
  
  @override
  _VistaIdentificacionWidget1State createState() =>
      _VistaIdentificacionWidget1State();
}

class _VistaIdentificacionWidget1State
    extends State<VistaIdentificacionWidget1> {
  late TextEditingController _pinController;

  @override
  void initState() {
    super.initState();

    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<bool> verifyPIN(String pin) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    List<Dbenty> userList = await databaseHelper.getDbenty();
    return userList.any((entry) => entry.keys == 'PIN' && entry.value == pin);
  }

  Future<void> updatePIN(String pin) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    await databaseHelper.updateDbenty(Dbenty(keys: 'PIN', value: pin));
  }

  @override
  Widget build(BuildContext context) {
    
    String _pinCode1 = '';
    DatabaseHelper _asd = DatabaseHelper();
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
        actions: const [],
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Align(
          alignment: const AlignmentDirectional(-1, -1),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              color: const Color(0x00222e7a),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/asd.png',
                      fit: BoxFit.contain,
                      width: 500,
                      height: 250,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'Valide su información para acceder al token',
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
                  ElevatedButton(
                    onPressed:  () async {
                      // Acción para confirmar la creación del PIN
                      // Esto puede incluir navegación a la siguiente vista
                      final asd1 = _asd.getPIN();
                      bool isValid = await verifyPIN(_pinCode1);
                      if (isValid==false) {
                        // Si los PINs no coinciden, mostrar un mensaje de error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error'),
                          ),
                        );
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Correcto'),
                            content: const Text(
                              'Ingresando..',
                            ),
                            actions: <Widget>[
                              
                              TextButton(
                                onPressed: () async {
                                  // Acción al presionar el botón de confirmar
                                  Navigator.of(context).pop();
                                  
                                  Navigator.pushReplacement(
                                    
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VistaOTPWidget()),
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
                  
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
