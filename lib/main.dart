import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ही फाइल Firebase console मधून auto तयार होते
import 'package:Tifnova/screens/otp_screen.dart';
import 'package:Tifnova/screens/signup_screen.dart';
import 'package:Tifnova/screens/login_screen.dart';
import 'package:Tifnova/screens/SplashScreen.dart';
import 'package:Tifnova/screens/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tifnova',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF870474)),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const TIFFINITYSplashScreen(),
        '/intro': (context) => const IntroPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
      },
    );
  }
}
