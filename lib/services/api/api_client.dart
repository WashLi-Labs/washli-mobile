import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'token_manager.dart';
import 'api_exception.dart';

class ApiClient {
  Future<Map<String, String>> _getHeaders({String accept = 'application/json'}) async {
    final token = await TokenManager.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'accept': accept,
    };
  }

  Future<dynamic> get(String url, {String accept = 'application/json'}) async {
    try {
      var headers = await _getHeaders(accept: accept);
      print('==============================');
      print('=> OUTGOING REQUEST [GET] $url');
      print('==============================');
      var response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 401) {
        final newToken = await TokenManager.refreshToken();
        headers['Authorization'] = 'Bearer $newToken';
        response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10));
      }

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection or server unreachable');
    } on TimeoutException {
      throw const NetworkException('Connection timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(e.toString());
    }
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? body, String accept = 'application/json'}) async {
    try {
      var headers = await _getHeaders(accept: accept);
      final bodyStr = body != null ? jsonEncode(body) : null;
      print('==============================');
      print('=> OUTGOING REQUEST [POST] $url');
      print('=> PAYLOAD BODY: $bodyStr');
      print('==============================');
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: bodyStr,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        final newToken = await TokenManager.refreshToken();
        headers['Authorization'] = 'Bearer $newToken';
        response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: bodyStr,
        ).timeout(const Duration(seconds: 10));
      }

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection or server unreachable');
    } on TimeoutException {
      throw const NetworkException('Connection timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(e.toString());
    }
  }

  Future<dynamic> delete(String url, {String accept = '*/*'}) async {
    try {
      var headers = await _getHeaders(accept: accept);
      print('==============================');
      print('=> OUTGOING REQUEST [DELETE] $url');
      print('==============================');
      var response = await http.delete(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        final newToken = await TokenManager.refreshToken();
        headers['Authorization'] = 'Bearer $newToken';
        response = await http.delete(
          Uri.parse(url),
          headers: headers,
        ).timeout(const Duration(seconds: 10));
      }

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection or server unreachable');
    } on TimeoutException {
      throw const NetworkException('Connection timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw NetworkException(e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    print('==============================');
    print('API RESPONSE [${response.request?.method}] ${response.request?.url}');
    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE BODY: ${response.body}');
    print('==============================');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      String message = 'An error occurred';
      try {
        final body = jsonDecode(response.body);
        if (body is Map) {
          message = body['message'] ?? body['error'] ?? message;
        }
      } catch (_) {
        if (response.body.isNotEmpty) {
          message = response.body;
        }
      }
      throw ApiException.fromStatusCode(response.statusCode, message);
    }
  }
}
