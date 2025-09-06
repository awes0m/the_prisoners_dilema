import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'view/home_screen.dart';

// Main App
void main() {
  runApp(ProviderScope(child: PrisonersDilemmaApp()));
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
      ),
      home: HomeScreen(),
    );
  }
}
