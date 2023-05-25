import 'dart:convert';

import 'package:gulpi/models/appstate_model.dart';

class APIConfig {
  Uri? uri;

  /// Application token identifier
  String? _appToken;

  /// Session user auth token
  String? _userToken;

  /// Session user auth base64 encoded user:login
  String? _authBasic;

  String? _sessionToken;

  static APIConfig fromAppState(AppState app) {
    if (app.url == null || (app.authBasic == null && app.userToken == null)) {
      return APIConfig();
    }

    APIConfig c = APIConfig();
    c.setUrl(app.url!);

    if (app.authBasic != null) {
      c._authBasic = app.authBasic!;
    } else {
      c._userToken = app.userToken!;
    }
    c._appToken = app.appToken;
    c._sessionToken = app.sessionToken;
    return c;
  }

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

  void setAppToken(String token) {
    _appToken = token;
  }

  void setSessionToken(String token) {
    _sessionToken = token;
  }

  String? appTokenHeader() {
    return _appToken;
  }

  String authHeader() {
    if (!hasAuth()) {
      throw 'APIConfig is missing either username & password or auth token';
    }

    return _userToken != null ? 'user_token $_userToken' : 'Basic $_authBasic';
  }

  String? authSessionHeader() {
    return _sessionToken;
  }
}
