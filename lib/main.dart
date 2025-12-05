import 'package:flutter/material.dart';

import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/loading_page.dart';
import 'screens/home_page.dart';
import 'screens/camera_screen.dart';
import 'screens/profile_page.dart';
import 'screens/transliteration_output_page.dart';
import 'screens/tts_page.dart';

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

      initialRoute: '/login',

      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/loading': (_) => const LoadingPage(),
        '/home': (_) => const HomePage(),
        '/camera': (_) => const CameraPage(),
        '/profile': (_) => const ProfilePage(),

        '/output': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;

          return TransliterationOutputPage(
            image: args["image"],
            language: args["language"],
            script: args["script"],
            ttsCode: args["ttsCode"],
          );
        },

        '/tts': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;

          return TtsPage(
            imagePath: args["imagePath"],
            language: args["language"],
            ttsCode: args["ttsCode"], text: '', script: '',
          );
        },
      },
    );
  }
}
