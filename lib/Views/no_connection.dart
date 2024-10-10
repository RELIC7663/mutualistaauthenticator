import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mutualista Imabura',
      home: Scaffold(
        body: SinConexionScreen(),
      ),
    );
  }
}

class SinConexionScreen extends StatelessWidget {
  const SinConexionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Aquí puedes agregar una imagen si lo deseas
              // Image.asset(
              //   'assets/images/your_image.png',
              //   height: 100,
              // ),
              const SizedBox(height: 20), // Espacio entre la imagen y el texto
              const Text(
                'Sin conexión',
                style: TextStyle(
                  color: Color.fromARGB(255, 228, 226, 226), // Color del texto
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Verifica tu conexión a Internet.',
                style: TextStyle(
                  color: Color.fromARGB(255, 228, 226, 226), // Color del texto
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
