import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Views/view_otp.dart';
import 'package:pin_code_fields/pin_code_fields.dart'; // Importa el paquete necesario

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mutualista Imabura',
      home: Scaffold(
        body: Vista_cod_ver(),
      ),
    );
  }
}

class Vista_cod_ver extends StatefulWidget {
  const Vista_cod_ver({Key? key}) : super(key: key);

  @override
  _Vista_cod_verState createState() => _Vista_cod_verState();
}

class _Vista_cod_verState extends State<Vista_cod_ver>
    with TickerProviderStateMixin {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Align(
          alignment: const AlignmentDirectional(-1, -1),
          child: SingleChildScrollView(
            child: Container(
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
                    child: FractionallySizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    20), // Ajusta el espacio a los lados
                            child: PinCodeTextField(
                              appContext: context,
                              length: 6,
                              onChanged: (value) {
                                print(
                                    value); // Manejar el cambio en el código ingresado
                              },
                              textStyle: TextStyle(
                                  color: Colors
                                      .white), // Establece el color del texto a blanco
                              pinTheme: PinTheme(
                                fieldHeight: 44,
                                fieldWidth: 44,
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
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Felicidades'),
                                    content: const Text(
                                      'Su aplicación se ha registrada correctamente.',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VistaOTPWidget()),
                                          );
                                        },
                                        child: const Text('Aceptar'),
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
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              print('Solicitar nuevo código');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Solicitar nuevo código'),
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
