import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:gulpi/models/item_model.dart';
import 'package:gulpi/utilities/item_types.dart';
import 'package:http/http.dart' as http;
import 'package:gulpi/models/api_config_model.dart';

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();
  static const prefix = 'apirest.php';

  final APIConfig config = APIConfig();

  Uri uri(String path, [Map<String, dynamic>? queryParameters]) {
    assert(config.hasUri());

    List<String> pathSegments = config.uri!.pathSegments.toList()
      ..add(prefix)
      ..add(path);
    return config.uri!
        .replace(pathSegments: pathSegments, queryParameters: queryParameters);
  }

  Map<String, String> headers({session = true, json = false}) {
    return {
      HttpHeaders.authorizationHeader:
          session ? config.authSessionHeader() : config.authHeader(),
      HttpHeaders.contentTypeHeader:
          json ? 'application/json' : 'multipart/form-data',
      HttpHeaders.acceptHeader: 'application/json',
    };
  }

  Future<void> initSession() async {
    log('initSession');
    var response =
        await http.get(uri('initSession'), headers: headers(session: false));
    if (response.statusCode == HttpStatus.ok) {
      Map<String, String> j = json.decode(response.body);
      String? token = j['session_token'];
      if (token == null || token.isEmpty) {
        throw 'Missing session token during session init';
      }
      config.setSessionToken(token);
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }

  Future<Item> getItem(String id, {ItemType type = ItemType.computer}) async {
    log('getItem:$type:$id');
    var response = await http.get(uri("${type.str}/$id"), headers: headers());
    if (response.statusCode == HttpStatus.ok) {
      return Item.readJson(json.decode(response.body));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }
}
