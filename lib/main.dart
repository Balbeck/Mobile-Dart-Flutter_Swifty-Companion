import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/login_view.dart';
import 'views/profile_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // final authService = AuthService();
  // final isLoggedIn = await authService.isLoggedIn();
  // runApp(MyApp(isLoggedIn: isLoggedIn));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogged = false;

  void _setLoggedIn(bool value) {
    setState(() {
      isLogged = value;
    });
  }

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
