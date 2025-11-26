import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'auth_42_service.dart';

class SearchService {
  final AuthService authService = AuthService();

  Future<UserModel?> fetchUserByLogin(String login) async {
    try {
      final token =
          authService.accessToken ?? await authService.getStoredToken();
      if (token == null || token.isEmpty) {
        print('⚠️ No access token available in SearchService');
        return null;
      }
      // print("🔑 UserSearch access token: $token");
      final uri = Uri.parse('https://api.intra.42.fr/v2/users/$login');
      final res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode != 200) {
        print('❌ GET /v2/users/$login failed: ${res.statusCode} ${res.body}');
        return null;
      }

      final Map<String, dynamic> json = jsonDecode(res.body);
      // print('✅ Fetched user data for $login: $json');
      return UserModel.fromJson(json);
    } catch (e) {
      print('❌ fetchUserByLogin error: $e');
      return null;
    }
  }
}
