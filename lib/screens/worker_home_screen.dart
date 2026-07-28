import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../services/order_database_service.dart';
import '../widgets/yobs_logo_widget.dart';
import 'chat_screen.dart';

/// Pantalla del TRABAJADOR según secciones 5.x del documento de lógica.
/// Navegación: Panel | Solicitudes | Agenda | Mensajes | Historial | Ingresos | Perfil
class WorkerHomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const WorkerHomeScreen({super.key, required this.onLogout});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  int _currentIndex = 0;
  final List<JobRequest> _requests = List.from(MockDataService.workerRequests);
  String _historialFilter = 'todos';

  // Solicitudes nuevas (pendientes)
  List<JobRequest> get _pendingRequests => _requests.where((r) => r.status == RequestStatus.pendiente).toList();
  // Próximos trabajos (aceptadas o confirmadas)
  List<JobRequest> get _upcomingJobs => _requests.where((r) => r.status == RequestStatus.aceptada || r.status == RequestStatus.confirmada || r.status == RequestStatus.enProceso).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const YobsLogoWidget(fontSize: 26),
        actions: [
          if (_pendingRequests.isNotEmpty)
            Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: Color(0xFF6B7280), size: 28),
                Positioned(
                  right: 0, top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Color(0xFFFF6600), shape: BoxShape.circle),
                    child: Text('${_pendingRequests.length}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF6B7280)),
            tooltip: 'Cerrar sesión',
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFFF6600),
        unselectedItemColor: const Color(0xFF6B7280),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view_rounded), label: 'Panel'),
          BottomNavigationBarItem(
            icon: _pendingRequests.isNotEmpty
                ? Badge(backgroundColor: const Color(0xFFFF6600), label: Text('${_pendingRequests.length}'), child: const Icon(Icons.assignment_outlined))
                : const Icon(Icons.assignment_outlined),
            activeIcon: const Icon(Icons.assignment_rounded),
            label: 'Solicitudes',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month_rounded), label: 'Agenda'),
          const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), activeIcon: Icon(Icons.chat_bubble_rounded), label: 'Mensajes'),
          const BottomNavigationBarItem(icon: Icon(Icons.history_toggle_off_rounded), activeIcon: Icon(Icons.history_rounded), label: 'Historial'),
          const BottomNavigationBarItem(icon: Icon(Icons.attach_money_rounded), label: 'Ingresos'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0: return _buildPanelTab();
      case 1: return _buildSolicitudesTab();
      case 2: return _buildAgendaTab();
      case 3: return _buildMensajesTab();
      case 4: return _buildHistorialTab();
      case 5: return _buildIngresosTab();
      case 6: return _buildPerfilTab();
      default: return _buildPanelTab();
    }
  }

  // ─────────────────────────────────────────────
  // TAB 1: PANEL (sección 5.2)
  // ─────────────────────────────────────────────
  Widget _buildPanelTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo
          const Text('Hola, Carlos 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const Text('Aquí está tu resumen de hoy', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
          const SizedBox(height: 20),

          // Resumen en tarjetas
          Row(
            children: [
              Expanded(child: _summaryCard('📋', '${_pendingRequests.length}', 'Nuevas\nsolicitudes', const Color(0xFFFFEAD5))),
              const SizedBox(width: 12),
              Expanded(child: _summaryCard('📅', '${_upcomingJobs.length}', 'Trabajos\npróximos', const Color(0xFFD1FAE5))),
              const SizedBox(width: 12),
              Expanded(child: _summaryCard('💰', '\$2000', 'Ingreso\ndel mes', const Color(0xFFF0EFE6))),
            ],
          ),

          const SizedBox(height: 24),

          // Solicitudes nuevas en el panel
          if (_pendingRequests.isNotEmpty) ...[
            Row(
              children: [
                const Text('Solicitudes nuevas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: const BoxDecoration(color: Color(0xFFFF6600), shape: BoxShape.circle),
                  child: Text('${_pendingRequests.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._pendingRequests.take(2).map((req) => _buildWorkerRequestCard(req)),
            if (_pendingRequests.length > 2)
              TextButton(
                onPressed: () => setState(() => _currentIndex = 1),
                child: Text('Ver todas (${_pendingRequests.length}) →', style: const TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold)),
              ),
          ],

          if (_pendingRequests.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(18)),
              child: const Column(
                children: [
                  Text('✅', style: TextStyle(fontSize: 32)),
                  SizedBox(height: 8),
                  Text('¡Todo al día!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('No tienes solicitudes pendientes.', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Próximos trabajos
          if (_upcomingJobs.isNotEmpty) ...[
            const Text('Trabajos próximos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            const SizedBox(height: 12),
            ..._upcomingJobs.take(3).map((req) => _buildAgendaJobTile(req)),
          ],
        ],
      ),
    );
  }

  Widget _summaryCard(String emoji, String value, String label, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 2: SOLICITUDES (sección 5.3 y 5.4)
  // ─────────────────────────────────────────────
  Widget _buildSolicitudesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SOLICITUDES', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
              const SizedBox(height: 2),
              Text('Solicitudes recibidas (${_requests.length})', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            ],
          ),
        ),
        Expanded(
          child: _requests.isEmpty
              ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.assignment_outlined, size: 56, color: Color(0xFFCCCCC0)), SizedBox(height: 12), Text('No tienes solicitudes aún.', style: TextStyle(color: Color(0xFF6B7280)))]))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _requests.length,
                  itemBuilder: (ctx, i) => _buildWorkerRequestCard(_requests[i]),
                ),
        ),
      ],
    );
  }

  Widget _buildWorkerRequestCard(JobRequest req) {
    final isUrgent = req.urgency == UrgencyLevel.urgente;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isUrgent ? const Color(0xFFEF4444).withAlpha(60) : const Color(0xFFEBEBE6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const CircleAvatar(radius: 4, backgroundColor: Color(0xFFFF6600)),
              const SizedBox(width: 6),
              Text(req.id, style: const TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(width: 6),
              const Text('Nueva solicitud', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
              const Spacer(),
              _urgencyBadge(req.urgency),
            ],
          ),
          const Divider(height: 16),

          // Cliente y descripción
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Color(0xFFEBEBE6), child: Icon(Icons.person_rounded, color: Color(0xFF6B7280))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(req.serviceTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                        Text('\$${req.estimatedPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600), fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(req.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Ubicación y fecha
          Row(
            children: [
              _infoChip(Icons.location_on_outlined, req.address),
              const SizedBox(width: 8),
              _infoChip(Icons.calendar_today_outlined, 'Hoy'),
            ],
          ),

          const SizedBox(height: 14),

          // Acciones: Rechazar | Aceptar
          if (req.status == RequestStatus.pendiente)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFEF4444), side: const BorderSide(color: Color(0xFFEF4444))),
                    onPressed: () => _showRejectDialog(req),
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('Rechazar', style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _acceptRequest(req),
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                    label: const Text('Aceptar', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            )
          else
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(14)),
                child: Text(req.statusLabel, style: const TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _urgencyBadge(UrgencyLevel level) {
    switch (level) {
      case UrgencyLevel.urgente:
        return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(10)), child: const Text('🔴 Urgente', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 11)));
      case UrgencyLevel.hoyMismo:
        return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)), child: const Text('⚡ Hoy mismo', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 11)));
      case UrgencyLevel.normal:
        return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFF0EFE6), borderRadius: BorderRadius.circular(10)), child: const Text('Normal', style: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.bold, fontSize: 11)));
    }
  }

  Widget _infoChip(IconData icon, String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: const Color(0xFFF7F7F2), borderRadius: BorderRadius.circular(12)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 13, color: const Color(0xFFFF6600)), const SizedBox(width: 4), Text(text, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)))]),
  );

  void _acceptRequest(JobRequest req) async {
    await OrderDatabaseService.updateOrderStatus(req.id, 'aceptada');
    if (!mounted) return;
    setState(() => req.status = RequestStatus.aceptada);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: Color(0xFFFF6600), content: Text('✅ Solicitud aceptada. El cliente ha sido notificado.')),
    );
  }

  void _showRejectDialog(JobRequest req) {
    String motivo = 'No disponible';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Por qué rechazas esta solicitud?'),
        content: StatefulBuilder(
          builder: (ctx2, setMotivoState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: ['No disponible', 'Fuera de zona', 'Servicio no compatible', 'Horario no disponible'].map((m) => InkWell(
              onTap: () => setMotivoState(() => motivo = m),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  Icon(motivo == m ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: const Color(0xFFFF6600), size: 20),
                  const SizedBox(width: 10),
                  Text(m, style: const TextStyle(fontSize: 13)),
                ]),
              ),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () async {
              await OrderDatabaseService.updateOrderStatus(req.id, 'rechazada');
              if (!mounted) return;
              setState(() {
                req.status = RequestStatus.rechazada;
                req.rejectionReason = motivo;
              });
              if (!context.mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Solicitud rechazada. El cliente ha sido notificado.')));
            },
            child: const Text('Confirmar rechazo'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 3: AGENDA (sección 5.5)
  // ─────────────────────────────────────────────
  Widget _buildAgendaTab() {
    final agendaItems = _requests.where((r) =>
        r.status == RequestStatus.aceptada ||
        r.status == RequestStatus.confirmada ||
        r.status == RequestStatus.enProceso).toList();

    final confirmados = agendaItems.where((r) => r.status == RequestStatus.confirmada).length;
    final pendientes = agendaItems.where((r) => r.status == RequestStatus.aceptada).length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AGENDA', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 2),
          const Text('Trabajos programados', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 16),

          // Contadores
          Row(
            children: [
              Expanded(child: _agendaCounter('${agendaItems.length}', 'Total', const Color(0xFFFF6600), Colors.white)),
              const SizedBox(width: 10),
              Expanded(child: _agendaCounter('$confirmados', 'Confirmados', const Color(0xFFD1FAE5), const Color(0xFF047857))),
              const SizedBox(width: 10),
              Expanded(child: _agendaCounter('$pendientes', 'Pendientes', const Color(0xFFFEF3C7), const Color(0xFFD97706))),
            ],
          ),

          const SizedBox(height: 20),
          const Text('PRÓXIMOS', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 12),

          Expanded(
            child: agendaItems.isEmpty
                ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.calendar_month_outlined, size: 56, color: Color(0xFFCCCCC0)), SizedBox(height: 12), Text('No tienes trabajos programados.', style: TextStyle(color: Color(0xFF6B7280)))]))
                : ListView(children: agendaItems.map(_buildAgendaJobTile).toList()),
          ),
        ],
      ),
    );
  }

  Widget _agendaCounter(String val, String lbl, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
      child: Column(children: [
        Text(val, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
        Text(lbl, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
      ]),
    );
  }

  Widget _buildAgendaJobTile(JobRequest req) {
    final bool confirmed = req.status == RequestStatus.confirmada || req.status == RequestStatus.enProceso;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEBEBE6))),
      child: Row(
        children: [
          const CircleAvatar(radius: 20, backgroundColor: Color(0xFFEBEBE6), child: Icon(Icons.person_rounded, color: Color(0xFF6B7280))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(req.serviceTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(req.address, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11), overflow: TextOverflow.ellipsis),
                Row(children: [_urgencyBadge(req.urgency)]),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${req.estimatedPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600), fontSize: 15)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: confirmed ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)),
                child: Text(confirmed ? 'Confirmado' : 'Pendiente', style: TextStyle(color: confirmed ? const Color(0xFF047857) : const Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 4: MENSAJES (sección 5.6)
  // ─────────────────────────────────────────────
  Widget _buildMensajesTab() {
    final chatable = _requests.where((r) => r.status != RequestStatus.rechazada && r.status != RequestStatus.cancelada).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('MENSAJES', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
              const SizedBox(height: 2),
              Text('Conversaciones (${chatable.length})', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(decoration: const InputDecoration(hintText: 'Buscar conversación', prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6B7280)))),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: chatable.isEmpty
              ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.chat_bubble_outline_rounded, size: 56, color: Color(0xFFCCCCC0)), SizedBox(height: 12), Text('Sin conversaciones activas.', style: TextStyle(color: Color(0xFF6B7280)))]))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: chatable.length,
                  itemBuilder: (ctx, i) {
                    final req = chatable[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEBEBE6))),
                      child: ListTile(
                        leading: Stack(children: [
                          const CircleAvatar(backgroundColor: Color(0xFFEBEBE6), child: Icon(Icons.person_rounded, color: Color(0xFF6B7280))),
                          const Positioned(right: 0, bottom: 0, child: CircleAvatar(radius: 5, backgroundColor: Color(0xFF10B981))),
                        ]),
                        title: Text('Cliente — ${req.serviceTitle}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text(req.address, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)), overflow: TextOverflow.ellipsis),
                        trailing: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Color(0xFFFF6600), shape: BoxShape.circle), child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(title: req.serviceTitle, messages: MockDataService.initialMessages))),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // TAB 5: HISTORIAL (sección 5.8)
  // ─────────────────────────────────────────────
  Widget _buildHistorialTab() {
    final allIncomes = MockDataService.workerIncomes;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HISTORIAL', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 2),
          const Text('Servicios finalizados', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 16),

          // Reputación
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEBEBE6))),
            child: Column(
              children: [
                const Text('Reputación actual', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                const SizedBox(height: 4),
                const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('4.7 ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                  Icon(Icons.star_rounded, color: Color(0xFFFF6600), size: 28),
                  Icon(Icons.star_rounded, color: Color(0xFFFF6600), size: 28),
                  Icon(Icons.star_rounded, color: Color(0xFFFF6600), size: 28),
                  Icon(Icons.star_rounded, color: Color(0xFFFF6600), size: 28),
                  Icon(Icons.star_half_rounded, color: Color(0xFFFF6600), size: 28),
                ]),
                const Text('3 evaluaciones recibidas', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: _histStat('${allIncomes.length}', 'Servicios', const Color(0xFFFFEAD5))),
                  const SizedBox(width: 10),
                  Expanded(child: _histStat('3', 'Calificados', const Color(0xFFF0EFE6))),
                  const SizedBox(width: 10),
                  Expanded(child: _histStat('1', 'Pendientes', const Color(0xFFF0EFE6))),
                ]),
                const Divider(height: 24),
                Wrap(
                  spacing: 8,
                  children: ['todos', 'calificados', 'pendientes'].map((id) => GestureDetector(
                    onTap: () => setState(() => _historialFilter = id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: _historialFilter == id ? const Color(0xFFFF6600) : const Color(0xFFF0EFE6), borderRadius: BorderRadius.circular(16)),
                      child: Text(id[0].toUpperCase() + id.substring(1), style: TextStyle(color: _historialFilter == id ? Colors.white : const Color(0xFF6B7280), fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Reseñas
          const Text('RESEÑAS RECIENTES', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          ...MockDataService.workerReviews.map((rev) => _buildReviewTile(rev)),
        ],
      ),
    );
  }

  Widget _histStat(String val, String lbl, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Column(children: [Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF6600))), Text(lbl, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)))]),
    );
  }

  Widget _buildReviewTile(Review rev) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFFF6600).withAlpha(20),
            radius: 20,
            child: Text(rev.clientName.substring(0, 2), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFFF6600))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(rev.clientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const Spacer(),
                    Row(children: List.generate(5, (i) => Icon(i < rev.rating ? Icons.star_rounded : Icons.star_outline_rounded, color: const Color(0xFFFF6600), size: 14))),
                  ],
                ),
                const SizedBox(height: 2),
                Text(rev.comment, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12)),
                Text('${rev.date.day}/${rev.date.month}/${rev.date.year}', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 6: INGRESOS (sección 5.9)
  // ─────────────────────────────────────────────
  Widget _buildIngresosTab() {
    final incomes = MockDataService.workerIncomes;
    final total = incomes.fold(0.0, (sum, i) => sum + i.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('INGRESOS', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 2),
          const Text('Detalle financiero', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEBEBE6))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('💰 Ingresos del mes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Julio 2026 · semana a semana', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                    ]),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('\$${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFFF6600))),
                      const Text('total del mes', style: TextStyle(color: Color(0xFF6B7280), fontSize: 10)),
                    ]),
                  ],
                ),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: _incomeStatBox('🔧', '${incomes.length}', 'servicios')),
                  const SizedBox(width: 8),
                  Expanded(child: _incomeStatBox('📅', '4', 'semanas')),
                  const SizedBox(width: 8),
                  Expanded(child: _incomeStatBox('💵', '\$${(total / incomes.length).toStringAsFixed(0)}', 'promedio')),
                ]),
                const SizedBox(height: 20),
                // Barras por semana
                _weekBar('Semana 1', '1–7 Jul', '\$420', '6 trabajos · Regular', 0.6),
                _weekBar('Semana 2', '8–14 Jul', '\$580', '8 trabajos · Muy bien', 0.82),
                _weekBar('Semana 3', '15–21 Jul', '\$310', '5 trabajos · Regular', 0.44),
                _weekBar('Semana 4', '22–31 Jul', '\$690', '9 trabajos · ¡Excelente!', 0.98),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text('MOVIMIENTOS', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          ...incomes.map((inc) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
            child: Row(
              children: [
                Container(width: 40, height: 40, decoration: const BoxDecoration(color: Color(0xFFFFEAD5), shape: BoxShape.circle), child: const Center(child: Text('💵', style: TextStyle(fontSize: 18)))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(inc.serviceTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('${inc.clientName} · ${inc.date.day}/${inc.date.month}/${inc.date.year}', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                  ]),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('+\$${inc.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF047857), fontSize: 15)),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(8)), child: Text(inc.paymentStatus, style: const TextStyle(color: Color(0xFF047857), fontSize: 10, fontWeight: FontWeight.bold))),
                ]),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _incomeStatBox(String icon, String val, String lbl) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: const Color(0xFFFFEAD5), borderRadius: BorderRadius.circular(16)),
      child: Column(children: [Text(icon, style: const TextStyle(fontSize: 16)), const SizedBox(height: 4), Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))), Text(lbl, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)))]),
    );
  }

  Widget _weekBar(String sem, String dates, String amount, String status, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF7F7F2), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('$sem ($dates)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600), fontSize: 15)),
          ]),
          const SizedBox(height: 2),
          Align(alignment: Alignment.centerRight, child: Text(status, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)))),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFFEBEBE6), color: const Color(0xFFFF6600), borderRadius: BorderRadius.circular(6), minHeight: 8),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 7: PERFIL (sección 5.1)
  // ─────────────────────────────────────────────
  Widget _buildPerfilTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MI PERFIL', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF6600), Color(0xFFFF8533)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withAlpha(50), borderRadius: BorderRadius.circular(12)), child: const Text('🛡️ Verificado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                      const SizedBox(width: 8),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF10B981).withAlpha(80), borderRadius: BorderRadius.circular(12)), child: const Text('⚡ Disponible', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                    ]),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withAlpha(40), foregroundColor: Colors.white, minimumSize: const Size(90, 32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                      onPressed: () {},
                      child: const Text('✏ Editar', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(children: [
                  const CircleAvatar(radius: 34, backgroundColor: Colors.white, child: Text('CM', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFF6600)))),
                  const SizedBox(width: 14),
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Carlos Mendoza', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Electricista Certificado', style: TextStyle(color: Color(0xFFFFEAD5), fontSize: 13, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Row(children: [Icon(Icons.location_on_outlined, color: Colors.white, size: 13), SizedBox(width: 4), Text('Ciudad de México, Centro', style: TextStyle(color: Colors.white, fontSize: 11))]),
                    Row(children: [Icon(Icons.phone_outlined, color: Colors.white, size: 13), SizedBox(width: 4), Text('+52 55 1234 5678', style: TextStyle(color: Colors.white, fontSize: 11))]),
                  ]),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  ...List.generate(5, (i) => const Icon(Icons.star_rounded, color: Colors.white, size: 16)),
                  const SizedBox(width: 6),
                  const Text('4.9 · 124 reseñas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ]),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _workerStatCard('🏅', '8 años', 'Experiencia')),
            const SizedBox(width: 12),
            Expanded(child: _workerStatCard('✅', '127', 'Trabajos realizados')),
          ]),

          const SizedBox(height: 20),
          const Text('SOBRE MÍ', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
            child: const Text('Soluciono cortos circuitos, instalo cableado nuevo y hago mantenimiento preventivo.', style: TextStyle(color: Color(0xFF4B5563), height: 1.5)),
          ),

          const SizedBox(height: 20),
          const Text('CERTIFICACIONES', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['🛡 Licencia Tipo A', '🛡 Alta Tensión'].map((c) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFFFEAD5), borderRadius: BorderRadius.circular(16)),
              child: Text(c, style: const TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 12)),
            )).toList(),
          ),

          const SizedBox(height: 20),
          const Text('DISPONIBILIDAD', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Estado actual', style: TextStyle(fontWeight: FontWeight.w600)),
              Switch(value: true, activeThumbColor: const Color(0xFFFF6600), onChanged: (_) {}),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _workerStatCard(String icon, String val, String lbl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
      child: Column(children: [Text(icon, style: const TextStyle(fontSize: 22)), const SizedBox(height: 4), Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF6600))), Text(lbl, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)), textAlign: TextAlign.center)]),
    );
  }
}
