import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:mutualistaauthenticator/Model/Requests.dart';
import 'package:mutualistaauthenticator/Model/Responses.dart';
import 'package:mutualistaauthenticator/Services/generalServies.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';  // Para usar jsonEncode y jsonDecode
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

class Generalservies {

  var url = "https://bancaweb.mutualistaimbabura.com/TokenAPi/api/";
  final Connectivity _connectivity = Connectivity();
  // Suponiendo que ya tienes las clases LoginRequest, Response, y TokenResponse creadas



  Future<Response> checkConnection() async {
    try {

      // Verifica si se puede llegar a google.com
      final result = await http.get(Uri.parse('https://www.google.com'));
      if (result.statusCode != 200) {
        return Response(
          isSuccess: false,
          message: "Unable to reach the server",
          result: result.statusCode, 
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
      if (response.statusCode != 201) {
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

  Future<Response> validateEmailPin(String urlBase, String servicePrefix, String controller, String tokenType, String accessToken, PinEmailRequest request) async {
      try {
      // Convertimos el request a un string JSON
      String requestString = jsonEncode(request);

      // Creamos el contenido de la solicitud con el tipo de contenido adecuado
      var content = http.Request('POST', Uri.parse("$urlBase$servicePrefix$controller"))
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': '$tokenType $accessToken',
        })
        ..body = requestString;

      // Realizamos la solicitud POST
      var response = await content.send();

      // Obtenemos el resultado como string
      var result = await response.stream.bytesToString();

      // Verificamos si la respuesta fue exitosa
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Deserializamos la respuesta a un objeto (similar a TokenResponse)
        var token = jsonDecode(result); // Puedes crear tu modelo TokenResponse si es necesario

        return Response(
          isSuccess: true,
          result: token,
        );
      } else {
        return Response(
          isSuccess: false,
          message: result,
        );
      }
    } catch (e) {
      return Response(
        isSuccess: false,
        message: e.toString(),
      );
    }
  }

  Future<Response> getCodeByUsername(String urlBase, String servicePrefix, String controller, String tokenType, String accessToken, TokenCodeRequest request) async {
    try {
      // Creamos el cliente http
      var client = http.Client();

      // Construimos la URL
      String url = "$urlBase$servicePrefix$controller/?cliente=${request.tokCliente}";

      // Definimos las cabeceras de la solicitud
      var headers = {
        'Authorization': '$tokenType $accessToken',
        'Content-Type': 'application/json',
      };

      // Realizamos la solicitud GET
      var response = await client.get(Uri.parse(url), headers: headers);

      // Leemos el cuerpo de la respuesta como string
      String result = response.body;

      // Verificamos si la respuesta fue exitosa
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Deserializamos el JSON al modelo HomeResponse
        var homeResponse = jsonDecode(result); // Puedes crear la clase HomeResponse

        return Response(
          isSuccess: true,
          result: homeResponse,
        );
      } else {
        return Response(
          isSuccess: false,
          message: "Su sesión ha finalizado",
        );
      }
    } catch (e) {
      return Response(
        isSuccess: false,
        message: e.toString(),
      );
    }

}

  Future<Response> getLogoutUserOne(String urlBase, String servicePrefix, String controller, String tokenType, String accessToken, LogoutRequestOne request) async {
    try {
      // Convertimos el request a JSON
      String requestString = jsonEncode(request);

      // Configuramos el cliente HTTP
      var client = http.Client();

      // Configuramos las cabeceras
      var headers = {
        'Authorization': '$tokenType $accessToken',
        'Content-Type': 'application/json',
      };

      // Construimos la URL
      String url = "$urlBase$servicePrefix$controller";

      // Realizamos la solicitud POST
      var response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: requestString,
      );

      // Obtenemos el resultado como string
      String result = response.body;

      // Verificamos si la respuesta fue exitosa
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Response(
          isSuccess: true,
          result: result,
        );
      } else {
        return Response(
          isSuccess: false,
          message: "Compruebe su conexión",
        );
      }
    } catch (e) {
      return Response(
        isSuccess: false,
        message: e.toString(),
      );
    }
  }

  Future<Response> blockUser(String urlBase, String servicePrefix, String controller, BlockRequest request) async {
    try {
      // Convertimos el objeto request a JSON
      String requestString = jsonEncode(request);

      // Configuramos el cliente HTTP
      var client = http.Client();

      // Configuramos las cabeceras
      var headers = {
        'Content-Type': 'application/json',
      };

      // Construimos la URL
      String url = "$urlBase$servicePrefix$controller";

      // Realizamos la solicitud POST
      var response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: requestString,
      );

      // Leemos la respuesta como string
      String result = response.body;

      // Verificamos si la respuesta fue exitosa
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Deserializamos el JSON en un objeto TokenResponse
        var token = jsonDecode(result); // Puedes crear la clase TokenResponse para mapear este resultado

        return Response(
          isSuccess: true,
          result: token,
        );
      } else {
        return Response(
          isSuccess: false,
          message: result,
        );
      }
    } catch (e) {
      return Response(
        isSuccess: false,
        message: e.toString(),
      );
    }
  }

}




