import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';

import 'services/firebase_initializer.dart';
import 'services/auth_service.dart';
import 'services/social_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  await AuthService.instance.restoreSession();
  await SocialService.instance.initialize();
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
      home: const _AppGate(),
    );
  }
}

class _AppGate extends StatefulWidget {
  const _AppGate();

  @override
  State<_AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<_AppGate> {
  final _auth = AuthService.instance;

  @override
  void initState() {
    super.initState();
    _auth.addListener(_refresh);
  }

  @override
  void dispose() {
    _auth.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) => _auth.isLoggedIn
      ? const HomeScreen()
      : AuthScreen(onAuthSuccess: _refresh);
}
