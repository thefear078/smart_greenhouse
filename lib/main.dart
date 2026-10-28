import 'package:flutter/material.dart';
import 'package:smart_greenhouse/counter/counter_screen.dart';

void main() {
  runApp(const SmartGreenhouseApp());
}

class SmartGreenhouseApp extends StatelessWidget {
  const SmartGreenhouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Greenhouse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const CounterScreen(),
    );
  }
}
