import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_42_service.dart';
import '../models/user_model.dart';

class UserService {
  final AuthService authService = AuthService();

  Future<UserModel?> fetchCurrentUser() async {
    try {
      final token =
          authService.accessToken ?? await authService.getStoredToken();
      if (token == null || token.isEmpty) {
        print('⚠️ No access token available for GET /v2/me');
        return null;
      }
      print("🔑 Using access token: $token");
      final uri = Uri.parse('https://api.intra.42.fr/v2/me');
      final res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode != 200) {
        print('❌ GET /v2/me failed: ${res.statusCode} ${res.body}');
        return null;
      }

      final Map<String, dynamic> json = jsonDecode(res.body);
      // print('✅ Fetched user data: $json');
      return UserModel.fromJson(json);
    } catch (e) {
      print('❌ fetchCurrentUser error: $e');
      return null;
    }
  }
}
