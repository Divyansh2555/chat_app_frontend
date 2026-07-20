import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_constants.dart';

class ApiClient {
  static const Duration _timeout = Duration(seconds: 30);

  final Map<String, String> _defaultHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  Map<String, String> _buildHeaders(String? token) {
    final headers = Map<String, String>.from(_defaultHeaders);

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  Future<http.Response> get(
      String endpoint, {
        String? token,
      }) async {
    return await http
        .get(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: _buildHeaders(token),
    )
        .timeout(_timeout);
  }

  Future<http.Response> post(
      String endpoint, {
        Map<String, dynamic>? body,
        String? token,
      }) async {
    return await http
        .post(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: _buildHeaders(token),
      body: jsonEncode(body ?? {}),
    )
        .timeout(_timeout);
  }

  Future<http.Response> put(
      String endpoint, {
        Map<String, dynamic>? body,
        String? token,
      }) async {
    return await http
        .put(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: _buildHeaders(token),
      body: jsonEncode(body ?? {}),
    )
        .timeout(_timeout);
  }

  Future<http.Response> delete(
      String endpoint, {
        String? token,
      }) async {
    return await http
        .delete(
      Uri.parse("${ApiConstants.baseUrl}$endpoint"),
      headers: _buildHeaders(token),
    )
        .timeout(_timeout);
  }
}