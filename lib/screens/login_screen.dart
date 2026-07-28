import 'package:flutter/material.dart';
import '../widgets/yobs_logo_widget.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onLoginSuccess;
  final VoidCallback onGoToRegister;

  const LoginScreen({
    super.key,
    required this.onBack,
    required this.onLoginSuccess,
    required this.onGoToRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'tucorreo@ejemplo.com');
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // < Volver button
              TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF6B7280)),
                label: const Text('Volver', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              ),

              const SizedBox(height: 20),

              // Centered YÖBS Logo
              const Center(child: YobsLogoWidget(fontSize: 42)),

              const SizedBox(height: 32),

              // Title
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Bienvenido de vuelta.',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Email Input
              const Text(
                'Correo electrónico',
                style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'tucorreo@ejemplo.com',
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
                ),
              ),

              const SizedBox(height: 20),

              // Password Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Contraseña',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827)),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Se ha enviado un enlace a tu correo.')),
                      );
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: Color(0xFFFF6600),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Tu contraseña',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: const Color(0xFF6B7280),
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: Color(0xFFEBEBE6)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: Color(0xFFEBEBE6)),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Continuar button
              ElevatedButton(
                onPressed: widget.onLoginSuccess,
                child: const Text('Continuar'),
              ),

              const SizedBox(height: 24),

              // Footer
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta? ', style: TextStyle(color: Color(0xFF6B7280))),
                    GestureDetector(
                      onTap: widget.onGoToRegister,
                      child: const Text(
                        'Regístrate gratis',
                        style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
