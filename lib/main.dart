import 'package:flutter/material.dart';

import 'screens/role_selection_screen.dart';
import 'screens/client_home_screen.dart';
import 'screens/worker_home_screen.dart';

void main() {
  runApp(const YobsApp());
}

class YobsApp extends StatefulWidget {
  const YobsApp({super.key});

  @override
  State<YobsApp> createState() => _YobsAppState();
}

class _YobsAppState extends State<YobsApp> {
  // null = Role selection screen, false = Client mode, true = Worker mode
  bool? _isWorkerMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOBS - Catálogo de Servicios Laborales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: Color(0xFF0F172A)),
          titleTextStyle: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
      home: _buildHomeScreen(),
    );
  }

  Widget _buildHomeScreen() {
    if (_isWorkerMode == null) {
      return RoleSelectionScreen(
        onSelectRole: (isWorker) {
          setState(() {
            _isWorkerMode = isWorker;
          });
        },
      );
    } else if (_isWorkerMode == true) {
      return WorkerHomeScreen(
        onSwitchRole: () {
          setState(() {
            _isWorkerMode = null;
          });
        },
      );
    } else {
      return ClientHomeScreen(
        onSwitchRole: () {
          setState(() {
            _isWorkerMode = null;
          });
        },
      );
    }
  }
}
