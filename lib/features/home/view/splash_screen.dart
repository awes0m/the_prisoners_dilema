import 'dart:async';

import 'package:flutter/material.dart';

import '../../../common/circular_app_icon.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the HomeScreen after a delay
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You can customize the background color
      backgroundColor: Colors.blueGrey.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can replace this Icon with an Image widget for your logo
            const CircularAppIcon(size: 100),
            const SizedBox(height: 24),
            Text(
              'The Classic',
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Prisoner's Dilemma",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = Colors.white70,
                // color: Colors.white,
                fontFamily:
                    'Georgia', // A more classic-looking font if available
              ),
            ),
            const SizedBox(height: 16),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white30),
            ),
          ],
        ),
      ),
    );
  }
}
