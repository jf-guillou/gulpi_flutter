import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:gulpi/models/item_model.dart';
import 'package:gulpi/models/paginable_model.dart';
import 'package:gulpi/models/searchcriteria_model.dart';
import 'package:gulpi/models/searchitem_model.dart';
import 'package:gulpi/models/searchoptions_model.dart';
import 'package:gulpi/utilities/exceptions.dart';
import 'package:gulpi/utilities/item_types.dart';
import 'package:http/http.dart' as http;
import 'package:gulpi/models/api_config_model.dart';

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();
  static const prefix = 'apirest.php';
  late APIConfig config;

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

  Future<bool> checkUri() async {
    log('checkUri');
    http.Response response;
    try {
      response = await http.get(uri("initSession"),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    } catch (_) {
      return false;
    }
    log("statusCode:${response.statusCode}");
    if (response.statusCode == HttpStatus.unauthorized) {
      throw AuthExpiredException();
    }
    if (response.statusCode == HttpStatus.ok) {
      try {
        var j = json.decode(response.body);
        return j != null && j['session_token'];
      } catch (_) {
        return false;
      }
    }
    if (response.statusCode == HttpStatus.badRequest) {
      try {
        _errorMessageToException(json.decode(response.body)[0]);
      } on AppTokenException {
        return true;
      } on ApiMissingAuth {
        return true;
      } catch (_) {
        rethrow;
      }
    } else {
      throw UnexpectedStatusCodeException(response.statusCode);
    }
    return false;
  }

  Future<void> initSession() async {
    log('initSession');
    var response =
        await http.get(uri('initSession'), headers: headers(session: false));
    if (response.statusCode == HttpStatus.ok) {
      Map<String, String> j = json.decode(response.body);
      String? token = j['session_token'];
      if (token == null || token.isEmpty) {
        throw AuthFailedException();
      }
      config.setSessionToken(token);
    } else if (response.statusCode == HttpStatus.badRequest) {
      _errorMessageToException(json.decode(response.body)[0]);
    } else {
      throw UnexpectedStatusCodeException(response.statusCode);
    }
  }

  Future<Paginable<SearchItem>> searchItems(List<SearchCriteria> criteria,
      {ItemType type = ItemType.computer}) async {
    log('searchItems:$type:$criteria');
    var query = {"criteria": criteria};
    var response =
        await http.get(uri("search/${type.str}/", query), headers: headers());
    if (response.statusCode == HttpStatus.unauthorized) {
      throw AuthExpiredException();
    }
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.partialContent) {
      return Paginable<SearchItem>.readJson(
          json.decode(response.body), (item) => SearchItem.readJson(item));
    } else {
      throw UnexpectedStatusCodeException(response.statusCode);
    }
  }

  Future<Item> getItem(String id, {ItemType type = ItemType.computer}) async {
    log('getItem:$type:$id');
    var response = await http.get(uri("${type.str}/$id"), headers: headers());
    if (response.statusCode == HttpStatus.unauthorized) {
      throw AuthExpiredException();
    }
    if (response.statusCode == HttpStatus.ok) {
      return Item.readJson(json.decode(response.body));
    } else {
      throw UnexpectedStatusCodeException(response.statusCode);
    }
  }

  Future<SearchOptions> searchOptions(
      {ItemType type = ItemType.computer}) async {
    log('searchOptions:$type');
    var response = await http.get(uri("${type.str}"), headers: headers());
    if (response.statusCode == HttpStatus.unauthorized) {
      throw AuthExpiredException();
    }
    if (response.statusCode == HttpStatus.ok) {
      return SearchOptions.readJson(json.decode(response.body));
    } else {
      throw UnexpectedStatusCodeException(response.statusCode);
    }
  }

  void _errorMessageToException(String str) {
    switch (str) {
      case "ERROR_LOGIN_PARAMETERS_MISSING":
        throw ApiMissingAuth();
      case "ERROR_RESOURCE_NOT_FOUND_NOR_COMMONDBTM":
        throw ApiWrongResourceException();
      case "ERROR_APP_TOKEN_PARAMETERS_MISSING":
      case "ERROR_WRONG_APP_TOKEN_PARAMETER":
        throw AppTokenException();
      default:
        throw UnkownAPIErrorException(str);
    }
  }
}
