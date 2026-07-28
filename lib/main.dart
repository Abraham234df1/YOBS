import 'package:flutter/material.dart';

import 'screens/role_selection_screen.dart';
import 'screens/client_home_screen.dart';
import 'screens/worker_home_screen.dart';
import 'services/mongodb_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDbService.connect();
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
          seedColor: const Color(0xFFFB7A01), // Figma Primary Amber Orange
          primary: const Color(0xFFFB7A01),
          secondary: const Color(0xFF111A20),
          surface: const Color(0xFFF6F6F0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F6F0), // Figma Soft Cream Background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111A20), // Figma Dark Charcoal AppBar
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
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
