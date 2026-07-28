import 'package:flutter/material.dart';
import '../widgets/yobs_logo_widget.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onRegisterSuccess;
  final VoidCallback onGoToLogin;

  const RegisterScreen({
    super.key,
    required this.onBack,
    required this.onRegisterSuccess,
    required this.onGoToLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirmPass = true;

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

              const SizedBox(height: 16),

              // Centered YÖBS Logo
              const Center(child: YobsLogoWidget(fontSize: 42)),

              const SizedBox(height: 24),

              // Subheader
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.front_hand_outlined, size: 18, color: Color(0xFFFF6600)),
                        const SizedBox(width: 6),
                        Text(
                          'Registro de cliente',
                          style: TextStyle(
                            color: const Color(0xFFFF6600),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Crea tu cuenta',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Completa los datos para comenzar.',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Nombre completo
              const Text('Nombre completo', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInput(_nameController, 'Ej. Carlos Mendoza'),

              const SizedBox(height: 16),

              // Correo electrónico
              const Text('Correo electrónico', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInput(_emailController, 'tucorreo@ejemplo.com'),

              const SizedBox(height: 16),

              // Contraseña
              const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInputPass(_passController, 'Mínimo 8 caracteres', _obscurePass, () {
                setState(() => _obscurePass = !_obscurePass);
              }),

              const SizedBox(height: 16),

              // Confirmar contraseña
              const Text('Confirmar contraseña', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInputPass(_confirmPassController, 'Repite la contraseña', _obscureConfirmPass, () {
                setState(() => _obscureConfirmPass = !_obscureConfirmPass);
              }),

              const SizedBox(height: 28),

              // Button: Crear cuenta
              ElevatedButton(
                onPressed: widget.onRegisterSuccess,
                child: const Text('Crear cuenta'),
              ),

              const SizedBox(height: 20),

              // Terms
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Al registrarte aceptas nuestros ',
                    style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'Términos de Servicio\n',
                        style: const TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: 'y '),
                      TextSpan(
                        text: 'Política de Privacidad.',
                        style: const TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Footer
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta? ', style: TextStyle(color: Color(0xFF6B7280))),
                    GestureDetector(
                      onTap: widget.onGoToLogin,
                      child: const Text(
                        'Iniciar sesión',
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

  Widget _buildInput(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
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
    );
  }

  Widget _buildInputPass(TextEditingController controller, String hint, bool obscure, VoidCallback toggle) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFF6B7280),
          ),
          onPressed: toggle,
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
    );
  }
}
