import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:gulpi/models/item_model.dart';
import 'package:gulpi/models/paginable_model.dart';
import 'package:gulpi/models/searchcriterion_model.dart';
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

  Uri uri(List<String> segments, [Map<String, dynamic>? queryParameters]) {
    assert(config.hasUri());

    List<String> pathSegments = config.uri!.pathSegments.toList()
      ..add(prefix)
      ..addAll(segments);
    log(pathSegments.toString());
    return config.uri!
        .replace(pathSegments: pathSegments, queryParameters: queryParameters);
  }

  Map<String, String> headers({bool session = true, bool json = true}) {
    Map<String, String> h = {
      HttpHeaders.contentTypeHeader:
          json ? 'application/json' : 'multipart/form-data',
      HttpHeaders.acceptHeader: 'application/json',
    };
    if (session) {
      h['Session-Token'] = config.authSessionHeader()!;
    } else {
      h[HttpHeaders.authorizationHeader] = config.authHeader();
    }
    if (config.appTokenHeader() != null) {
      h['App-Token'] = config.appTokenHeader()!;
    }
    log(h.toString());

    return h;
  }

  Future<bool> checkUri() async {
    log('checkUri');
    http.Response response;
    try {
      response = await http.get(uri(["initSession"]),
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
        throw _errorMessageToException(json.decode(response.body)[0]);
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
  }

  Future<String?> initSession() async {
    log('initSession');
    var response =
        await http.get(uri(['initSession']), headers: headers(session: false));
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> j = json.decode(response.body);
      String? token = j['session_token'];
      if (token == null || token.isEmpty) {
        throw AuthFailedException();
      }
      config.setSessionToken(token);
      return token;
    } else if (response.statusCode == HttpStatus.badRequest) {
      throw _errorMessageToException(json.decode(response.body)[0]);
    } else {
      throw UnexpectedStatusCodeException(response.statusCode);
    }
  }

  Future<Paginable<SearchItem>> searchItems(SearchCriterion criterion,
      {ItemType type = ItemType.computer}) async {
    log('searchItems:$type:$criterion');
    var query = criterion.toUrlQuery();
    // query['uid_cols'] = "1";
    query['forcedisplay'] = "2";
    // query.addAll(type.searchCols
    //     .asMap()
    //     .map((i, e) => MapEntry("forcedisplay[$i]", "$e")));
    var response =
        await http.get(uri(['search', type.str], query), headers: headers());
    if (response.statusCode == HttpStatus.unauthorized) {
      throw AuthExpiredException();
    }
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.partialContent) {
      if (response.body.isEmpty) {
        return Paginable<SearchItem>();
      }
      return Paginable<SearchItem>.fromJson(
          json.decode(response.body), (item) => SearchItem.fromJson(item));
    } else if (response.statusCode == HttpStatus.badRequest) {
      throw _errorMessageToException(json.decode(response.body)[0]);
    } else {
      throw UnexpectedStatusCodeException(response.statusCode);
    }
  }

  Future<Item> getItem(String id, {ItemType type = ItemType.computer}) async {
    log('getItem:$type:$id');
    var response = await http.get(uri([type.str, id]), headers: headers());
    if (response.statusCode == HttpStatus.unauthorized) {
      throw AuthExpiredException();
    }
    if (response.statusCode == HttpStatus.ok) {
      return Item.fromJson(json.decode(response.body));
    } else if (response.statusCode == HttpStatus.badRequest) {
      throw _errorMessageToException(json.decode(response.body)[0]);
    } else {
      throw UnexpectedStatusCodeException(response.statusCode);
    }
  }

  Future<SearchOptions> searchOptions(
      {ItemType type = ItemType.computer}) async {
    log('searchOptions:$type');
    var response = await http.get(uri(['listSearchOptions', type.str]),
        headers: headers());
    if (response.statusCode == HttpStatus.unauthorized) {
      throw AuthExpiredException();
    }
    if (response.statusCode == HttpStatus.ok) {
      return SearchOptions.fromJson(json.decode(response.body));
    } else if (response.statusCode == HttpStatus.badRequest) {
      throw _errorMessageToException(json.decode(response.body)[0]);
    } else {
      throw UnexpectedStatusCodeException(response.statusCode);
    }
  }

  Exception _errorMessageToException(String str) {
    switch (str) {
      case "ERROR_LOGIN_PARAMETERS_MISSING":
        return ApiMissingAuth();
      case "ERROR_RESOURCE_NOT_FOUND_NOR_COMMONDBTM":
        return ApiWrongResourceException();
      case "ERROR_APP_TOKEN_PARAMETERS_MISSING":
      case "ERROR_WRONG_APP_TOKEN_PARAMETER":
        return AppTokenException();
      default:
        return UnkownAPIErrorException(str);
    }
  }
}
