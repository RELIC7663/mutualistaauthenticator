import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mutualista Imbabura',
      home: Scaffold(
        body: CargandoScreen(),
      ),
    );
  }
}

class CargandoScreen extends StatefulWidget {
  const CargandoScreen({Key? key}) : super(key: key);

  @override
  _CargandoScreenState createState() => _CargandoScreenState();
}

class _CargandoScreenState extends State<CargandoScreen> {
  int backPressCounter = 0; // Contador de veces que se presionó el botón de atrás

  Future<bool> _onWillPop() async {
    backPressCounter++;
    if (backPressCounter == 1) {
      // Mostrar advertencia
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Presiona de nuevo para salir de la aplicación.'),
          duration: const Duration(seconds: 2), // Duración del mensaje
        ),
      );
      return false; // Evitar cerrar la aplicación
    } else {
      // Reiniciar el contador y cerrar la aplicación
      backPressCounter = 0; 
      return true; // Cerrar la aplicación
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Interceptar el botón de atrás
      child: Scaffold(
        backgroundColor: const Color(0xFF222e7a), // Color de fondo
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Espacio entre el encabezado y el texto

                // Texto principal
                const Text(
                  'Mutualista Imbabura',
                  style: TextStyle(
                    color: Color.fromARGB(255, 228, 226, 226), // Color del texto
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10), // Espacio entre los textos

                // Texto de "Cargando..."
                const Text(
                  'Cargando..',
                  style: TextStyle(
                    color: Color.fromARGB(255, 228, 226, 226), // Color del texto
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 40), // Espacio antes del indicador de progreso

                // Indicador de progreso con animación
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 5.0,
                  ),
                ),

                const SizedBox(height: 20), // Espacio después del indicador de progreso

                // Texto de mensaje adicional
                const Text(
                  'Por favor espere...',
                  style: TextStyle(
                    color: Color.fromARGB(255, 228, 226, 226),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
