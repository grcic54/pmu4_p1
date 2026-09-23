import 'package:flutter/material.dart';

void main() {
  runApp(const QuakesApp());
}

class QuakesApp extends StatelessWidget {
  const QuakesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  title: 'Potresi',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)
  ),
  home: const HomeScreen(),
    );
  }
}
