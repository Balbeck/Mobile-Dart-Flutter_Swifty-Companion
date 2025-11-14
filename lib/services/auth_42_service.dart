import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

class AuthService {
  String? _accessToken;

  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    print('🔍 Stored token: ${_accessToken != null ? "found" : "none"}');
    return _accessToken;
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    _accessToken = token;
    print('💾 Token saved');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    _accessToken = null;
    print('🔓 Logged out');
  }

  Future<bool> exchangeCodeForToken(String code) async {
    try {
      final clientId = dotenv.env['UID_42'] ?? '';
      final clientSecret = dotenv.env['SECRET_42'] ?? '';
      final redirectUrl = dotenv.env['REDIRECT_URI_42'] ?? '';

      final uri = Uri.parse('https://api.intra.42.fr/oauth/token');
      final body = {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'redirect_uri': redirectUrl,
      };

      print('📤 POST $uri body=$body');

      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      print('📥 Token Response ${res.statusCode} ${res.body}');

      if (res.statusCode != 200) {
        print('❌ Token endpoint returned ${res.statusCode}');
        return false;
      }

      final Map<String, dynamic> json = jsonDecode(res.body);
      final token = json['access_token'] as String?;
      if (token == null) {
        print('❌ No access_token in response');
        return false;
      }
      await _saveToken(token);
      return true;
    } catch (e) {
      print('❌ exchangeCodeForToken error: $e');
      return false;
    }
  }

  Future<bool> checkForCodeInURLandExchangeCodeForToken() async {
    try {
      // if (getStoredToken() == null) {
      //   print('ℹ️ No stored token, checking URL for code');
      // } else {
      //   print('ℹ️ Already have a stored token, skipping code exchange');
      //   return true;
      // }
      final code = Uri.base.queryParameters['code'];
      if (code == null || code.isEmpty) {
        print('❌ No code in URL');
        return false;
      }
      print('📨 Code from URL: $code');
      final tokenResponse = await exchangeCodeForToken(code);
      print('✅ Token exchange result: $tokenResponse');
      return tokenResponse;
    } catch (e) {
      print('❌ Error in checkForCodeInURLandExchangeCodeForToken: $e');
      return false;
    }
  }

  Future<bool> loginWith42() async {
    try {
      final clientId = dotenv.env['UID_42'] ?? '';
      final redirectUrl = dotenv.env['REDIRECT_URI_42'] ?? '';
      print(' -> [ DotEnv ] Client ID: $clientId');
      print(' -> [ DotEnv ] Redirect URI: $redirectUrl');

      if (clientId.isEmpty || redirectUrl.isEmpty) {
        print('⚠️ .env missing UID_42 or REDIRECT_URI_42');
        return false;
      }

      final authUrl =
          'https://api.intra.42.fr/oauth/authorize?client_id=$clientId&redirect_uri=${Uri.encodeComponent(redirectUrl)}&response_type=code&scope=public&state=state_rustique';

      print('🔐 Opening auth URL: $authUrl');

      final launched = await launchUrlString(
        authUrl,
        webOnlyWindowName: '_self',
      );

      if (!launched) {
        print('❌ Could not open auth URL');
        return false;
      }

      return true;
    } catch (e) {
      print('❌ loginWith42 error: $e');
      return false;
    }
  }

  String? get accessToken => _accessToken;
}
