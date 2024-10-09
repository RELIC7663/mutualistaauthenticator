class Response {
  bool? isSuccess;
  String? message;
  dynamic result; // Puede ser cualquier tipo de objeto

  Response({this.isSuccess, this.message, this.result});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      isSuccess: json['IsSuccess'],
      message: json['Message'],
      result: json['Result'],
    );
  }
}

class BlockResponse {
  int? blockResponse;

  BlockResponse({this.blockResponse});

  factory BlockResponse.fromJson(Map<String, dynamic> json) {
    return BlockResponse(
      blockResponse: json['blockresponse'],
    );
  }
}

class TokenResponse {
  String? token;
  int? idResponse;
  String? email;
  String? cliId;

  TokenResponse({this.token, this.idResponse, this.email, this.cliId});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      token: json['token'],
      idResponse: json['idresponse'],
      email: json['email'],
      cliId: json['cli_id'],
    );
  }
}

class HomeResponse {
  String? time;
  String? value;

  HomeResponse({this.time, this.value});

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      time: json['time'],
      value: json['value'],
    );
  }
}
