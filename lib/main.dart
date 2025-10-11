import 'package:Tiffo/screens/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:Tiffo/screens/SplashScreen.dart';
import 'package:Tiffo/screens/login_screen.dart'; // add this (future login page)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tifnova', //“nova” means new star → fresh beginnings
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      // Set Splash as initial route
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const TIFFINITYSplashScreen(),
        '/intro': (context) => const IntroPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class TIFFINITY extends StatefulWidget {
  const TIFFINITY({super.key, required this.title});

  final String title;

  @override
  State<TIFFINITY> createState() => _TIFFINITYState();
}

class _TIFFINITYState extends State<TIFFINITY> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Center(
        child: Text('Welcome to TIFFINITY!', style: TextStyle(fontSize: 20)),                             
      ),
    );
  }
}
