class LoginRequest {
  String? cliIdentificacion;

  LoginRequest({this.cliIdentificacion});

  Map<String, dynamic> toJson() {
    return {
      'cli_identificacion': cliIdentificacion,
    };
  }
}

class PinEmailRequest {
  int? tokCliente;
  String? toCliPin;

  PinEmailRequest({this.tokCliente, this.toCliPin});

  Map<String, dynamic> toJson() {
    return {
      'tok_cliente': tokCliente,
      'to_cli_pin': toCliPin,
    };
  }
}

class TokenCodeRequest {
  int? tokCliente;

  TokenCodeRequest({this.tokCliente});

  Map<String, dynamic> toJson() {
    return {
      'tok_cliente': tokCliente,
    };
  }
}

class BlockRequest {
  int? tokCliente;

  BlockRequest({this.tokCliente});

  Map<String, dynamic> toJson() {
    return {
      'tok_cliente': tokCliente,
    };
  }
}

class LogoutRequestOne {
  int? tokCliente;

  LogoutRequestOne({this.tokCliente});

  Map<String, dynamic> toJson() {
    return {
      'tok_cliente': tokCliente,
    };
  }
}


