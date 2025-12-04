import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/loading_page.dart';
import 'screens/home_page.dart';
import 'screens/camera_screen.dart';   // ✔ correct import
import 'screens/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AksharSetu',

      // First screen that opens
      initialRoute: '/login',

      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/loading': (_) => const LoadingPage(),
        '/home': (_) => const HomePage(),
        '/camera': (_) => CameraPage(),     // ✔ FIXED
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
