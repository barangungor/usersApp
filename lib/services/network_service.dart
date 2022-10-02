import 'dart:convert';
import 'package:http/http.dart';

class NetworkService {
  static NetworkService? _instance;
  static Client? _client;

  static NetworkService get instance {
    _client ??= Client();
    _instance ??= NetworkService._init();
    return _instance!;
  }

  NetworkService._init();

  Future postMethod(url, body) async {
    final uri = Uri.parse(url);
    var response = await _client!
        .post(
      uri,
      headers: {'Content-Type': "application/json"},
      body: json.encode(body),
    )
        .then((value) async {
      var result;

      try {
        result = json.decode(utf8.decode(value.bodyBytes));
      } catch (e) {
        return 'Bir hata oluştu';
      }
      return result;
    }).onError((error, stackTrace) => Future.error(error.toString()));
    return response is Map ? true : false;
  }

  Future putMethod(url, body) async {
    print(url);
    print(body);
    final uri = Uri.parse(url);
    var response = await _client!
        .put(
      uri,
      headers: {'Content-Type': "application/json"},
      body: json.encode(body),
    )
        .then((value) async {
      var result;
      try {
        result = json.decode(utf8.decode(value.bodyBytes));
      } catch (e) {
        return 'Bir hata oluştu';
      }
      return result;
    }).onError((error, stackTrace) => Future.error(error.toString()));
    return response;
  }

  Future deleteMethod(url) async {
    final uri = Uri.parse(url);
    var response = await _client!.delete(uri).then((value) async {
      var result;
      try {
        result = json.decode(utf8.decode(value.bodyBytes));
      } catch (e) {
        return 'Bir hata oluştu';
      }
      return result;
    }).onError((error, stackTrace) => Future.error(error.toString()));
    return response;
  }

  Future getMethod(url, {headers}) async {
    print(url);
    final uri = Uri.parse(url);
    var returnData = {"data": [], "error": ''};
    await _client!.get(uri, headers: headers).then((value) async {
      try {
        returnData['data'] = json.decode(value.body);
      } catch (e) {
        returnData['error'] = 'Bir hata oluştu';
        return false;
      }
      return returnData;
    }).onError((error, stackTrace) async {
      returnData['error'] = error.toString();
      return Future.error(returnData);
    });
    return returnData;
  }
}
