import 'package:flutter/material.dart';
import '../services/order_database_service.dart';
import '../widgets/yobs_logo_widget.dart';
class WorkerHomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const WorkerHomeScreen({
    super.key,
    required this.onLogout,
  });

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  int _currentIndex = 0;
  String _historialFilter = 'todos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const YobsLogoWidget(fontSize: 26),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF6B7280)),
            tooltip: 'Salir',
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFFF6600), // Figma Orange
        unselectedItemColor: const Color(0xFF6B7280),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Panel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month_rounded),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_rounded),
            activeIcon: Icon(Icons.attach_money_rounded),
            label: 'Ingresos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _buildPanelTab();
      case 1:
        return _buildAgendaTab();
      case 2:
        return _buildHistorialTab();
      case 3:
        return _buildIngresosTab();
      case 4:
        return _buildPerfilTab();
      default:
        return _buildPanelTab();
    }
  }

  // --- TAB 1: PANEL (Figma Image 10) ---
  Widget _buildPanelTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hola, Carlos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 2),
          const Text('Aquí está tu resumen de hoy', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
          const SizedBox(height: 20),

          Row(
            children: [
              const Text('Solicitudes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6600),
                  shape: BoxShape.circle,
                ),
                child: const Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Request Card 1 (María García - Normal)
          _buildRequestCard(
            clientName: 'María García',
            tag: 'Normal',
            isUrgent: false,
            time: 'Hoy, 3:45 PM',
            serviceDescription: 'Instalación de 3 enchufes en...',
            address: 'Av. Insurgentes 24...',
            reqId: 'REQ-101',
          ),

          const SizedBox(height: 14),

          // Request Card 2 (Pedro López - Urgente)
          _buildRequestCard(
            clientName: 'Pedro López',
            tag: 'Urgente',
            isUrgent: true,
            time: 'Hoy, 4:10 PM',
            serviceDescription: 'Corto circuito en cocina —...',
            address: 'Calle Durango 88, ...',
            reqId: 'REQ-102',
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required String clientName,
    required String tag,
    required bool isUrgent,
    required String time,
    required String serviceDescription,
    required String address,
    required String reqId,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBEBE6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 4, backgroundColor: Color(0xFFFF6600)),
                  const SizedBox(width: 6),
                  Text(clientName, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600), fontSize: 13)),
                  const SizedBox(width: 6),
                  const Text('Nueva solicitud', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                ],
              ),
              Text(time, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Color(0xFFEBEBE6), child: Icon(Icons.person, color: Color(0xFF6B7280))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(clientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isUrgent ? const Color(0xFFFEE2E2) : const Color(0xFFF0EFE6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: isUrgent ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Text('Por trabajo', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600), fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(serviceDescription, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF7F7F2), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFFFF6600)),
                    const SizedBox(width: 4),
                    Text(address, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF7F7F2), borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, size: 14, color: Color(0xFFFF6600)),
                    SizedBox(width: 4),
                    Text('Hoy', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await OrderDatabaseService.updateOrderStatus(reqId, 'cancelado');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Solicitud rechazada.')));
                    }
                  },
                  icon: const Icon(Icons.cancel_outlined, color: Color(0xFFEF4444), size: 18),
                  label: const Text('Rechazar', style: TextStyle(color: Color(0xFFEF4444))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await OrderDatabaseService.updateOrderStatus(reqId, 'enProceso');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(backgroundColor: Color(0xFFFF6600), content: Text('¡Trabajo Aceptado! Registrado en MongoDB.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Ver detalles'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 2: AGENDA (Figma Image 12) ---
  Widget _buildAgendaTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AGENDA', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 2),
          const Text('Trabajos programados', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 16),

          // Counter Cards Row (5 Total, 3 Confirmados, 2 Pendientes)
          Row(
            children: [
              Expanded(child: _buildAgendaCountCard('5', 'Total', const Color(0xFFFF6600), Colors.white)),
              const SizedBox(width: 10),
              Expanded(child: _buildAgendaCountCard('3', 'Confirmados', const Color(0xFFD1FAE5), const Color(0xFF047857))),
              const SizedBox(width: 10),
              Expanded(child: _buildAgendaCountCard('2', 'Pendientes', const Color(0xFFFEF3C7), const Color(0xFFD97706))),
            ],
          ),

          const SizedBox(height: 20),
          const Text('PRÓXIMOS', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 12),

          Expanded(
            child: ListView(
              children: [
                _buildAgendaJobCard('Revisión de tablero eléctrico', 'Juan Pérez · Hoy 4:00 PM', '\$150', 'Confirmado', true),
                _buildAgendaJobCard('Instalación de lámparas LED', 'Laura Nieto · Mañana 10:30 AM', '\$120', 'Pendiente', false),
                _buildAgendaJobCard('Corto circuito en cocina', 'Roberto Sánchez · 23 Jul 9:00 AM', '\$200', 'Confirmado', true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaCountCard(String count, String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEBEBE6)),
      ),
      child: Column(
        children: [
          Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildAgendaJobCard(String title, String sub, String price, String status, bool isConfirmed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBEBE6)),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 20, backgroundColor: Color(0xFFEBEBE6), child: Icon(Icons.person, color: Color(0xFF6B7280))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(sub, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600), fontSize: 15)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isConfirmed ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isConfirmed ? const Color(0xFF047857) : const Color(0xFFD97706),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 3: HISTORIAL (Figma Image 15) ---
  Widget _buildHistorialTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HISTORIAL', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 2),
          const Text('Servicios finalizados', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 16),

          // Reputation Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEBEBE6)),
            ),
            child: Column(
              children: [
                const Text('Reputación actual', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('4.7 ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    Icon(Icons.star_rounded, color: Color(0xFFFF6600), size: 28),
                    Icon(Icons.star_rounded, color: Color(0xFFFF6600), size: 28),
                    Icon(Icons.star_rounded, color: Color(0xFFFF6600), size: 28),
                    Icon(Icons.star_rounded, color: Color(0xFFFF6600), size: 28),
                    Icon(Icons.star_half_rounded, color: Color(0xFFFF6600), size: 28),
                  ],
                ),
                const Text('3 evaluaciones recibidas', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _buildHistStatBox('5', 'Servicios', const Color(0xFFFFEAD5))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildHistStatBox('3', 'Calificados', const Color(0xFFF0EFE6))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildHistStatBox('2', 'Pendientes', const Color(0xFFF0EFE6))),
                  ],
                ),

                const Divider(height: 24),

                Row(
                  children: [
                    _buildFilterPill('todos', 'Todos los servicios'),
                    const SizedBox(width: 8),
                    _buildFilterPill('calificados', 'Calificados'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistStatBox(String val, String lbl, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF6600))),
          Text(lbl, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String id, String label) {
    final active = _historialFilter == id;
    return GestureDetector(
      onTap: () => setState(() => _historialFilter = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFF6600) : const Color(0xFFF0EFE6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFF6B7280),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  // --- TAB 4: INGRESOS (Figma Image 13) ---
  Widget _buildIngresosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('INGRESOS', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 2),
          const Text('Detalle financiero', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 16),

          // Total Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEBEBE6)),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('💰 Ingresos del mes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Julio 2026 · semana a semana', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$2000', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFFF6600))),
                        Text('total del mes', style: TextStyle(color: Color(0xFF6B7280), fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(child: _buildIngresoStatBox('🔧', '28', 'servicios')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildIngresoStatBox('📅', '4', 'semanas')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildIngresoStatBox('💵', '\$71', 'por servicio')),
                  ],
                ),

                const SizedBox(height: 20),

                _buildSemanaBar('Semana 1', '1–7 Jul', '\$420', '6 trabajos · Regular', 0.6),
                _buildSemanaBar('Semana 2', '8–14 Jul', '\$580', '8 trabajos · Muy bien', 0.8),
                _buildSemanaBar('Semana 3', '15–21 Jul', '\$310', '5 trabajos · Regular', 0.45),
                _buildSemanaBar('Semana 4', '22–31 Jul', '\$690', '9 trabajos · ¡Excelente!', 0.95),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngresoStatBox(String icon, String val, String lbl) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAD5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          Text(lbl, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildSemanaBar(String sem, String dates, String amount, String status, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$sem ($dates)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600), fontSize: 15)),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(status, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFEBEBE6),
            color: const Color(0xFFFF6600),
            borderRadius: BorderRadius.circular(6),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  // --- TAB 5: PERFIL (Figma Image 16 & 17) ---
  Widget _buildPerfilTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MI PERFIL', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 12),

          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6600), Color(0xFFFF8533)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withAlpha(40),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(110, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () {},
                    child: const Text('✏ Editar perfil', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: Text('CM', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF6600))),
                    ),
                    SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Carlos Mendoza', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Electricista Certificado', style: TextStyle(color: Color(0xFFFFEAD5), fontSize: 13, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('📍 Ciudad de México, Centro', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _buildWorkerStatCard('🏅', '8 años', 'Experiencia')),
              const SizedBox(width: 12),
              Expanded(child: _buildWorkerStatCard('✓', '127', 'Trabajos')),
            ],
          ),

          const SizedBox(height: 20),

          const Text('SOBRE MÍ', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
            child: const Text(
              'Soluciono cortos circuitos, instalo cableado nuevo y hago mantenimiento preventivo.',
              style: TextStyle(color: Color(0xFF4B5563), height: 1.4),
            ),
          ),

          const SizedBox(height: 20),

          const Text('CERTIFICACIONES', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildCertPill('🛡 Licencia Tipo A'),
              const SizedBox(width: 8),
              _buildCertPill('🛡 Alta Tensión'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerStatCard(String icon, String val, String lbl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF6600))),
          Text(lbl, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildCertPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFFFEAD5), borderRadius: BorderRadius.circular(16)),
      child: Text(label, style: const TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
