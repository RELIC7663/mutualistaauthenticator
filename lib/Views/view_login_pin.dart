import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Views/view_otp.dart';
import 'package:mutualistaauthenticator/Model/dbenty.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';

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
                    padding: const EdgeInsets.all(16),
                    child: FractionallySizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _pinController,
                            decoration: InputDecoration(
                              labelText: 'Ingrese su PIN',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 170, 170, 170),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              contentPadding: const EdgeInsets.all(24),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () async {
                              String pin = _pinController.text;
                              bool isValid = await verifyPIN(pin);

                              // Mostrar una alerta según el resultado de la verificación
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(isValid ? 'CORRECTO' : 'ERROR'),
                                    content: Text(isValid
                                        ? 'Ingreso Exitoso!!'
                                        : 'PIN incorrecto. Por favor, inténtelo de nuevo.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          // Cerrar la alerta
                                          Navigator.of(context).pop();

                                          // Si el PIN es válido, actualizarlo en la base de datos
                                          if (isValid) {
                                            //await updatePIN(pin);
                                            // Navegar a la siguiente vista
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    VistaOTPWidget(),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Continuar'),
                          ),
                        ],
                      ),
                    ),
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
