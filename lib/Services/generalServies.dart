import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:mutualistaauthenticator/Model/Requests.dart';
import 'package:mutualistaauthenticator/Model/Responses.dart';
import 'package:mutualistaauthenticator/Services/generalServies.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';  // Para usar jsonEncode y jsonDecode
import 'package:http/http.dart' as http;


class Generalservies {

  var url = "https://bancaweb.mutualistaimbabura.com/TokenAPi/api/";
  
  // Suponiendo que ya tienes las clases LoginRequest, Response, y TokenResponse creadas

  Future<Response> checkConnection() async {
    try {
      // Verifica si hay conexión a la red
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return Response(
          isSuccess: false,
          message: "No internet connection available",
        );
      }

      // Verifica si se puede llegar a google.com
      final result = await http.get(Uri.parse('https://google.com'));
      if (result.statusCode != 200) {
        return Response(
          isSuccess: false,
          message: "Unable to reach the server",
          result: result.statusCode, // Agrega el código de estado en result
        );
      }

      // Si ambas verificaciones pasan
      return Response(
        isSuccess: true,
        message: "Connected successfully",
        result: result.body, // Aquí puedes devolver más datos si lo deseas
      );
    } catch (e) {
      // Maneja cualquier excepción
      return Response(
        isSuccess: false,
        message: "An error occurred: $e",
        result: null,
      );
    }
  }

  Future<Response> loginAsync(String urlBase, String servicePrefix, String controller, LoginRequest request) async {
    try {
      // Construir la URL completa
      String url = '$urlBase$servicePrefix$controller/?id=${request.cliIdentificacion}';

      // Enviar la solicitud HTTP GET
      final http.Response response = await http.get(Uri.parse(url));

      // Leer la respuesta
      String result = response.body;

      // Verificar si la respuesta fue exitosa
      if (response.statusCode != 200) {
        return Response(
          isSuccess: false,
          message: result,
        );
      }

      // Parsear la respuesta JSON al objeto TokenResponse
      Map<String, dynamic> jsonResult = json.decode(result);
      TokenResponse token = TokenResponse.fromJson(jsonResult);

      // Retornar la respuesta exitosa
      return Response(
        isSuccess: true,
        result: token,
      );
    } catch (e) {
      // Manejo de errores y retorno de respuesta fallida
      return Response(
        isSuccess: false,
        message: e.toString(),
      );
    }
  }

}




