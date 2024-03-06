import 'package:flutter/material.dart';

class VistaOTPWidget extends StatefulWidget {
  @override
  _VistaOTPWidgetState createState() => _VistaOTPWidgetState();
}

class _VistaOTPWidgetState extends State<VistaOTPWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30), // Duración de la animación (30 segundos)
    );
    _controller.repeat(); // Iniciar la animación
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
      body: Center(
        child: Container(
          color: const Color(0x00222e7a),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                color: const Color(0x00222e7a), // Color de fondo
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: CircularProgressIndicator(
                        value: _controller.value,
                        strokeWidth: 10, // Grosor del indicador circular
                        valueColor: AlwaysStoppedAnimation<Color>(Colors
                            .white), // Color del trazo del indicador circular
                      ),
                    ),
                    Text(
                      _controller.isAnimating
                          ? "${((_controller.value) * 30).toInt()}"
                          : 'OTP generado',
                      style: TextStyle(
                          fontSize: 24, color: Colors.white), // Color del texto
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
