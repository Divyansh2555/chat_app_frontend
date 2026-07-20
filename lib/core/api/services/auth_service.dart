import 'package:http/http.dart' as http;

import '../api_clients.dart';
import '../api_endpoints.dart';

class AuthService {
  final ApiClient _client = ApiClient();

  Future<http.Response> signup(
      Map<String, dynamic> body,
      ) async {
    return await _client.post(
      ApiEndpoints.register,
      body: body,
    );
  }

  Future<http.Response> login(
      Map<String, dynamic> body,
      ) async {
    return await _client.post(
      ApiEndpoints.login,
      body: body,
    );
  }
}