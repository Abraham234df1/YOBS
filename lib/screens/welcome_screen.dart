import 'package:flutter/material.dart';
import '../widgets/yobs_logo_widget.dart';
import 'support_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGoToRegister;
  final VoidCallback onGoToLogin;

  const WelcomeScreen({
    super.key,
    required this.onGoToRegister,
    required this.onGoToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // YÖBS Logo
              const YobsLogoWidget(fontSize: 52),
              const SizedBox(height: 20),

              // Tagline
              const Text(
                'Conectamos a profesionales de confianza\ncon personas que necesitan ayuda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.55,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(flex: 3),

              // Crear cuenta button (→ va a selección de rol PRIMERO)
              ElevatedButton.icon(
                onPressed: onGoToRegister,
                icon: const Icon(Icons.person_add_outlined, size: 20),
                label: const Text('Crear cuenta'),
              ),

              const SizedBox(height: 14),

              // Iniciar sesión button
              OutlinedButton.icon(
                onPressed: onGoToLogin,
                icon: const Icon(Icons.login_rounded, size: 20),
                label: const Text('Iniciar sesión'),
              ),

              const Spacer(),

              // Soporte
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SupportScreen()),
                  );
                },
                child: const Column(
                  children: [
                    Text(
                      '¿Necesitas ayuda?',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Centro de soporte →',
                      style: TextStyle(
                        color: Color(0xFFFF6600),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
