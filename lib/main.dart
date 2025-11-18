import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:Tifnova/screens/language_provider.dart';
import 'package:Tifnova/screens/theme_notifier.dart';

import 'package:Tifnova/screens/signup_screen.dart';
import 'package:Tifnova/screens/login_screen.dart';
import 'package:Tifnova/screens/SplashScreen.dart';
import 'package:Tifnova/screens/intro_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Tifnova/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Tifnova',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.currentTheme,
      locale: languageProvider.currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const TIFFINITYSplashScreen(),
        '/intro': (_) => const IntroPage(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignUpPage(),
      },
    );
  }
}
