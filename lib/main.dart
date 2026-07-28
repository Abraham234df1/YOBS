import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/register_client_screen.dart';
import 'screens/register_worker_screen.dart';
import 'screens/login_screen.dart';
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
  // Navigation Flow State:
  // 0: WelcomeScreen
  // 1: RoleSelectionScreen (SELECCIÓN DE ROL ANTES DEL REGISTRO)
  // 2: RegisterClientScreen (REGISTRO SEGURO DE CLIENTE CON VERIFICACIÓN DE IDENTIDAD)
  // 3: RegisterWorkerScreen (REGISTRO DE TRABAJADOR / PERFIL PROFESIONAL)
  // 4: LoginScreen
  // 5: ClientHomeScreen
  // 6: WorkerHomeScreen
  int _currentFlow = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOBS - Catálogo de Servicios Laborales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6600), // Figma Bright Orange
          primary: const Color(0xFFFF6600),
          secondary: const Color(0xFF111827),
          surface: const Color(0xFFF7F7F2),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: Color(0xFF111827)),
          titleTextStyle: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFEBEBE6)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6600),
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF111827),
            side: const BorderSide(color: Color(0xFFEBEBE6), width: 1.5),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentFlow) {
      case 0:
        return WelcomeScreen(
          // Pide selección de rol ANTES del registro
          onGoToRegister: () => setState(() => _currentFlow = 1),
          onGoToLogin: () => setState(() => _currentFlow = 4),
          onGoToRoleSelection: () => setState(() => _currentFlow = 1),
        );
      case 1:
        // PANTALLA DE SELECCIÓN DE ROL (ANTES DE REGISTRO)
        return RoleSelectionScreen(
          onBack: () => setState(() => _currentFlow = 0),
          onSelectRole: (isWorker) {
            setState(() {
              _currentFlow = isWorker ? 3 : 2; // Trabajador -> RegisterWorker, Cliente -> RegisterClient
            });
          },
        );
      case 2:
        // REGISTRO DE CLIENTE CON ALTA SEGURIDAD Y VERIFICACIÓN
        return RegisterClientScreen(
          onBack: () => setState(() => _currentFlow = 1),
          onRegisterSuccess: () => setState(() => _currentFlow = 5),
          onGoToLogin: () => setState(() => _currentFlow = 4),
        );
      case 3:
        // REGISTRO DE TRABAJADOR / PERFIL PROFESIONAL
        return RegisterWorkerScreen(
          onBack: () => setState(() => _currentFlow = 1),
          onRegisterSuccess: () => setState(() => _currentFlow = 6),
          onGoToLogin: () => setState(() => _currentFlow = 4),
        );
      case 4:
        // INICIAR SESIÓN
        return LoginScreen(
          onBack: () => setState(() => _currentFlow = 0),
          onLoginSuccess: () => setState(() => _currentFlow = 5),
          onGoToRegister: () => setState(() => _currentFlow = 1),
        );
      case 5:
        // CLIENTE APP
        return ClientHomeScreen(
          onLogout: () => setState(() => _currentFlow = 0),
        );
      case 6:
        // TRABAJADOR APP
        return WorkerHomeScreen(
          onLogout: () => setState(() => _currentFlow = 0),
        );
      default:
        return WelcomeScreen(
          onGoToRegister: () => setState(() => _currentFlow = 1),
          onGoToLogin: () => setState(() => _currentFlow = 4),
          onGoToRoleSelection: () => setState(() => _currentFlow = 1),
        );
    }
  }
}
