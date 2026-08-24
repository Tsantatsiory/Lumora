import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home_screen.dart';

import 'services/firebase_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
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
