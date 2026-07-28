import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../widgets/yobs_logo_widget.dart';
import 'worker_detail_screen.dart';
import 'chat_screen.dart';
import 'payment_invoice_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const ClientHomeScreen({
    super.key,
    required this.onLogout,
  });

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _currentIndex = 0;
  String _selectedCategoryId = 'all';
  String _searchQuery = '';

  final List<WorkerProfile> _workers = List.from(MockDataService.workers);
  final List<JobRequest> _myRequests = List.from(MockDataService.requests);

  List<WorkerProfile> get _filteredWorkers {
    return _workers.where((w) {
      final matchesCategory = _selectedCategoryId == 'all' || w.categoryId == _selectedCategoryId;
      final matchesSearch = w.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          w.mainTrade.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _addNewRequest(JobRequest newRequest) {
    setState(() {
      _myRequests.insert(0, newRequest);
      _currentIndex = 1; // Switch to "Solicitudes" tab
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
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off_rounded),
            activeIcon: Icon(Icons.history_rounded),
            label: 'Historial',
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
        return _buildInicioTab();
      case 1:
        return _buildSolicitudesTab();
      case 2:
        return _buildChatsTab();
      case 3:
        return _buildHistorialTab();
      case 4:
        return _buildPerfilTab();
      default:
        return _buildInicioTab();
    }
  }

  // --- TAB 1: INICIO (Figma Image 5 & 6) ---
  Widget _buildInicioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ubicación actual Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ubicación actual', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Color(0xFFFF6600), size: 18),
                      const SizedBox(width: 4),
                      const Text(
                        'Ciudad de México, Centro',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111827)),
                      ),
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

          // Search Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: '¿Qué servicio necesitas?',
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6B7280)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: const BorderSide(color: Color(0xFFEBEBE6)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: const BorderSide(color: Color(0xFFEBEBE6)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFEBEBE6)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune_rounded, color: Color(0xFF111827)),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Categorías Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categorías',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Ver todas ↓',
                  style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Categorías Circular Icons (Figma Image 5)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryCircle('cat_electricidad', 'Electricidad', Icons.bolt_rounded),
              _buildCategoryCircle('cat_plomeria', 'Plomería', Icons.water_drop_rounded),
              _buildCategoryCircle('cat_construccion', 'Construcción', Icons.build_rounded),
            ],
          ),

          const SizedBox(height: 24),

          // Map View Card Representation (Figma Image 5)
          Container(
            height: 180,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDECE4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEBEBE6)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_rounded, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 6),
                      Text('Mapa de Profesionales Cercanos', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                // Floating Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 6)],
                    ),
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

          // Listado de Profesionales (Figma Image 6)
          const Text(
            'Encuentra el oficio correcto para hoy.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredWorkers.length,
            itemBuilder: (ctx, idx) {
              return _buildWorkerCard(_filteredWorkers[idx]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCircle(String id, String label, IconData icon) {
    final isSelected = _selectedCategoryId == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryId = isSelected ? 'all' : id),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFF6600) : const Color(0xFFF0EFE6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFFFF6600),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerCard(WorkerProfile worker) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBEBE6)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WorkerDetailScreen(
                  worker: worker,
                  onRequestCreated: _addNewRequest,
                ),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFFFF6600).withAlpha(20),
                child: Text(
                  worker.name.substring(0, 2).toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFFF6600)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(worker.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEAD5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFFF6600), size: 14),
                              const SizedBox(width: 2),
                              Text('${worker.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFFF6600))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(worker.mainTrade, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(worker.bio, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EFE6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('\$${worker.hourlyRate.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        const Text('📍 2.5 km', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                        const SizedBox(width: 8),
                        const Text('🛡️ Verificado', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
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

  // --- TAB 2: SOLICITUDES (Figma Image 9) ---
  Widget _buildSolicitudesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mis Solicitudes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 2),
          const Text('RECIENTES', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: _myRequests.length,
              itemBuilder: (ctx, idx) {
                final req = _myRequests[idx];
                final isAccepted = req.status == RequestStatus.enProceso || req.status == RequestStatus.finalizado;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
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
                          Text(req.serviceTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isAccepted ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              isAccepted ? '✓ Aceptado' : '🕒 Pendiente',
                              style: TextStyle(
                                color: isAccepted ? const Color(0xFF047857) : const Color(0xFFD97706),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${req.worker.name} • Hoy', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF6B7280)),
                          SizedBox(width: 4),
                          Text('5:00 PM', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                          SizedBox(width: 12),
                          Text('Por trabajo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF111827))),
                        ],
                      ),
                      if (isAccepted) ...[
                        const Divider(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.shield_outlined, color: Color(0xFFFF6600), size: 18),
                                  SizedBox(width: 8),
                                  Text('Código de confirmación de llegada', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Código de Seguridad YOBS: 8492')),
                                  );
                                },
                                child: const Text('Mostrar', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: CHATS (Figma Image 8 & 14) ---
  Widget _buildChatsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MENSAJES', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 2),
          const Text('Conversaciones 💬', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 14),

          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar conversación',
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF6B7280)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(color: Color(0xFFEBEBE6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(color: Color(0xFFEBEBE6)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: _workers.length,
              itemBuilder: (ctx, idx) {
                final w = _workers[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEBEBE6)),
                  ),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFF6600).withAlpha(20),
                          child: Text(w.name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600))),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(w.mainTrade, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                    trailing: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6600),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            title: w.name,
                            messages: MockDataService.initialMessages,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: HISTORIAL (Figma Image 7) ---
  Widget _buildHistorialTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HISTORIAL', style: TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                  SizedBox(height: 2),
                  Text('Servicios finalizados', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                ],
              ),
              const Text('2 servicios', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView(
              children: [
                _buildHistorialCard('Electricista Certificado', 'Carlos Mendoza • Mañana', 'Por trabajo', () {}),
                _buildHistorialCard('Limpieza', 'Ana Martínez • 12 Oct 2023', '\$120', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialCard(String title, String subtitle, String priceTag, VoidCallback onRate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEAD5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(priceTag, style: const TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Gracias por calificar el servicio!')),
              );
            },
            icon: const Icon(Icons.star_outline_rounded, size: 18),
            label: const Text('Calificar servicio'),
          ),
          const SizedBox(height: 10),

          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentInvoiceScreen(request: MockDataService.requests[0]),
                  ),
                );
              },
              icon: const Icon(Icons.receipt_long_outlined, size: 16, color: Color(0xFF6B7280)),
              label: const Text('Ver recibo', style: TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 5: PERFIL (Figma Image 11) ---
  Widget _buildPerfilTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Banner Card
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('🛡️ Verificado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withAlpha(40),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(110, 36),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () {},
                      child: const Text('✏ Editar perfil', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Text('CM', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF6600))),
                ),
                const SizedBox(height: 10),
                const Text('Carlos Mendoza', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Miembro desde 2023', style: TextStyle(color: Color(0xFFFFEAD5), fontSize: 12)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _buildProfileItem(Icons.email_outlined, 'CORREO', 'juan.diaz@correo.com'),
          const SizedBox(height: 10),
          _buildProfileItem(Icons.phone_outlined, 'TELÉFONO', '+52 55 9876 5432'),
          const SizedBox(height: 10),
          _buildProfileItem(Icons.location_on_outlined, 'DIRECCIÓN', 'Centro Histórico, Ciudad de México'),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _buildProfileStatCard('🏠', '18', 'Servicios contratados')),
              const SizedBox(width: 12),
              Expanded(child: _buildProfileStatCard('⭐', '4.8', 'Reputación como cliente')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEBEBE6)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF6600)),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF111827))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStatCard(String emoji, String mainText, String subText) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEBEBE6)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(mainText, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          Text(subText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}
