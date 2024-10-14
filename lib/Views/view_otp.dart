import 'package:flutter/material.dart';
import 'package:mutualistaauthenticator/Services/generalServies.dart';
import 'package:mutualistaauthenticator/Views/view_auth.dart';
import 'package:mutualistaauthenticator/Views/view_conf_pin.dart';
import 'package:mutualistaauthenticator/Views/view_info.dart';
import 'package:mutualistaauthenticator/Views/test.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';

class VistaOTPWidget extends StatefulWidget {
  const VistaOTPWidget({Key? key}) : super(key: key);

  @override
  _VistaOTPWidgetState createState() => _VistaOTPWidgetState();
}

class _VistaOTPWidgetState extends State<VistaOTPWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final DatabaseHelper _apiDB = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222e7a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF112659),
        title: Align(
          alignment: const AlignmentDirectional(-0.52, 0),
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
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        //automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF112659),
          child: ListView(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFF112659),
                ),
                child: Image.asset(
                  'assets/images/Title.png',
                  width: 217,
                  height: 47,
                  fit: BoxFit.contain,
                  alignment: const Alignment(0, 0),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                title: Text(
                  'Inicio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  // Implementa la acción para la opción "Inicio"
                  //Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                title: Text(
                  'Acerca de',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  // Implementa la acción para la opción "Acerca de"
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewView(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                title: Text(
                  'Configurar pin de seguridad',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  // Redirige a la vista de creación de PIN
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreatePinView(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  // Implementa la acción para la opción "Cerrar sesión"
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alerta'),
                        content: const Text(
                          'Estás por cerrar sesión.',
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // Cerrar la alerta
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Cerrar la alerta
                              Navigator.of(context).pop();
                              
                              _apiDB.deleteAllEntries();
                              

                              // Navegar a otra vista
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VistaIdentificacionWidget()),
                              );
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          color: const Color(0x00222e7a),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                color: const Color(0x00222e7a),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: CircularProgressIndicator(
                        value: _controller.value,
                        strokeWidth: 10,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    Text(
                      _controller.isAnimating ? "102560" : 'OTP generado',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
