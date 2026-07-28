import 'package:flutter/material.dart';
import '../widgets/yobs_logo_widget.dart';

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
      backgroundColor: const Color(0xFFF7F7F2), // Figma Cream
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // < Volver button
              TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF6B7280)),
                label: const Text('Volver', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              ),

              const SizedBox(height: 20),

              // Centered YÖBS Logo
              const Center(child: YobsLogoWidget(fontSize: 42)),

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
                      'Elige tu rol para comenzar.',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Card 1: Busco contratar (Figma Image 4)
              _buildRoleCard(
                icon: Icons.front_hand_rounded,
                title: 'Busco contratar',
                description: 'Encuentra profesionales para tus proyectos.',
                onTap: () => onSelectRole(false),
              ),

              const SizedBox(height: 16),

              // Card 2: Soy trabajador (Figma Image 4)
              _buildRoleCard(
                icon: Icons.construction_rounded,
                title: 'Soy trabajador',
                description: 'Ofrece tus servicios y gestiona tus clientes.',
                onTap: () => onSelectRole(true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBEBE6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6600).withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: const Color(0xFFFF6600),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
