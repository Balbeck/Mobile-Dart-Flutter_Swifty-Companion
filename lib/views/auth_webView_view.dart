// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../services/auth_42_service.dart';

// class AuthWebView extends StatefulWidget {
//   final VoidCallback onLoginSuccess;
//   const AuthWebView({super.key, required this.onLoginSuccess});

//   @override
//   State<AuthWebView> createState() => _AuthWebViewState();
// }

// class _AuthWebViewState extends State<AuthWebView> {
//   late WebViewController _webViewController;
//   final AuthService _auth = AuthService();

//   @override
//   void initState() {
//     super.initState();
//     final clientId = '${dotenv.env['UID_42']}';
//     final redirectUri = '${dotenv.env['REDIRECT_URI_42']}';

//     final authUrl =
//         'https://api.intra.42.fr/oauth/authorize?client_id=$clientId&redirect_uri=${Uri.encodeComponent(redirectUri)}&response_type=code&scope=public';

//     _webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             // Vérifie si l'URL contient le code (redirect 42)
//             if (url.contains('code=')) {
//               final uri = Uri.parse(url);
//               final code = uri.queryParameters['code'];
//               if (code != null) {
//                 _handleCallback(code);
//               }
//             }
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(authUrl));
//   }

//   void _handleCallback(String code) async {
//     final success = await _auth.exchangeCodeForToken(code, '');
//     if (success && mounted) {
//       widget.onLoginSuccess();
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('42 Login')),
//       body: WebViewWidget(controller: _webViewController),
//     );
//   }
// }
