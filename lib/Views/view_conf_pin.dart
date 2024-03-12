import 'package:flutter/material.dart';

class CreatePinView extends StatelessWidget {
  const CreatePinView({Key? key}) : super(key: key);

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
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      // Aquí puedes personalizar el estilo del texto de la etiqueta y el borde
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    obscureText: true, // Oculta la contraseña
                    style: TextStyle(color: Colors.white), // Estilo del texto
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      border: OutlineInputBorder(),
                      // Aquí puedes personalizar el estilo del texto de la etiqueta y el borde
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    obscureText: true, // Oculta la contraseña
                    style: TextStyle(color: Colors.white), // Estilo del texto
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Acción para confirmar la creación del PIN
                      // Esto puede incluir validación de contraseñas y navegación a la siguiente vista
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
}
