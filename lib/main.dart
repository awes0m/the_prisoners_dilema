import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pwa_install/pwa_install.dart';
import 'view/splash_screen.dart';

// Main App
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PWAInstall().setup(
    installCallback: () {
      debugPrint('APP INSTALLED!');
    },
  );
  runApp(const ProviderScope(child: PrisonersDilemmaApp()));
}

class PrisonersDilemmaApp extends StatelessWidget {
  const PrisonersDilemmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Classic Prisoner\'s Dilemma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Performance: Reduce animation durations globally
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashScreen(), // Start with the splash screen
    );
  }
}

// Splash Screen Widget
