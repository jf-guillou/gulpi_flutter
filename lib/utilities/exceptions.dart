class NotImplementedException implements Exception {
  String errMsg() => "Not implemented";
}

class AuthFailedException implements Exception {
  String errMsg() => "Authentication failed, no session token available";
}

class AuthExpiredException implements Exception {
  String errMsg() => "Session token is not valid";
}

class AppTokenException implements Exception {
  String errMsg() => "Application token is not valid";
}

class ApiWrongResourceException implements Exception {
  String errMsg() => "Invalid resource requested";
}

class ApiMissingAuth implements Exception {
  String errMsg() => "Missing authentication parameters";
}

class UnkownAPIErrorException implements Exception {
  String msg;
  UnkownAPIErrorException(this.msg);
  String errMsg() => "Unexpected API error : $msg";
  @override
  String toString() => errMsg();
}

class UnexpectedStatusCodeException implements Exception {
  int code;
  UnexpectedStatusCodeException(this.code);
  String errMsg() => "Unexpected status code : $code";
  @override
  String toString() => errMsg();
}
