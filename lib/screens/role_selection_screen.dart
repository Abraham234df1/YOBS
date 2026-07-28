import 'package:flutter/material.dart';
import '../widgets/yobs_logo_widget.dart';

/// Pantalla de selección de rol según Logica_de_uso_YOBS.md sección 3.4
/// Se muestra DESPUÉS de tocar "Crear cuenta", ANTES de llenar el formulario.
class RoleSelectionScreen extends StatelessWidget {
  final VoidCallback onBack;
  final Function(bool isWorker) onSelectRole;

  const RoleSelectionScreen({
    super.key,
    required this.onBack,
    required this.onSelectRole,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF6B7280)),
                label: const Text('Volver', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              ),

              const SizedBox(height: 20),

              const Center(child: YobsLogoWidget(fontSize: 40)),

              const SizedBox(height: 36),

              const Center(
                child: Column(
                  children: [
                    Text(
                      '¿Cómo quieres usar YOBS?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Elige tu rol para continuar con el registro.',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Card: Buscar servicios como cliente
              _buildRoleCard(
                context: context,
                icon: Icons.front_hand_rounded,
                title: 'Busco contratar',
                description: 'Encuentra profesionales certificados para tus proyectos y servicios en el hogar.',
                badges: const ['Verificación de identidad requerida', '🛡️ Alta seguridad'],
                badgeColor: const Color(0xFF111827),
                onTap: () => onSelectRole(false),
              ),

              const SizedBox(height: 16),

              // Card: Ofrecer servicios como trabajador
              _buildRoleCard(
                context: context,
                icon: Icons.construction_rounded,
                title: 'Soy trabajador',
                description: 'Ofrece tus servicios, gestiona solicitudes y aumenta tu reputación en la plataforma.',
                badges: const ['Perfil profesional', '🏅 Construye tu reputación'],
                badgeColor: const Color(0xFFFF6600),
                onTap: () => onSelectRole(true),
              ),

              const Spacer(),

              Center(
                child: Text(
                  'Siempre podrás cambiar tu rol desde la configuración.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required List<String> badges,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBEBE6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6600).withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 30, color: const Color(0xFFFF6600)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                          const SizedBox(height: 4),
                          Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.4)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFF6B7280)),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  children: badges.map((b) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withAlpha(15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: badgeColor.withAlpha(40)),
                    ),
                    child: Text(b, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor)),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
