import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:mutualistaauthenticator/Model/Requests.dart';
import 'package:mutualistaauthenticator/Model/Responses.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mutualistaauthenticator/Services/generalServies.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';
import 'package:mutualistaauthenticator/Model/dbenty.dart';
class appController {

  
  final Generalservies _apiService = Generalservies();
  var url = "https://bancaweb.mutualistaimbabura.com/TokenAPi/api/";
    
  
  Future<void> loginAsync2(String cedula) async {

    Response datosconecction = await _apiService.checkConnection();
    if ( datosconecction.isSuccess == true)
    {
        LoginRequest request = LoginRequest(
        cliIdentificacion: cedula,  // Inicializa el objeto de la solicitud
      );

      // Llamada al servicio API
      
      Response response = await _apiService.loginAsync(url, "TokenRegistros", "/RequestCode", request);
      //pilas

      if (!response.isSuccess!) {
        String mensaje;

        if (response.message == "0") {
          // Valida la longitud de la identificación
          switch (cedula.length) {
            case 10:
              mensaje = "Por favor ingrese correctamente su identificación";
              break;
            case 13:
              mensaje = "Por favor ingrese correctamente su identificación";
              break;
            default:
              mensaje = "Su identificación es incorrecta";
              break;
          }
        } else if (response.message == "1") {
          mensaje = "Su aplicación ya se encuentra iniciada en otro dispositivo, cierre sesión e inténtelo nuevamente";
        } else if (response.message == "2") {
          mensaje = "Su acceso se encuentra bloqueado, comuníquese con su asesor";
        } else {
          mensaje = "Ha ocurrido una interrupción con el servicio, por favor inténtelo nuevamente";
        }

        print(mensaje); // Muestra el mensaje al usuario o lo guarda en algún lugar según tu lógica
      } else {
        // MAPEO DEL RESULTADO DE LA RESPUESTA Result
        TokenResponse loginResponse = TokenResponse.fromJson(response.result);

        DatabaseHelper databaseHelper = DatabaseHelper();
        // Guarda el token
        await databaseHelper.updateDbenty(Dbenty(keys: 'TOKEN', value: jsonEncode(loginResponse)));// Guarda el ID del usuario
        await databaseHelper.updateDbenty(Dbenty(keys: 'USER_ID', value: loginResponse.idResponse.toString())); // id del responsive
        await databaseHelper.updateDbenty(Dbenty(keys: 'NUM_INTENTOS', value: '0')); // El número de intentos es 0 al inicio

      }

    }else{
      String mensaje;
      mensaje = "Error de conexión";
    }
    
  }



}
