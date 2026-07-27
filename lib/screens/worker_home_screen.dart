import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_data_service.dart';
import 'chat_screen.dart';

class WorkerHomeScreen extends StatefulWidget {
  final VoidCallback onSwitchRole;

  const WorkerHomeScreen({
    super.key,
    required this.onSwitchRole,
  });

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  int _currentIndex = 0;
  final List<JobRequest> _requests = List.from(MockDataService.requests);

  double get _totalEarnings {
    return _requests
        .where((r) => r.status == RequestStatus.finalizado || r.status == RequestStatus.enProceso)
        .fold(0.0, (sum, r) => sum + r.estimatedCost);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.badge_rounded, color: Color(0xFF059669)),
            SizedBox(width: 8),
            Text(
              'YOBS - Panel Trabajador',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Cambiar a modo Cliente',
            onPressed: widget.onSwitchRole,
          ),
        ],
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF059669),
        unselectedItemColor: const Color(0xFF94A3B8),
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Panel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline_rounded),
            label: 'Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Mi Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildRequestsTab();
      case 2:
        return _buildAgendaTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildDashboardTab();
    }
  }

  // --- TAB 1: DASHBOARD DE GANANCIAS ---
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de Ganancias acumuladas
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF059669).withAlpha(60),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ganancias del Mes',
                  style: TextStyle(color: Color(0xFFD1FAE5), fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${_totalEarnings.toStringAsFixed(2)} USD',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.trending_up_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text(
                      '+18% respecto al mes anterior',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Métricas de desempeño
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.check_circle_outline_rounded,
                  title: 'Trabajos Completados',
                  value: '142',
                  color: const Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.star_rounded,
                  title: 'Calificación Promedio',
                  value: '4.9 ★',
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Solicitudes Recientes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _requests.length,
            itemBuilder: (ctx, idx) {
              final req = _requests[idx];
              return _buildWorkerRequestTile(req);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  // --- TAB 2: SOLICITUDES PARA ACEPTAR/RECHAZAR ---
  Widget _buildRequestsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestión de Solicitudes Recibidas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Acepta o rechaza trabajos entrantes de clientes.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: _requests.length,
              itemBuilder: (ctx, idx) {
                return _buildWorkerRequestTile(_requests[idx]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerRequestTile(JobRequest req) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cliente: ${req.clientName}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                '\$${req.estimatedCost.toStringAsFixed(0)} USD',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669), fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(req.serviceTitle, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155))),
          const SizedBox(height: 4),
          Text('📍 ${req.address}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
          const SizedBox(height: 6),
          Text('📝 "${req.description}"', style: const TextStyle(color: Color(0xFF475569), fontSize: 12, fontStyle: FontStyle.italic)),

          const SizedBox(height: 12),

          if (req.status == RequestStatus.pendiente)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                    ),
                    onPressed: () {
                      setState(() {
                        req.status = RequestStatus.cancelado;
                      });
                    },
                    child: const Text('Rechazar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        req.status = RequestStatus.enProceso;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xFF059669),
                          content: Text('¡Trabajo Aceptado! Se ha notificado al cliente.'),
                        ),
                      );
                    },
                    child: const Text('Aceptar Trabajo'),
                  ),
                ),
              ],
            )
          else if (req.status == RequestStatus.enProceso)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const Text('Marcar como Finalizado'),
                    onPressed: () {
                      setState(() {
                        req.status = RequestStatus.finalizado;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.chat_rounded, color: Color(0xFF2563EB)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          title: req.clientName,
                          messages: MockDataService.initialMessages,
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          else
            Text(
              'Estado: ${req.status.name.toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B), fontSize: 12),
            ),
        ],
      ),
    );
  }

  // --- TAB 3: AGENDA ---
  Widget _buildAgendaTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agenda de Trabajos Programados',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _requests.length,
              itemBuilder: (ctx, idx) {
                final item = _requests[idx];
                return ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF059669),
                    child: Icon(Icons.calendar_today_rounded, color: Colors.white, size: 18),
                  ),
                  title: Text(item.serviceTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Cliente: ${item.clientName}\nHorario: 10:00 AM - 12:00 PM'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: MI PERFIL (TRABAJADOR) ---
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 44,
            backgroundColor: Color(0xFF059669),
            child: Text(
              'CM',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Carlos Mendoza',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Electricista Certificado',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 24),

          ListTile(
            leading: const Icon(Icons.verified_rounded, color: Color(0xFF059669)),
            title: const Text('Certificaciones y Documentación'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF059669)),
            title: const Text('Galería de Trabajos (Portafolio)'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.rate_review_rounded, color: Color(0xFF059669)),
            title: const Text('Reputación y Comentarios'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: Color(0xFF64748B)),
            title: const Text('Configuración de Cuenta'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
