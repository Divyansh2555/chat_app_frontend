import 'package:http/http.dart' as http;

import '../api_clients.dart';
import '../api_endpoints.dart';

class ChatService {
  final ApiClient _client = ApiClient();

  Future<http.Response> createChat(
      Map<String, dynamic> body, {
        String? token,
      }) {
    return _client.post(
      ApiEndpoints.createChat,
      body: body,
      token: token,
    );
  }

  Future<http.Response> getChat(
      String id, {
        String? token,
      }) {
    return _client.get(
      ApiEndpoints.getChat(id),
      token: token,
    );
  }

  Future<http.Response> deleteChat(
      String id, {
        String? token,
      }) {
    return _client.delete(
      ApiEndpoints.deleteChat(id),
      token: token,
    );
  }
}