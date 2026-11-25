import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._apiClient);

  final ApiClient _apiClient;
  String? _token;

  String? get token => _token;

  bool get isLoggedIn => _token != null;

  Future<void> login(String username, String password) async {
    _token = await _apiClient.obtainToken(username, password);
    notifyListeners();
  }

  Future<void> logout() async {
    final currentToken = _token;
    if (currentToken == null) return;

    ApiException? logoutError;
    try {
      await _apiClient.logout(token: currentToken);
    } on ApiException catch (error) {
      logoutError = error;
    } finally {
      _token = null;
      notifyListeners();
    }

    final error = logoutError;
    if (error != null) throw error;
  }
}
