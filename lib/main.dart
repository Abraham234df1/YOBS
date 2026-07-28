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
  // Flujo según Logica_de_uso_YOBS.md Sección 3:
  // Bienvenida → Registro o Login → Selección de Rol → App
  //
  // 0: WelcomeScreen
  // 1: RegisterScreen (general, luego pregunta rol)
  // 2: RoleSelectionScreen (DESPUÉS del registro)
  // 3: RegisterClientScreen (registro extendido si eligió cliente)
  // 4: RegisterWorkerScreen (registro extendido si eligió trabajador)
  // 5: LoginScreen
  // 6: ClientHomeScreen
  // 7: WorkerHomeScreen
  int _flow = 0;
  bool _isWorkerRole = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOBS',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: _buildCurrentScreen(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF6600),
        primary: const Color(0xFFFF6600),
        secondary: const Color(0xFF111827),
        surface: const Color(0xFFF7F7F2),
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F7F2),
      fontFamily: 'Roboto',
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF111827),
          side: const BorderSide(color: Color(0xFFEBEBE6), width: 1.5),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFEBEBE6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFEBEBE6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFFF6600), width: 2),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_flow) {
      // 0: Bienvenida
      case 0:
        return WelcomeScreen(
          onGoToRegister: () => setState(() => _flow = 2), // Registro → selección de rol
          onGoToLogin: () => setState(() => _flow = 5),
        );

      // 2: Selección de rol (DESPUÉS de iniciar registro, según doc sección 3.4)
      case 2:
        return RoleSelectionScreen(
          onBack: () => setState(() => _flow = 0),
          onSelectRole: (isWorker) {
            setState(() {
              _isWorkerRole = isWorker;
              _flow = isWorker ? 4 : 3;
            });
          },
        );

      // 3: Registro extendido de CLIENTE (verificación de identidad)
      case 3:
        return RegisterClientScreen(
          onBack: () => setState(() => _flow = 2),
          onRegisterSuccess: () => setState(() => _flow = 6),
          onGoToLogin: () => setState(() => _flow = 5),
        );

      // 4: Registro extendido de TRABAJADOR (perfil profesional)
      case 4:
        return RegisterWorkerScreen(
          onBack: () => setState(() => _flow = 2),
          onRegisterSuccess: () => setState(() => _flow = 7),
          onGoToLogin: () => setState(() => _flow = 5),
        );

      // 5: Inicio de sesión → detecta rol y navega
      case 5:
        return LoginScreen(
          onBack: () => setState(() => _flow = 0),
          onLoginSuccess: () => setState(() => _flow = _isWorkerRole ? 7 : 6),
          onGoToRegister: () => setState(() => _flow = 2),
          onLoginAsWorker: () => setState(() {
            _isWorkerRole = true;
            _flow = 7;
          }),
          onLoginAsClient: () => setState(() {
            _isWorkerRole = false;
            _flow = 6;
          }),
        );

      // 6: App del CLIENTE
      case 6:
        return ClientHomeScreen(
          onLogout: () => setState(() => _flow = 0),
        );

      // 7: App del TRABAJADOR
      case 7:
        return WorkerHomeScreen(
          onLogout: () => setState(() => _flow = 0),
        );

      default:
        return WelcomeScreen(
          onGoToRegister: () => setState(() => _flow = 2),
          onGoToLogin: () => setState(() => _flow = 5),
        );
    }
  }
}
