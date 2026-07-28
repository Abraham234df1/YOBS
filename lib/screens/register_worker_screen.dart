import 'package:flutter/material.dart';
import '../widgets/yobs_logo_widget.dart';
import '../services/mock_data_service.dart';
import '../services/mongodb_service.dart';

class RegisterWorkerScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onRegisterSuccess;
  final VoidCallback onGoToLogin;

  const RegisterWorkerScreen({
    super.key,
    required this.onBack,
    required this.onRegisterSuccess,
    required this.onGoToLogin,
  });

  @override
  State<RegisterWorkerScreen> createState() => _RegisterWorkerScreenState();
}

class _RegisterWorkerScreenState extends State<RegisterWorkerScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _certController = TextEditingController();
  final _rateController = TextEditingController(text: '35');
  final _passController = TextEditingController();

  String _selectedCategory = 'cat_electricidad';
  int _experienceYears = 5;
  bool _obscurePass = true;

  void _submitWorkerRegistration() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa los campos requeridos para tu perfil profesional.')),
      );
      return;
    }

    // Insert new worker into MongoDB if connected
    if (MongoDbService.isConnected) {
      await MongoDbService.seedInitialData();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFFF6600),
          content: Text('¡Perfil Profesional de Trabajador registrado con éxito!'),
        ),
      );
    }

    widget.onRegisterSuccess();
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

              // Header Banner for Worker
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6600),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.construction_rounded, color: Colors.white, size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registro de Especialista / Trabajador',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Crea tu perfil laboral para recibir solicitudes de clientes y gestionar tus trabajos.',
                            style: TextStyle(color: Color(0xFFFFEAD5), fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Nombre completo
              const Text('Nombre y Apellidos *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInput(_nameController, 'Ej. Carlos Mendoza'),

              const SizedBox(height: 16),

              // Oficio Principal / Categoría
              const Text('Oficio Principal *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: Color(0xFFEBEBE6)),
                  ),
                ),
                items: MockDataService.categories.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text(c.title),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),

              const SizedBox(height: 16),

              // Años de Experiencia & Tarifa por hora
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Años de Experiencia', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          initialValue: _experienceYears,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: const BorderSide(color: Color(0xFFEBEBE6)),
                            ),
                          ),
                          items: List.generate(20, (i) => i + 1).map((years) {
                            return DropdownMenuItem(
                              value: years,
                              child: Text('$years años'),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _experienceYears = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tarifa/hr (USD) *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                        const SizedBox(height: 6),
                        _buildInput(_rateController, 'Ej. 35'),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Certificación o Licencia
              const Text('Licencia o Certificación Oficial (Opcional)', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInput(_certController, 'Ej. Licencia Electricista Tipo A'),

              const SizedBox(height: 16),

              // Correo electrónico
              const Text('Correo electrónico *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInput(_emailController, 'carlos.mendoza@correo.com'),

              const SizedBox(height: 16),

              // Teléfono de contacto
              const Text('Teléfono de contacto *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInput(_phoneController, '+52 55 1234 5678'),

              const SizedBox(height: 16),

              // Contraseña
              const Text('Contraseña *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
              const SizedBox(height: 6),
              _buildInputPass(_passController, '••••••••', _obscurePass, () {
                setState(() => _obscurePass = !_obscurePass);
              }),

              const SizedBox(height: 28),

              // Button: Crear Perfil Profesional
              ElevatedButton.icon(
                onPressed: _submitWorkerRegistration,
                icon: const Icon(Icons.badge_rounded, size: 20),
                label: const Text('Crear Perfil Profesional de Trabajador'),
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
