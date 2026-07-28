import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../services/order_database_service.dart';
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
      backgroundColor: const Color(0xFFF6F6F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111A20),
        title: const Row(
          children: [
            Icon(Icons.dashboard_rounded, color: Color(0xFFFB7A01)),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOBS Worker',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                Text(
                  'route: /worker/dashboard',
                  style: TextStyle(fontSize: 10, color: Color(0xFFFB7A01)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
            tooltip: 'Cambiar a modo Cliente',
            onPressed: widget.onSwitchRole,
          ),
        ],
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFFB7A01), // Figma Primary Orange
        unselectedItemColor: const Color(0xFF6E717F),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
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
            icon: Icon(Icons.trending_up_rounded),
            label: 'Ganancias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Perfil',
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
        return _buildEarningsTab();
      case 4:
        return _buildProfileTab();
      default:
        return _buildDashboardTab();
    }
  }

  // --- TAB 1: DASHBOARD (/worker/dashboard) ---
  Widget _buildDashboardTab() {
    final pendingCount = _requests.where((r) => r.status == RequestStatus.pendiente).length;
    final activeCount = _requests.where((r) => r.status == RequestStatus.enProceso).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de Ganancias según diseño Figma (#111A20 & #FB7A01)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF111A20), Color(0xFF1E2A32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Resumen de Ingresos',
                      style: TextStyle(color: Color(0xFF6E717F), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.account_balance_wallet_rounded, color: Color(0xFFFB7A01)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${_totalEarnings.toStringAsFixed(2)} USD',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFB7A01).withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '+18.5% incremento mensual',
                    style: TextStyle(color: Color(0xFFFB7A01), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Métricas de desempeño según Figma
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.pending_actions_rounded,
                  title: 'Pendientes',
                  value: '$pendingCount',
                  color: const Color(0xFFFB7A01),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.engineering_rounded,
                  title: 'En Proceso',
                  value: '$activeCount',
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Solicitudes de Empleo Entrantes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111A20)),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _requests.length,
            itemBuilder: (ctx, idx) {
              return _buildWorkerRequestTile(_requests[idx]);
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Color(0xFF6E717F), fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF111A20))),
        ],
      ),
    );
  }

  // --- TAB 2: SOLICITUDES (/worker/requests) ---
  Widget _buildRequestsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestión de Solicitudes Recibidas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111A20)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Acepta o rechaza solicitudes de clientes en tiempo real.',
            style: TextStyle(color: Color(0xFF6E717F), fontSize: 13),
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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cliente: ${req.clientName}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111A20)),
              ),
              Text(
                '\$${req.estimatedCost.toStringAsFixed(0)} USD',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFB7A01), fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(req.serviceTitle, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF374151))),
          const SizedBox(height: 4),
          Text('📍 ${req.address}', style: const TextStyle(color: Color(0xFF6E717F), fontSize: 12)),
          const SizedBox(height: 6),
          Text('📝 "${req.description}"', style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12, fontStyle: FontStyle.italic)),

          const SizedBox(height: 14),

          if (req.status == RequestStatus.pendiente)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                    ),
                    onPressed: () async {
                      setState(() {
                        req.status = RequestStatus.cancelado;
                      });
                      await OrderDatabaseService.updateOrderStatus(req.id, 'cancelado');
                    },
                    child: const Text('Rechazar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB7A01),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      setState(() {
                        req.status = RequestStatus.enProceso;
                      });
                      await OrderDatabaseService.updateOrderStatus(req.id, 'enProceso');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xFFFB7A01),
                            content: Text('¡Trabajo Aceptado y actualizado en MongoDB!'),
                          ),
                        );
                      }
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
                      backgroundColor: const Color(0xFF111A20),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const Text('Marcar como Finalizado'),
                    onPressed: () async {
                      setState(() {
                        req.status = RequestStatus.finalizado;
                      });
                      await OrderDatabaseService.updateOrderStatus(req.id, 'finalizado');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.chat_rounded, color: Color(0xFFFB7A01)),
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
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6E717F), fontSize: 12),
            ),
        ],
      ),
    );
  }

  // --- TAB 3: AGENDA (/worker/agenda) ---
  Widget _buildAgendaTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agenda de Trabajos Programados',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111A20)),
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
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFB7A01),
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

  // --- TAB 4: GANANCIAS & DESEMPEÑO (/worker/earnings) ---
  Widget _buildEarningsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estadísticas de Ingresos y Desempeño',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111A20)),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ingresos Semanales', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                // Simple bar representation for earnings
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar('Lun', 60),
                    _buildBar('Mar', 90),
                    _buildBar('Mié', 120),
                    _buildBar('Jue', 40),
                    _buildBar('Vie', 150),
                    _buildBar('Sáb', 200),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double height) {
    return Column(
      children: [
        Container(
          height: height,
          width: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFFB7A01),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 11, color: Color(0xFF6E717F))),
      ],
    );
  }

  // --- TAB 5: MI PERFIL (/worker/profile) ---
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 44,
            backgroundColor: Color(0xFFFB7A01),
            child: Text(
              'CM',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Carlos Mendoza',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111A20)),
          ),
          const Text(
            'Electricista Certificado • route: /worker/profile',
            style: TextStyle(color: Color(0xFF6E717F), fontSize: 12),
          ),
          const SizedBox(height: 24),

          ListTile(
            leading: const Icon(Icons.verified_rounded, color: Color(0xFFFB7A01)),
            title: const Text('Certificaciones y Documentación'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.photo_library_rounded, color: Color(0xFFFB7A01)),
            title: const Text('Galería de Trabajos (Portafolio)'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.rate_review_rounded, color: Color(0xFFFB7A01)),
            title: const Text('Reputación y Comentarios'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
