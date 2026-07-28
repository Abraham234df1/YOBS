import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../widgets/yobs_logo_widget.dart';
import 'worker_detail_screen.dart';
import 'chat_screen.dart';
import 'payment_invoice_screen.dart';

/// Pantalla principal del cliente según secciones 4.x del documento de lógica.
/// Navegación: Inicio | Solicitudes | Mensajes | Historial | Perfil
class ClientHomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const ClientHomeScreen({super.key, required this.onLogout});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _currentIndex = 0;
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  double _minRating = 0;

  final List<WorkerProfile> _workers = List.from(MockDataService.workers);
  final List<JobRequest> _myRequests = List.from(MockDataService.initialRequests);

  List<WorkerProfile> get _filteredWorkers {
    return _workers.where((w) {
      final matchesCategory = _selectedCategoryId == 'all' || w.categoryId == _selectedCategoryId;
      final matchesSearch = _searchQuery.isEmpty ||
          w.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          w.mainTrade.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRating = w.rating >= _minRating;
      return matchesCategory && matchesSearch && matchesRating;
    }).toList();
  }

  void _onRequestCreated(JobRequest req) {
    setState(() {
      _myRequests.insert(0, req);
      _currentIndex = 1; // Ir a Solicitudes
    });
  }

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
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment_rounded), label: 'Solicitudes'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), activeIcon: Icon(Icons.chat_bubble_rounded), label: 'Mensajes'),
          BottomNavigationBarItem(icon: Icon(Icons.history_toggle_off_rounded), activeIcon: Icon(Icons.history_rounded), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0: return _buildInicioTab();
      case 1: return _buildSolicitudesTab();
      case 2: return _buildMensajesTab();
      case 3: return _buildHistorialTab();
      case 4: return _buildPerfilTab();
      default: return _buildInicioTab();
    }
  }

  // ─────────────────────────────────────────────
  // TAB 1: INICIO (secciones 4.2 y 4.3)
  // ─────────────────────────────────────────────
  Widget _buildInicioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ubicación actual
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ubicación actual', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                  const SizedBox(height: 2),
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Color(0xFFFF6600), size: 18),
                      SizedBox(width: 4),
                      Text('Ciudad de México, Centro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111827))),
                    ],
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFFF6600),
                child: Text('CM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Barra de búsqueda + filtros
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: '¿Qué servicio necesitas?',
                    prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6B7280)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _buildFilterButton(),
            ],
          ),

          const SizedBox(height: 20),

          // Categorías (sección 4.2)
          const Text('Categorías', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryItem('all', 'Todos', '🔍'),
                ...MockDataService.categories.map((c) => _buildCategoryItem(c.id, c.title, c.icon)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Mapa representacional (sección 4.2)
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEDECE4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEBEBE6)),
            ),
            child: Stack(
              children: [
                const Center(child: Icon(Icons.map_rounded, size: 56, color: Color(0xFFCCCCC0))),
                Positioned(
                  top: 10, left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(18), blurRadius: 6)]),
                    child: const Row(
                      children: [
                        Icon(Icons.location_on_rounded, color: Color(0xFFFF6600), size: 14),
                        SizedBox(width: 4),
                        Text('Todos los profesionales · 7', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Trabajadores disponibles (sección 4.3)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_filteredWorkers.length} profesionales disponibles',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_filteredWorkers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: Color(0xFFCCCCC0)),
                    SizedBox(height: 12),
                    Text('No se encontraron profesionales con esos filtros.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF6B7280))),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredWorkers.length,
              itemBuilder: (ctx, i) => _buildWorkerCard(_filteredWorkers[i]),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: _showFilterSheet,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFEBEBE6)),
        ),
        child: const Icon(Icons.tune_rounded, color: Color(0xFF111827)),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filtros', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Calificación mínima', style: TextStyle(fontWeight: FontWeight.w600)),
              Slider(
                value: _minRating,
                min: 0, max: 5, divisions: 10,
                activeColor: const Color(0xFFFF6600),
                label: '${_minRating.toStringAsFixed(1)} ★',
                onChanged: (v) { setModalState(() => _minRating = v); setState(() => _minRating = v); },
              ),
              const SizedBox(height: 8),
              Row(
                children: ['4.0+', '4.5+', '4.9+'].map((r) {
                  final val = double.parse(r.replaceAll('+', ''));
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text('★ $r'),
                      selected: _minRating == val,
                      selectedColor: const Color(0xFFFFEAD5),
                      onSelected: (_) { setModalState(() => _minRating = val); setState(() => _minRating = val); },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Aplicar filtros')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String id, String label, String emoji) {
    final isSelected = _selectedCategoryId == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryId = id),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF6600) : const Color(0xFFF0EFE6),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? const Color(0xFFFF6600) : const Color(0xFF111827)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerCard(WorkerProfile worker) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEBEBE6))),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WorkerDetailScreen(worker: worker, onRequestCreated: _onRequestCreated))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFFF6600).withAlpha(20),
              child: Text(worker.name.substring(0, 2).toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF6600))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(worker.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFFFEAD5), borderRadius: BorderRadius.circular(12)),
                        child: Row(children: [const Icon(Icons.star_rounded, color: Color(0xFFFF6600), size: 13), const SizedBox(width: 2), Text('${worker.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFFFF6600)))]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(worker.mainTrade, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(worker.bio, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 11)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _chip('\$${worker.hourlyRate.toStringAsFixed(0)}', const Color(0xFFF0EFE6)),
                      const SizedBox(width: 6),
                      _chip('📍 ${worker.distanceKm} km', const Color(0xFFF0EFE6)),
                      const SizedBox(width: 6),
                      if (worker.isVerified) _chip('🛡️ Verificado', const Color(0xFFFFEAD5)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color bg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
    child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
  );

  // ─────────────────────────────────────────────
  // TAB 2: SOLICITUDES (sección 4.6)
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
              const Text('RECIENTES', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
              const SizedBox(height: 2),
              Text('Mis Solicitudes (${_myRequests.length})', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            ],
          ),
        ),
        Expanded(
          child: _myRequests.isEmpty
              ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.assignment_outlined, size: 56, color: Color(0xFFCCCCC0)), SizedBox(height: 12), Text('No tienes solicitudes aún.', style: TextStyle(color: Color(0xFF6B7280)))]))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _myRequests.length,
                  itemBuilder: (ctx, i) => _buildRequestCard(_myRequests[i], i),
                ),
        ),
      ],
    );
  }

  Widget _buildRequestCard(JobRequest req, int index) {
    final Color statusColor;
    final Color statusBg;
    switch (req.status) {
      case RequestStatus.aceptada:
      case RequestStatus.confirmada:
      case RequestStatus.enProceso:
        statusColor = const Color(0xFF047857); statusBg = const Color(0xFFD1FAE5);
      case RequestStatus.rechazada:
      case RequestStatus.cancelada:
        statusColor = const Color(0xFFEF4444); statusBg = const Color(0xFFFEE2E2);
      case RequestStatus.pendienteDeCalificacion:
        statusColor = const Color(0xFF92400E); statusBg = const Color(0xFFFEF3C7);
      default:
        statusColor = const Color(0xFFD97706); statusBg = const Color(0xFFFEF3C7);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEBEBE6))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(req.serviceTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(14)),
                child: Text(req.statusLabel, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('${req.worker.name} • ${req.urgency == UrgencyLevel.urgente ? "🔴 Urgente" : "Normal"}', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
          Text(req.address, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
          const SizedBox(height: 8),
          Row(
            children: [
              _chip('\$${req.estimatedPrice.toStringAsFixed(0)} estimado', const Color(0xFFFFEAD5)),
            ],
          ),

          // Código de confirmación si está aceptada
          if (req.status == RequestStatus.aceptada && req.confirmationCode != null) ...[
            const Divider(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF7F7F2), borderRadius: BorderRadius.circular(14)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(children: [Icon(Icons.shield_outlined, color: Color(0xFFFF6600), size: 18), SizedBox(width: 8), Text('Código de llegada', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))]),
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: const Color(0xFF111827), content: Text('Código YOBS: ${req.confirmationCode}', style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)))),
                    child: const Text('Mostrar', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Acciones según estado
          Row(
            children: [
              if (req.canChat)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(title: req.worker.name, messages: MockDataService.initialMessages))),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    label: const Text('Mensaje', style: TextStyle(fontSize: 13)),
                  ),
                ),
              if (req.canChat) const SizedBox(width: 10),
              if (req.canCancel)
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFEF4444), side: const BorderSide(color: Color(0xFFEF4444))),
                    onPressed: () => _cancelRequest(index),
                    child: const Text('Cancelar', style: TextStyle(fontSize: 13)),
                  ),
                ),
              if (req.needsRating)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showRatingDialog(req),
                    icon: const Icon(Icons.star_outline_rounded, size: 16),
                    label: const Text('Calificar', style: TextStyle(fontSize: 13)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _cancelRequest(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Cancelar solicitud?'),
        content: const Text('¿Estás seguro de que deseas cancelar esta solicitud?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No, mantener')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              setState(() => _myRequests[index].status = RequestStatus.cancelada);
              Navigator.pop(ctx);
            },
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(JobRequest req) {
    double rating = 4.0;
    final commentCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Calificar a ${req.worker.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatefulBuilder(
              builder: (ctx, setSt) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => GestureDetector(
                  onTap: () => setSt(() => rating = i + 1.0),
                  child: Icon(i < rating ? Icons.star_rounded : Icons.star_outline_rounded, color: const Color(0xFFFF6600), size: 32),
                )),
              ),
            ),
            const SizedBox(height: 12),
            TextField(controller: commentCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Escribe un comentario (opcional)...')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() => req.status = RequestStatus.calificada);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Color(0xFFFF6600), content: Text('¡Gracias por calificar el servicio!')));
            },
            child: const Text('Enviar calificación'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB 3: MENSAJES (sección 4.7)
  // ─────────────────────────────────────────────
  Widget _buildMensajesTab() {
    final activeChats = _myRequests.where((r) => r.canChat).toList();
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
              Text('Conversaciones (${activeChats.length})', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(decoration: const InputDecoration(hintText: 'Buscar conversación', prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF6B7280)))),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: activeChats.isEmpty
              ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.chat_bubble_outline_rounded, size: 56, color: Color(0xFFCCCCC0)), SizedBox(height: 12), Text('No tienes conversaciones activas.', style: TextStyle(color: Color(0xFF6B7280)))]))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: activeChats.length,
                  itemBuilder: (ctx, i) {
                    final req = activeChats[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEBEBE6))),
                      child: ListTile(
                        leading: Stack(children: [
                          CircleAvatar(backgroundColor: const Color(0xFFFF6600).withAlpha(20), child: Text(req.worker.name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600)))),
                          const Positioned(right: 0, bottom: 0, child: CircleAvatar(radius: 5, backgroundColor: Color(0xFF10B981))),
                        ]),
                        title: Text(req.worker.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(req.serviceTitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                        trailing: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Color(0xFFFF6600), shape: BoxShape.circle), child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(title: req.worker.name, messages: MockDataService.initialMessages))),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // TAB 4: HISTORIAL (sección 4.10)
  // ─────────────────────────────────────────────
  Widget _buildHistorialTab() {
    final finished = _myRequests.where((r) =>
        r.status == RequestStatus.finalizada ||
        r.status == RequestStatus.pendienteDeCalificacion ||
        r.status == RequestStatus.calificada).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('HISTORIAL', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2)),
              const SizedBox(height: 2),
              Text('Servicios finalizados (${finished.length})', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            ],
          ),
        ),
        Expanded(
          child: finished.isEmpty
              ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.history_rounded, size: 56, color: Color(0xFFCCCCC0)), SizedBox(height: 12), Text('Aquí aparecerán tus servicios completados.', style: TextStyle(color: Color(0xFF6B7280)))]))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: finished.length,
                  itemBuilder: (ctx, i) {
                    final req = finished[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEBEBE6))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(req.serviceTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                              Text('\$${(req.finalPrice ?? req.estimatedPrice).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600), fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('${req.worker.name} • ${req.address}', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (req.needsRating)
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _showRatingDialog(req),
                                    icon: const Icon(Icons.star_outline_rounded, size: 16),
                                    label: const Text('Calificar servicio', style: TextStyle(fontSize: 13)),
                                  ),
                                ),
                              if (req.status == RequestStatus.calificada)
                                const Expanded(child: Center(child: Text('✅ Calificado', style: TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold)))),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentInvoiceScreen(request: req))),
                                  icon: const Icon(Icons.receipt_long_outlined, size: 16),
                                  label: const Text('Ver recibo', style: TextStyle(fontSize: 13)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // TAB 5: PERFIL (sección 4.11)
  // ─────────────────────────────────────────────
  Widget _buildPerfilTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFF6600), Color(0xFFFF8533)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withAlpha(50), borderRadius: BorderRadius.circular(12)), child: const Text('🛡️ Verificado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withAlpha(40), foregroundColor: Colors.white, minimumSize: const Size(110, 36), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                      onPressed: () {},
                      child: const Text('✏ Editar perfil', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const CircleAvatar(radius: 36, backgroundColor: Colors.white, child: Text('JD', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF6600)))),
                const SizedBox(height: 10),
                const Text('Juan Díaz', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Miembro desde 2026', style: TextStyle(color: Color(0xFFFFEAD5), fontSize: 12)),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _profileRow(Icons.email_outlined, 'CORREO', 'juan.diaz@correo.com'),
          const SizedBox(height: 10),
          _profileRow(Icons.phone_outlined, 'TELÉFONO', '+52 55 9876 5432'),
          const SizedBox(height: 10),
          _profileRow(Icons.location_on_outlined, 'DIRECCIÓN', 'Centro Histórico, Ciudad de México'),

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _statBox('🏠', '${_myRequests.length}', 'Servicios contratados')),
              const SizedBox(width: 12),
              Expanded(child: _statBox('⭐', '4.8', 'Reputación como cliente')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileRow(IconData icon, String title, String value) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
    child: Row(children: [Icon(icon, color: const Color(0xFFFF6600)), const SizedBox(width: 14), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.bold)), const SizedBox(height: 2), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF111827)))])]),
  );

  Widget _statBox(String emoji, String main, String sub) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
    child: Column(children: [Text(emoji, style: const TextStyle(fontSize: 24)), const SizedBox(height: 6), Text(main, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))), Text(sub, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)))]),
  );
}
