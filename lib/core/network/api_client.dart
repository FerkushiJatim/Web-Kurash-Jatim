import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  final String baseUrl;
  String? _authToken;
  final http.Client _client;

  ApiClient({
    required this.baseUrl,
    String? authToken,
    http.Client? client,
  })  : _authToken = authToken,
        _client = client ?? http.Client();

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Map<String, String> _buildHeaders({Map<String, String>? extra}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    if (extra != null) {
      headers.addAll(extra);
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = response.body;
    }

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    }

    final message = body is Map && body.containsKey('message')
        ? body['message'] as String
        : 'Request failed with status $statusCode';

    throw ApiException(
      statusCode: statusCode,
      message: message,
      data: body,
    );
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters,
      );
      final response = await _client.get(
        uri,
        headers: _buildHeaders(extra: headers),
      );
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client.post(
        uri,
        headers: _buildHeaders(extra: headers),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client.put(
        uri,
        headers: _buildHeaders(extra: headers),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client.delete(
        uri,
        headers: _buildHeaders(extra: headers),
      );
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }
}

