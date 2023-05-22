class AuthFailedException implements Exception {
  String errMsg() => "Authentication failed, no session token available";
}

class AuthExpiredException implements Exception {
  String errMsg() => "Session token is not valid";
}

class UnexpectedStatusCodeException implements Exception {
  int code;
  UnexpectedStatusCodeException(this.code);
  String errMsg() => "Unexpected status code : $code";
}
