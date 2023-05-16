import 'dart:convert';

class APIConfig {
  Uri? uri;

  /// Optional application token identifier
  String? _appToken;

  /// Session user auth token
  String? _userToken;

  /// Session user auth base64 encoded user:login
  String? _authBasic;

  String? _sessionToken;

  bool hasUri() {
    return uri != null;
  }

  bool hasAuth() {
    return _authBasic != null || _userToken != null;
  }

  bool hasSession() {
    return _sessionToken != null;
  }

  void setUrl(String url) {
    uri = Uri.parse(url);
  }

  void setCredentials(String username, String password) {
    _authBasic = base64.encode(utf8.encode('$username:$password'));
    _userToken = null;
  }

  void setUserToken(String token) {
    _userToken = token;
    _authBasic = null;
  }

  void setSessionToken(String token) {
    _sessionToken = token;
  }

  // TODO: this could be nullable
  String appHeader() {
    return _appToken != null ? "App-Token: $_appToken" : "";
  }

  String authHeader() {
    if (!hasAuth()) {
      throw 'APIConfig is missing either username & password or auth token';
    }

    return _userToken != null ? 'user_token $_userToken' : 'Basic $_authBasic';
  }

  String authSessionHeader() {
    return "Session-Token: $_sessionToken";
  }
}
