import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pwa_install/pwa_install.dart';
import 'features/home/view/splash_screen.dart';

// Main App
/// Main entry point for the app.
///
/// Initializes the Flutter binding, sets up the PWA install callback,
/// and runs the app with the root widget wrapped in a [ProviderScope].
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PWAInstall().setup(
    installCallback: () {
      debugPrint('APP INSTALLED!');
    },
  );
  runApp(const ProviderScope(child: PrisonersDilemmaApp()));
}

// Main App
class PrisonersDilemmaApp extends StatelessWidget {
  const PrisonersDilemmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Classic Prisoner\'s Dilemma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Helvetica',
        fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
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
