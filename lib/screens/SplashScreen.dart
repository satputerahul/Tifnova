import 'package:flutter/material.dart';

class TIFFINITYSplashScreen extends StatefulWidget {
  const TIFFINITYSplashScreen({super.key});

  @override
  State<TIFFINITYSplashScreen> createState() => _TIFFINITYSplashScreenState();
}

class _TIFFINITYSplashScreenState extends State<TIFFINITYSplashScreen> {
  void initState() {
    super.initState();
    // Navigate to IntroPage after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/intro');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get device width & height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA), // Deep Purple background
      body: Center(
        child: Image.asset(
          'assets/gifs/Tiffinity.gif',
          width: screenWidth * 0.9, // 60% of screen width
          height:
              screenHeight * 0.9, // 25% of screen height (suits most screens)
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
