import 'package:flutter/material.dart';

class NewView extends StatelessWidget {
  const NewView({Key? key}) : super(key: key);

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
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  'Acerca de: MUTUALISTA IMBABURA.',
                  style: TextStyle(
                    color: Color.fromARGB(255, 228, 226, 226),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Agrega aquí cualquier otro contenido que desees mostrar en la nueva vista
              Container(
                width: double.infinity,
                height: 300, // Ajusta la altura según tus necesidades
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/info.png',
                    fit: BoxFit
                        .contain, // Ajusta el modo de ajuste según tus necesidades
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Acción para cancelar y regresar a la vista anterior
                  Navigator.pop(context);
                },
                child: Text('Regresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
