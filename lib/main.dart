import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swifty_companion/services/auth_42_service.dart';
import 'views/login_view.dart';
import 'views/profile_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final authService = AuthService();

  bool initialLoggedIn = false;
  initialLoggedIn = await authService
      .checkForCodeInURLandExchangeCodeForToken();
  print(initialLoggedIn ? '✅ Initial login successful' : '❌ No initial login');
  if (!initialLoggedIn) {
    final storedToken = await authService.getStoredToken();
    if (storedToken != null) {
      initialLoggedIn = true;
    }
    print(
      initialLoggedIn
          ? '✅ Found stored token, user is logged in'
          : '❌ No stored token, user is not logged in',
    );
  }

  runApp(MyApp(isLogged: initialLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isLogged;

  @override
  void initState() {
    super.initState();
    isLogged = widget.isLogged;
  }

  void _setLoggedIn(bool value) => setState(() => isLogged = value);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swifty Companion',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLogged
          ? ProfileView(onLogout: () => _setLoggedIn(false))
          : LoginView(onLogin: () => _setLoggedIn(true)),
    );
  }
}
