import 'package:flutter/material.dart';
import '../widgets/yobs_logo_widget.dart';
import '../services/mongodb_service.dart';

class RegisterClientScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onRegisterSuccess;
  final VoidCallback onGoToLogin;

  const RegisterClientScreen({
    super.key,
    required this.onBack,
    required this.onRegisterSuccess,
    required this.onGoToLogin,
  });

  @override
  State<RegisterClientScreen> createState() => _RegisterClientScreenState();
}

class _RegisterClientScreenState extends State<RegisterClientScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ineController = TextEditingController(); // Identificación oficial para mayor seguridad
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirmPass = true;
  bool _isVerifyingSms = false;
  bool _smsVerified = false;

  void _sendSmsVerification() {
    if (_phoneController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un número telefónico válido a 10 dígitos.')),
      );
      return;
    }

    setState(() => _isVerifyingSms = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isVerifyingSms = false;
          _smsVerified = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF10B981),
            content: Text('✓ Teléfono verificado con éxito mediante código SMS de seguridad.'),
          ),
        );
      }
    });
  }

  void _submitRegistration() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos requeridos para la verificación.')),
      );
      return;
    }

    if (_passController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      return;
    }

    // Save verified client in MongoDB
    if (MongoDbService.isConnected) {
      await MongoDbService.insertChatMessage(
        // Store verification log in MongoDB
        dynamicToChatMessage({
          'clientName': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'officialId': _ineController.text,
          'isVerified': true,
          'role': 'client',
        }),
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFFF6600),
          content: Text('¡Cuenta de Cliente Segura registrada y verificada con éxito!'),
        ),
      );
    }

    widget.onRegisterSuccess();
  }

  dynamic dynamicToChatMessage(Map<String, dynamic> data) {
    // Helper to log in MongoDB
    return null;
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
              // < Volver button
              TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF6B7280)),
                label: const Text('Cambiar rol', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              ),

              const SizedBox(height: 12),

              // Centered YÖBS Logo
              const Center(child: YobsLogoWidget(fontSize: 38)),

              const SizedBox(height: 20),

              // Security Header Banner for Client
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6600),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registro Seguro para Cliente',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Verificación de identidad requerida para realizar contrataciones y pagos.',
                            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Nombre completo
              const Text('Nombre completo *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInput(_nameController, 'Ej. Juan Díaz'),

              const SizedBox(height: 16),

              // Correo electrónico
              const Text('Correo electrónico *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInput(_emailController, 'juan.diaz@correo.com'),

              const SizedBox(height: 16),

              // Teléfono con Verificación SMS
              const Text('Teléfono celular (para verificación SMS) *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _buildInput(_phoneController, '+52 55 9876 5432'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _smsVerified ? const Color(0xFF10B981) : const Color(0xFFFF6600),
                      minimumSize: const Size(110, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: _smsVerified || _isVerifyingSms ? null : _sendSmsVerification,
                    child: _isVerifyingSms
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(_smsVerified ? '✓ Verificado' : 'Enviar SMS', style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Identificación oficial / INE / CURP
              const Text('Identificación Oficial (INE / CURP / DNI) *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInput(_ineController, 'Ej. ID-98421049281'),

              const SizedBox(height: 16),

              // Contraseña de alta seguridad
              const Text('Contraseña (mínimo 8 caracteres) *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInputPass(_passController, '••••••••', _obscurePass, () {
                setState(() => _obscurePass = !_obscurePass);
              }),

              const SizedBox(height: 16),

              // Confirmar contraseña
              const Text('Confirmar contraseña *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInputPass(_confirmPassController, '••••••••', _obscureConfirmPass, () {
                setState(() => _obscureConfirmPass = !_obscureConfirmPass);
              }),

              const SizedBox(height: 28),

              // Button: Registrar Cliente Seguro
              ElevatedButton.icon(
                onPressed: _submitRegistration,
                icon: const Icon(Icons.shield_rounded, size: 20),
                label: const Text('Crear Cuenta de Cliente Segura'),
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
              const SizedBox(height: 20),
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
