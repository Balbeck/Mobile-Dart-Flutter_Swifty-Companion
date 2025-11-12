import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:convert';

class AuthService {
  String? _accessToken;

  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    return _accessToken;
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    _accessToken = token;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    _accessToken = null;
  }

  // Login OAuth2 avec 42 — simple !
  Future<bool> loginWith42() async {
    try {
      final clientId = dotenv.env['UID_42'] ?? '';
      final clientSecret = dotenv.env['SECRET_42'] ?? '';
      final redirectUrl = dotenv.env['REDIRECT_URI_42'] ?? '';

      print('🔐 Starting 42 OAuth2 login...');

      // Ouvre le navigateur et récupère le code
      final result = await FlutterWebAuth.authenticate(
        url:
            'https://api.intra.42.fr/oauth/authorize?client_id=$clientId&redirect_uri=${Uri.encodeComponent(redirectUrl)}&response_type=code&scope=public',
        callbackUrlScheme: 'com.swiftycompanion42',
      );

      // Extrait le code de l'URL de callback
      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) {
        print('❌ No code in callback');
        return false;
      }

      print('✅ Got code: $code');

      // Échange le code pour un token
      final uri = Uri.parse('https://api.intra.42.fr/oauth/token');
      final body = {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'redirect_uri': redirectUrl,
      };

      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (res.statusCode != 200) {
        print('❌ Token exchange failed: ${res.statusCode}');
        return false;
      }

      final Map<String, dynamic> json = jsonDecode(res.body);
      final token = json['access_token'] as String?;
      if (token == null) {
        print('❌ No token in response');
        return false;
      }

      await _saveToken(token);
      print('✅ Login successful! Token saved.');
      return true;
    } catch (e) {
      print('❌ Login error: $e');
      return false;
    }
  }

  String? get accessToken => _accessToken;
}

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AuthService {
//   String? _accessToken;

//   // Verif si le token est deja stocke
//   Future<String?> getStoredToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     _accessToken = prefs.getString('access_token');
//     return _accessToken;
//   }

//   // Stocke le token dans les preferences partagees
//   Future<void> _saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('access_token', token);
//     _accessToken = token;
//   }

//   // Efface le token stocke (logout)
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('access_token');
//     _accessToken = null;
//   }

//   // Login42 via OAuth2
//   Future<bool> loginWith42() async {
//     try {
//       final clientId = dotenv.env['UID_42'] ?? '';
//       final clientSecret = dotenv.env['SECRET_42'] ?? '';
//       final redirectUrl = dotenv.env['REDIRECT_URI_42'] ?? '';
//       print(' -> [ DotEnv ] Client ID: $clientId');
//       print(' -> [ DotEnv ] Client Secret: $clientSecret');
//       print(' -> [ DotEnv ] Redirect URI: $redirectUrl');

//       final uri = Uri.parse('https://api.intra.42.fr/oauth/token');
//       final body = {
//         'grant_type': 'client_credentials',
//         'client_id': clientId,
//         'client_secret': clientSecret,
//       };

//       final res = await http.post(
//         uri,
//         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//         body: body,
//       );

//       if (res.statusCode != 200) {
//         print('❌ Token request failed: ${res.statusCode} ${res.body}');
//         return false;
//       }

//       final Map<String, dynamic> json = jsonDecode(res.body);
//       final token = json['access_token'] as String?;
//       if (token == null || token.isEmpty) {
//         print('❌ No access_token in response: $json');
//         return false;
//       }

//       await _saveToken(token);
//       print('✅ Obtained access token (client credentials).');
//       print("[ response ] $json");
//       return true;
//     } catch (error) {
//       print("Login failed: $error");
//       return false;
//     }
//   }

//   String? get accessToken => _accessToken;
// }
