import 'package:flutter/material.dart';

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
            )),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Align(
          alignment: const AlignmentDirectional(-1, -1),
          child: SingleChildScrollView(
            child: Container(
              //width: double.infinity,
              //height: 300,
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
                      //widthFactor: 0.75, // 80% del ancho de la pantalla
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextFormField(
                            //focusNode: _focusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: 'Ingrese el codigo de Verificacion',
                              hintText: 'Verifique su didentidad',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ), // Color del borde
                              ),
                              enabledBorder: OutlineInputBorder(
                                // Borde cuando el campo no está enfocado
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 170, 170, 170),
                                ), // Color del borde
                              ),
                              focusedBorder: OutlineInputBorder(
                                // Borde cuando el campo está enfocado
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ), // Color del borde
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.white,
                              ), // Color del texto de la etiqueta
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ), // Color del texto de sugerencia
                              contentPadding: const EdgeInsets.all(24),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              print('Ingrese el Codigo de Verficacion');
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
                              print('Ingrese su identificación');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Solicitar nuevo codigo'),
                          )
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
