import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String? _url;
  String? _appToken;
  String? _userToken;
  String? _authBasic;
  String? _sessionToken;

  Future<void> loadState() async {
    log('loadState');
    var prefs = await SharedPreferences.getInstance();
    _url = prefs.getString('url');
    _appToken = prefs.getString('apptoken');
    _userToken = prefs.getString('usertoken');
    _authBasic = prefs.getString('authbasic');
    _sessionToken = prefs.getString('sessiontoken');
    notifyListeners();
  }

  String? get url => _url;
  set url(String? url) {
    _url = url;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('url', url ?? ""));
  }

  String? get appToken => _appToken;
  set appToken(String? appToken) {
    _appToken = appToken;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('apptoken', appToken ?? ""));
  }

  String? get userToken => _userToken;
  set userToken(String? userToken) {
    _userToken = userToken;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('usertoken', userToken ?? ""));
  }

  String? get authBasic => _authBasic;
  set authBasic(String? authBasic) {
    _authBasic = authBasic;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('authbasic', authBasic ?? ""));
  }

  String? get sessionToken => _sessionToken;
  set sessionToken(String? sessionToken) {
    _sessionToken = sessionToken;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('sessiontoken', sessionToken ?? ""));
  }
}
