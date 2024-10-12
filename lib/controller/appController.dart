import 'dart:convert'; 
import 'package:mutualistaauthenticator/Model/Requests.dart';
import 'package:mutualistaauthenticator/Model/Responses.dart';
import 'package:mutualistaauthenticator/Services/generalServies.dart';
import 'package:mutualistaauthenticator/controller/database_helper.dart';
import 'package:mutualistaauthenticator/controller/encrypt.dart';
import 'package:mutualistaauthenticator/Model/dbenty.dart';
import 'dart:async';



class appController {

  
  final Generalservies _apiService = Generalservies();
  final DatabaseHelper _apicontrollerdb = DatabaseHelper();
  final Secure _apisegure = Secure();

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
        await databaseHelper.insertDbenty(Dbenty(keys: 'TOKEN', value: jsonEncode(loginResponse)));// Guarda Token
        await databaseHelper.insertDbenty(Dbenty(keys: 'USER_ID', value: loginResponse.idResponse.toString())); // id del responsive
        await databaseHelper.insertDbenty(Dbenty(keys: 'NUM_INTENTOS', value: '0')); // El número de intentos es 0 al inicio

      }

    }else{
      
      String mensaje;
      mensaje = "Error de conexión";
    }
    
  }

  Future<void> cellValidateAsync(String Pin_ingresado) async {
   
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    List<Dbenty> userList = await databaseHelper.getDbenty();
    Dbenty idEntry = userList.firstWhere(
      (entry) => entry.keys == 'TOKEN' 
    );

    Response datosconecction = await _apiService.checkConnection();
    if ( datosconecction.isSuccess == true)
    {
      TokenResponse loginResponse = jsonDecode(idEntry.value);
      PinEmailRequest request =PinEmailRequest(toCliPin:  Pin_ingresado,tokCliente: loginResponse.idResponse );
      Response response = await _apiService.validateEmailPin(url, "TokenRegistros", "/ValidateCode", "bearer", loginResponse.token.toString(), request);
      if (response.isSuccess==false){
        
        if (response.message == null || response.message?.isEmpty == true) {
          // Código a ejecutar si el mensaje es nulo o está vacío
        }
      
        int contador = await _apicontrollerdb.getNumIntentos();
        contador++;
        await  _apicontrollerdb.update_NUM_INTENTOS_Dbenty(contador.toString()) ;
        
        if (contador<3)
        {
          //error      
          //retur
        }
        else
        {
          BlockRequest blockRequest = BlockRequest(tokCliente: loginResponse.idResponse);
          await _apiService.blockUser(url, "TokenRegistros", "/Block", blockRequest);
          //error 
          //paso los intentos
        }
        
      }
      TokenResponse validationResponse = response.result;
      await databaseHelper.updateDbenty(Dbenty(keys: 'TOKEN', value: jsonEncode(validationResponse)));
    }
      
  }

  Future<void> solicitarTokenAsync() async {
    try {
      String tokenJson = await  _apicontrollerdb.getToken();      
      int User_id = await  _apicontrollerdb.getUSER();      
      Map<String, dynamic> tokenMap = jsonDecode(tokenJson);
      TokenResponse loginResponse = TokenResponse.fromJson(tokenMap);
      TokenCodeRequest request = TokenCodeRequest(
        tokCliente: User_id, 
      );

      Response response2 = await _apiService.getCodeByUsername(
        url,
        "TokenRegistros",
        "/CreateToken",
        "bearer",
        loginResponse.token.toString(),
        request,
      );

      if (response2.isSuccess==true) {
       

        String responseJson = '{"time": "encryptedTimeString", "value": "encryptedTokenValue"}';
        
        // Parsear la respuesta JSON
        Map<String, dynamic> responseMap = jsonDecode(responseJson);
        HomeResponse homeResponse = HomeResponse.fromJson(responseMap);

        // Desencriptar el tiempo y el token
        int hora = int.parse(Secure.decryptString(homeResponse.time.toString()) ?? '0'); 
        String token = Secure.decryptString(homeResponse.value.toString()) ?? ''; 

        // Variables locales que puedes reemplazar según tu lógica
        String codigo = token;
        double progress = 0;
        
        // Iniciar el temporizador en Dart usando Timer
        Timer.periodic(Duration(seconds: 1), (timer) {
          hora--;
          if (hora == 0) {
            progress = 1.0;
            solicitarTokenAsync(); // Reinicia el proceso cuando el tiempo se acaba
            timer.cancel(); // Detener el temporizador
          } else {
            // Equivalente a un minuto dividido en 60 segundos 1/60 = 0.016
            double progressValue = 1.0 / hora;
            progress += progressValue;
          }
        });



      } else {
        mostrarAlerta("", "Por favor vuelva a intentarlo o compruebe su conexión a internet");
        // Cerrar la aplicación si es necesario
        return;
      }
    } catch (e) {
      mostrarAlerta("Alerta", "Por favor vuelva a intentarlo o compruebe su conexión de internet");
      // Cerrar la aplicación si es necesario
      return;
    }
  }



// Método para mostrar alertas con un mensaje
  void mostrarAlerta(String title, String message) {
    // Implementa aquí tu lógica para mostrar un mensaje (por ejemplo, usando un dialog)
    print('$title: $message'); // Solo un ejemplo, reemplaza esto con tu lógica
  }


}



