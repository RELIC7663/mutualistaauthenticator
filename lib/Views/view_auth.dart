import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mutualistaauthenticator/Model/Responses.dart';
import 'package:mutualistaauthenticator/Views/view_cod_ver.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';
import 'package:mutualistaauthenticator/Model/dbenty.dart';
import 'package:mutualistaauthenticator/controller/appController.dart';
import 'package:mutualistaauthenticator/Views/test.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mutualistaauthenticator/Services/generalServies.dart';
import 'package:flutter/services.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mutualista Imabura',
      home: Scaffold(
        body: VistaIdentificacionWidget(),
      ),
    );
  }
}

class VistaIdentificacionWidget extends StatefulWidget {
  const VistaIdentificacionWidget({Key? key}) : super(key: key);

  @override
  _VistaIdentificacionWidgetState createState() =>
      _VistaIdentificacionWidgetState();
}

class _VistaIdentificacionWidgetState extends State<VistaIdentificacionWidget> {
  late FocusNode _focusNode;
  TextEditingController _textEditingController = TextEditingController();

  final Generalservies _appservice = Generalservies();
  final appController _appController = appController();
  final DatabaseHelper _appdb = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    //TextEditingController _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_focusNode.canRequestFocus) {
          FocusScope.of(context).requestFocus(_focusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
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
                              controller: _textEditingController,
                              focusNode: _focusNode,

                              //autofocus: true,
                              decoration: InputDecoration(
                                labelText: 'Ingrese su identificación',
                                hintText: 'Cédula / RUC / Pasaporte',
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
                              keyboardType: TextInputType
                                  .number, // Cambia TextInputType.emailAddress a TextInputType.number
                                  
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () async {
                                // Verificar si existe un Dbenty con la clave "ID"
                                bool idExists = await checkIfIdExists();
                                bool idExistsCedula = await checkInfoCedula();
                                final idconnection = await _appservice.checkConnection();
                                if (!idExists) {
                                  await createIdDbenty();
                                }
                                String idValue = _textEditingController.text;
                                //uso de el api de la mutialista para obtener datos
                                _appController.loginAsync2(idValue);

                                //await updateIdDbenty(idValue);

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context)  {
                                    if (idconnection.isSuccess==true){
                                      if (idExistsCedula)
                                      {
                                        return AlertDialog(
                                          title: const Text('CORRECTO'),
                                          content: const Text(
                                            'Mutualista Imbabura ha enviado un código de verificación a 09******06, si no recibe ningún código por favor actualice su información en una de nuestras oficinas',
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                // Cerrar la alerta
                                                Navigator.of(context).pop();

                                                // Navegar a otra vista
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Vista_cod_ver()),
                                                );
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      
                                      }else{
                                        return AlertDialog(
                                          title: const Text('No esta Registrado'),
                                          content: const Text(
                                            'Mutualista Imbabura no tiene registro de este Usuario',
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                // Cerrar la alerta
                                                Navigator.of(context).pop();

                                                // Navegar a otra vista
                                                
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );

                                      } 
                                    }
                                    else{
                                      return AlertDialog(
                                          title: const Text('Error de Conexión'),
                                          content: const Text(
                                            'No se pudo establecer una conexión con el servidor. Por favor, verifica tu conexión a internet e intenta nuevamente.',
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                // Cerrar la alerta
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );

                                    }                                   
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Ingrese su identificación'),
                            ),
                            
                            TextButton(
  onPressed: () async {
    // Verificar si existe un Dbenty con la clave "ID"
    bool idExists = await checkIfIdExists();
    bool idExistsCedula = await checkInfoCedula();
    
    if (!idExists) {
      await createIdDbenty();
    }
    
    String idValue = _textEditingController.text;

    // Uso de la API de la mutualista para obtener datos
    //_appController.loginAsync2(idValue);

    // Mostrar un diálogo al terminar si es necesario
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Procesamiento completado"),
          content: Text("La identificación ha sido procesada exitosamente."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestPage(),
                  ),
                );
              },
              child: Text("Cerrar"),
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
  child: const Text('Ingrese su identificación'),
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
      ),
    );
  }

  Future<bool> checkIfIdExists() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    List<Dbenty> userList = await databaseHelper.getDbenty();
    return userList.any((entry) => entry.keys == 'USER_ID');
  }

  Future<bool> checkInfoCedula() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    List<Dbenty> userList = await databaseHelper.getDbenty();
    return userList.any((entry) => entry.keys == 'USER_ID' && entry.value.length == 10);
  }

  Future<void> createIdDbenty() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    await databaseHelper.insertDbenty(Dbenty(keys: 'USER_ID'));
  }

  Future<void> updateIdDbenty(String value) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    await databaseHelper.updateDbenty(Dbenty(keys: 'USER_ID', value: value));
  }
}

