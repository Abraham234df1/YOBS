import 'package:flutter/material.dart';
import '../widgets/yobs_logo_widget.dart';
import 'support_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGoToRegister;
  final VoidCallback onGoToLogin;
  final VoidCallback onGoToRoleSelection;

  const WelcomeScreen({
    super.key,
    required this.onGoToRegister,
    required this.onGoToLogin,
    required this.onGoToRoleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F2), // Figma Cream
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            children: [
              const Spacer(),

              // YÖBS Logo from Figma Image 3
              const YobsLogoWidget(fontSize: 48),
              const SizedBox(height: 28),

              const Text(
                'Conectamos a profesionales de confianza\ncon personas que necesitan ayuda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Color(0xFF6B7280), // Figma Gray
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              // Button 1: Crear cuenta
              ElevatedButton.icon(
                onPressed: onGoToRegister,
                icon: const Icon(Icons.person_add_outlined, size: 20),
                label: const Text('Crear cuenta'),
              ),

              const SizedBox(height: 14),

              // Button 2: Iniciar sesión
              OutlinedButton.icon(
                onPressed: onGoToLogin,
                icon: const Icon(Icons.login_rounded, size: 20),
                label: const Text('Iniciar sesión'),
              ),

              const SizedBox(height: 20),

              // Direct quick enter button
              TextButton(
                onPressed: onGoToRoleSelection,
                child: const Text(
                  'Ingresar directamente como Invitado ➔',
                  style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 12),

              // Support Footer Link
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SupportScreen()),
                  );
                },
                child: Column(
                  children: [
                    const Text(
                      '¿Necesitas ayuda?',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Visita nuestro centro de soporte',
                      style: TextStyle(
                        color: const Color(0xFFFF6600),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: TextDecoration.combine([]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
