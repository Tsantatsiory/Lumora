import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LumoraApp());
}

class LumoraApp extends StatelessWidget {
  const LumoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumora',
      debugShowCheckedModeBanner: false,
      theme: buildLumoraTheme(),
      home: const HomeScreen(),
    );
  }
}
