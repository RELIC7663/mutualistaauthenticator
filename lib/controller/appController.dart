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
    
  
  Future<bool> loginAsync2(String cedula) async {

    Response datosconecction = await _apiService.checkConnection();
    
    if ( datosconecction.isSuccess == true)
    {
        LoginRequest request = LoginRequest(
        cliIdentificacion: cedula,  // Inicializa el objeto de la solicitud
      );

      // Llamada al servicio API
      
      //Response response = await _apiService.loginAsync(url, "TokenRegistros", "/RequestCode", request);
      //pilas

      Response response1  = Response(
        isSuccess: true,
        result: TokenResponse (
          token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMzQ0NTk3IiwianRpIjoiMTE2MDM4ZDgtNTE1Mi00MmJlLWE0ZTgtZTIyODQ4ZmIzZWE1IiwiZXhwIjoxNzI5MDk0MjIwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo0NDMyMS8iLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo0NDMyMS8ifQ.IofK21MuPYCOG6vm2m5fNteVHa_UKOvPv0Db4EMbnb8",
          idResponse : 1344597,
          email :"09******06",
          cliId: null,
        ),
      );

      if (!response1.isSuccess!) {
        String mensaje;

        if (response1.message == "0") {
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
          
        } else if (response1.message == "1") {
          mensaje = "Su aplicación ya se encuentra iniciada en otro dispositivo, cierre sesión e inténtelo nuevamente";
          return false;
        } else if (response1.message == "2") {
          mensaje = "Su acceso se encuentra bloqueado, comuníquese con su asesor";
          return false;
        } else {
          mensaje = "Ha ocurrido una interrupción con el servicio, por favor inténtelo nuevamente";
          return false;
        }

        print(mensaje); // Muestra el mensaje al usuario o lo guarda en algún lugar según tu lógica
        return false;

      } else {
        // MAPEO DEL RESULTADO DE LA RESPUESTA Result

        
        TokenResponse loginResponse = response1.result as TokenResponse;


        DatabaseHelper databaseHelper = DatabaseHelper();
        // Guarda el token

        await databaseHelper.updateDbenty(Dbenty(keys: 'ID', value: cedula));// Guarda Token
        await databaseHelper.updateDbenty(Dbenty(keys: 'TOKEN', value: jsonEncode(loginResponse)));// Guarda Token
        await databaseHelper.updateDbenty(Dbenty(keys: 'USER_ID', value: loginResponse.idResponse.toString())); // id del responsive
        await databaseHelper.updateDbenty(Dbenty(keys: 'NUM_INTENTOS', value: '0')); // El número de intentos es 0 al inicio
        return true;
      }

    }else{
      
      String mensaje;
      mensaje = "Error de conexión";
      return false;
    }
    
  }

  Future<bool> cellValidateAsync(String Pin_ingresado) async {
   
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    List<Dbenty> userList = await databaseHelper.getDbenty();
    Dbenty idEntry = userList.firstWhere(
      (entry) => entry.keys == 'TOKEN' 
    );

    Response datosconecction = await _apiService.checkConnection();
    if ( datosconecction.isSuccess == true)
    {
      Map<String, dynamic> jsonMap = jsonDecode(idEntry.value);
      TokenResponse loginResponse = TokenResponse.fromJson(jsonMap);
      PinEmailRequest request =PinEmailRequest(toCliPin:  Pin_ingresado,tokCliente: loginResponse.idResponse );
      
      
      
      //Response response = await _apiService.validateEmailPin(url, "TokenRegistros", "/ValidateCode", "bearer", loginResponse.token.toString(), request);
      Response response  = Response(
        isSuccess: true,
        result: TokenResponse (
          token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMzQ0NTk3IiwianRpIjoiYTE1MTYyYjktNWRhMC00N2M0LThiYmQtN2EyNjMwZjg3ZWFjIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiY2xpZW50ZSIsImV4cCI6MTg4Njg2MDcyMiwiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzMjEvIiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzMjEvIn0.KgT0_q_l_kZ3RbyNxKviBTkonUa_c-AiPS0BMO9d0og",
          idResponse : 1344597,
          email :"09******06",
          cliId: null,
        ),
      );
      

      if (response.isSuccess==false){
              
        int contador = await _apicontrollerdb.getNumIntentos();
        contador++;
        await  _apicontrollerdb.update_NUM_INTENTOS_Dbenty(contador.toString()) ;
        
        //block de user
        if (contador<15)
        {
          return false;
        }
        else
        {
          BlockRequest blockRequest = BlockRequest(tokCliente: loginResponse.idResponse);
          await _apiService.blockUser(url, "TokenRegistros", "/Block", blockRequest);
          return false;
        }
        
      }
      TokenResponse validationResponse = response.result as TokenResponse;
      await databaseHelper.updateDbenty(Dbenty(keys: 'TOKEN', value: jsonEncode(validationResponse)));
      return true;
    }
    return false;
      
  }

  Future<void> solicitarTokenAsync() async {
    try {
      String tokenJson = await  _apicontrollerdb.getToken();      
      int User_id = await  _apicontrollerdb.get_idUSER();      
      Map<String, dynamic> tokenMap = jsonDecode(tokenJson);
      TokenResponse loginResponse = TokenResponse.fromJson(tokenMap);
      TokenCodeRequest request = TokenCodeRequest(
        tokCliente: User_id, 
      );

      Response response2 = await _apiService.getCodeByUsername(
        url,
        "TokenRegistros",
        "/LogOut",
        "bearer",
        loginResponse.token.toString(),
        request,
      );

      if (response2.isSuccess==true) {
       
        // Parsear la respuesta JSON
        Map<String, dynamic> responseMap = jsonDecode(response2.result);
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


Future<void> cerrarSesionAsync() async {
      // string correcto
      String tokenJson = '{"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMzQ0NTk3IiwianRpIjoiYTE1MTYyYjktNWRhMC00N2M0LThiYmQtN2EyNjMwZjg3ZWFjIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiY2xpZW50ZSIsImV4cCI6MTg4Njg2MDcyMiwiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzMjEvIiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzMjEvIn0.KgT0_q_l_kZ3RbyNxKviBTkonUa_c-AiPS0BMO9d0og","idresponse":1344597,"expiration":"2029-10-16T15:58:42Z"}' ;      
      Map<String, dynamic> tokenMap = jsonDecode(tokenJson);
      TokenResponse loginResponse = TokenResponse.fromJson(tokenMap);
      
      LogoutRequestOne request2 = LogoutRequestOne(tokCliente: loginResponse.idResponse);

      Response response2 = await _apiService.getLogoutUserOne(
        url,
        "TokenRegistros",
        "/LogOut",
        "bearer",
        loginResponse.token.toString(),
        request2,
      );

      
    
  }



// Método para mostrar alertas con un mensaje
  void mostrarAlerta(String title, String message) {
    // Implementa aquí tu lógica para mostrar un mensaje (por ejemplo, usando un dialog)
    print('$title: $message'); // Solo un ejemplo, reemplaza esto con tu lógica
  }


}



