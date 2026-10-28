import 'package:flutter/material.dart';

void main() {
  runApp(const SmartGreenhouseApp());
}

class SmartGreenhouseApp extends StatelessWidget {
  const SmartGreenhouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Greenhouse',
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const Scaffold(body: Center(child: Text('Smart Greenhouse'))),
    );
  }
}
