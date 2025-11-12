import 'package:flutter/material.dart';
import '../services/auth_42_service.dart';

class LoginView extends StatelessWidget {
  final VoidCallback onLogin;
  const LoginView({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Swifty Companion')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final auth = AuthService();
            final success = await auth.loginWith42();
            if (success) {
              onLogin();
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('❌ Login failed')));
            }
          },
          child: const Text('Connection with 42'),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../services/auth_42_service.dart';

// class LoginView extends StatelessWidget {
//   final VoidCallback onLogin;
//   const LoginView({super.key, required this.onLogin});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Swifty Companion')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final auth = AuthService();
//             await auth.redirectToAuth42();
//             // final success = await auth.loginWith42();
//             // if (success) {
//             //   onLogin();
//             // } else {
//             //   ScaffoldMessenger.of(
//             //     context,
//             //   ).showSnackBar(const SnackBar(content: Text('Login failed.')));
//             // }
//           },
//           child: const Text('Connection with 42'),
//         ),
//       ),
//     );
//   }
// }
