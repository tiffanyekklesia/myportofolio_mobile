import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int? statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      baseUrl = baseUrl ?? apiBaseUrl;

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) {
    final normalizedBaseUrl = baseUrl.replaceFirst(RegExp(r'/+$'), '');
    return Uri.parse('$normalizedBaseUrl$path');
  }

  Future<http.Response> _send(
    Future<http.Response> Function() request,
  ) async {
    try {
      return await request();
    } on http.ClientException catch (error) {
      throw ApiException(null, error.message);
    }
  }

  Future<List<Project>> getProjects() async {
    final response = await _send(
      () => _client.get(
        _uri('/api/v1/projects/'),
        headers: const {'Accept': 'application/json'},
      ),
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Project> createProject(Project project, {required String token}) async {
    final response = await _send(
      () => _client.post(
        _uri('/api/v1/projects/'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(project.toJson()),
      ),
    );
    _ensureSuccess(response);
    return Project.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _send(
      () => _client.post(
        _uri('/api/v1/auth/token/'),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': username, 'password': password}),
      ),
    );
    _ensureSuccess(response);
    return (jsonDecode(response.body) as Map<String, dynamic>)['token']
        as String;
  }

  Future<void> logout({required String token}) async {
    final response = await _send(
      () => _client.post(
        _uri('/api/v1/auth/logout/'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );
    _ensureSuccess(response);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    throw ApiException(response.statusCode, response.body);
  }
}
