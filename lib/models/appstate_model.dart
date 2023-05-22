import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String? _url;
  String? _token;

  AppState() {
    log('AppState');
    _loadState();
  }

  Future<void> _loadState() async {
    log('_loadState');
    var prefs = await SharedPreferences.getInstance();
    _url = prefs.getString('url');
    _token = prefs.getString('token');
    notifyListeners();
  }

  set url(String? url) {
    _url = url;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('url', url ?? ""));
  }

  set token(String? token) {
    _token = token;
    notifyListeners();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('token', token ?? ""));
  }

  String? get url => _url;
  String? get token => _token;
}
