import 'package:flutter/material.dart';
import '../widgets/yobs_logo_widget.dart';

/// Login con detección de rol según sección 3.3 del documento de lógica
class LoginScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onLoginSuccess;
  final VoidCallback onGoToRegister;
  final VoidCallback onLoginAsWorker;
  final VoidCallback onLoginAsClient;

  const LoginScreen({
    super.key,
    required this.onBack,
    required this.onLoginSuccess,
    required this.onGoToRegister,
    required this.onLoginAsWorker,
    required this.onLoginAsClient,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      _showError('Por favor completa tu correo y contraseña.');
      return;
    }

    setState(() => _isLoading = true);

    // Simulación de detección de rol desde backend
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Mostrar diálogo de selección de rol para demostración
    _showRoleDialog();
  }

  void _showRoleDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('¿Entrar como...?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () { Navigator.pop(ctx); widget.onLoginAsClient(); },
              icon: const Icon(Icons.front_hand_rounded),
              label: const Text('Cliente — Buscar servicios'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () { Navigator.pop(ctx); widget.onLoginAsWorker(); },
              icon: const Icon(Icons.construction_rounded),
              label: const Text('Trabajador — Mi panel'),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: const Color(0xFFEF4444)),
    );
  }

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
              TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF6B7280)),
                label: const Text('Volver', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              ),

              const SizedBox(height: 20),
              const Center(child: YobsLogoWidget(fontSize: 42)),
              const SizedBox(height: 32),

              const Center(
                child: Column(
                  children: [
                    Text('Iniciar sesión', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    SizedBox(height: 6),
                    Text('Bienvenido de vuelta.', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Text('Correo electrónico', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'tucorreo@ejemplo.com',
                  prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF6B7280)),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Se ha enviado un enlace de recuperación a tu correo.')),
                    ),
                    child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Color(0xFFFF6600), fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Tu contraseña',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF6B7280)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: const Color(0xFF6B7280)),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Continuar'),
              ),

              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta? ', style: TextStyle(color: Color(0xFF6B7280))),
                    GestureDetector(
                      onTap: widget.onGoToRegister,
                      child: const Text('Regístrate gratis', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold)),
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
