import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_data_service.dart';
import 'worker_detail_screen.dart';
import 'chat_screen.dart';
import 'payment_invoice_screen.dart';
import 'support_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  final VoidCallback onSwitchRole;

  const ClientHomeScreen({
    super.key,
    required this.onSwitchRole,
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
      _currentIndex = 1; // Switch to "Mis Solicitudes" tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111A20),
        title: const Row(
          children: [
            Icon(Icons.handyman_rounded, color: Color(0xFFFB7A01)),
            SizedBox(width: 8),
            Text(
              'YOBS',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SupportScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
            tooltip: 'Cambiar a modo Trabajador',
            onPressed: widget.onSwitchRole,
          ),
        ],
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFFB7A01), // Figma Primary Amber Orange
        unselectedItemColor: const Color(0xFF6E717F),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'Historial',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _buildCatalogTab();
      case 1:
        return _buildRequestsTab();
      case 2:
        return _buildChatTab();
      case 3:
        return _buildHistoryTab();
      default:
        return _buildCatalogTab();
    }
  }

  // --- TAB 1: CATÁLOGO DE SERVICIOS ---
  Widget _buildCatalogTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Promocional Figma (#111A20 & #FB7A01)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF111A20), Color(0xFF1E2A32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Servicios Laborales al Instante',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Encuentra profesionales verificados para tu hogar o negocio con garantía YOBS.',
                        style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.verified_user_rounded, color: Color(0xFFFB7A01), size: 44),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Buscador de servicios
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Buscar oficio, electricista, plomero, pintor...',
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFFB7A01)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Categorías con Íconos según diseño Figma
          const Text(
            'Categorías de Oficios',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111A20)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 105,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('all', 'Todos', Icons.apps_rounded, const Color(0xFF111A20)),
                ...MockDataService.categories.map((c) {
                  return _buildCategoryChip(c.id, c.title, c.icon, c.color);
                }),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Listado de Especialistas Recomendados
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Especialistas Recomendados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111A20)),
              ),
              Text(
                '${_filteredWorkers.length} disponibles',
                style: const TextStyle(color: Color(0xFF6E717F), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_filteredWorkers.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF6E717F)),
                  SizedBox(height: 8),
                  Text(
                    'No se encontraron especialistas en esta categoría.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF6E717F)),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredWorkers.length,
              itemBuilder: (ctx, idx) {
                final w = _filteredWorkers[idx];
                return _buildWorkerCard(w);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String id, String label, IconData icon, Color color) {
    final isSelected = _selectedCategoryId == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategoryId = id),
      child: Container(
        width: 88,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFB7A01) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFB7A01) : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFB7A01).withAlpha(80),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF111A20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerCard(WorkerProfile worker) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFFFB7A01).withAlpha(20),
                  child: Text(
                    worker.name.substring(0, 2).toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFFFB7A01),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF111A20)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        worker.mainTrade,
                        style: const TextStyle(color: Color(0xFF6E717F), fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${worker.rating}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            ' (${worker.totalJobs} trabajos)',
                            style: const TextStyle(color: Color(0xFF6E717F), fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${worker.hourlyRate.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFB7A01),
                      ),
                    ),
                    const Text('/hr', style: TextStyle(color: Color(0xFF6E717F), fontSize: 10)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF3E0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFFB7A01)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- TAB 2: SOLICITUDES ACTIVAS ---
  Widget _buildRequestsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Panel de Solicitudes Activas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111A20)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Seguimiento en tiempo real de tus contrataciones.',
            style: TextStyle(color: Color(0xFF6E717F), fontSize: 13),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: _myRequests.length,
              itemBuilder: (ctx, idx) {
                final req = _myRequests[idx];
                return _buildRequestCard(req);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(JobRequest req) {
    Color statusColor;
    String statusText;

    switch (req.status) {
      case RequestStatus.pendiente:
        statusColor = const Color(0xFFF59E0B);
        statusText = 'PENDIENTE';
        break;
      case RequestStatus.enProceso:
        statusColor = const Color(0xFF2563EB);
        statusText = 'EN PROCESO';
        break;
      case RequestStatus.finalizado:
        statusColor = const Color(0xFF10B981);
        statusText = 'FINALIZADO';
        break;
      case RequestStatus.cancelado:
        statusColor = const Color(0xFFEF4444);
        statusText = 'CANCELADO';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                req.id,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6E717F)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            req.serviceTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111A20)),
          ),
          const SizedBox(height: 4),
          Text(
            'Especialista: ${req.worker.name}',
            style: const TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            'Ubicación: ${req.address}',
            style: const TextStyle(color: Color(0xFF6E717F), fontSize: 12),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${req.estimatedCost.toStringAsFixed(0)} USD',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFB7A01)),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    label: const Text('Chat'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            title: req.worker.name,
                            messages: MockDataService.initialMessages,
                          ),
                        ),
                      );
                    },
                  ),
                  if (req.isPaid) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.receipt_rounded, color: Color(0xFFFB7A01)),
                      tooltip: 'Ver Comprobante',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentInvoiceScreen(request: req),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 3: CHAT INTEGRADO ---
  Widget _buildChatTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 1,
      itemBuilder: (ctx, idx) {
        final worker = MockDataService.workers[0];
        return ListTile(
          contentPadding: const EdgeInsets.all(12),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFFB7A01),
            child: Text(worker.name.substring(0, 1), style: const TextStyle(color: Colors.white)),
          ),
          title: Text(worker.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF111A20))),
          subtitle: const Text('Voy en camino, llego en 15 minutos...'),
          trailing: const Text('10:45 AM', style: TextStyle(color: Color(0xFF6E717F), fontSize: 11)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  title: worker.name,
                  messages: MockDataService.initialMessages,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- TAB 4: HISTORIAL DE CONTRATACIONES ---
  Widget _buildHistoryTab() {
    final finished = _myRequests.where((r) => r.status == RequestStatus.finalizado).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historial del Usuario',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111A20)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Servicios completados con opción de repetir contratación en 1-clic.',
            style: TextStyle(color: Color(0xFF6E717F), fontSize: 13),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: finished.isEmpty
                ? const Center(child: Text('No hay contrataciones finalizadas aún.'))
                : ListView.builder(
                    itemCount: finished.length,
                    itemBuilder: (ctx, idx) {
                      final item = finished[idx];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.serviceTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF111A20))),
                                Text('\$${item.estimatedCost.toStringAsFixed(0)} USD', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFB7A01))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Especialista: ${item.worker.name}', style: const TextStyle(color: Color(0xFF6E717F), fontSize: 12)),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF3E0),
                                foregroundColor: const Color(0xFFFB7A01),
                                minimumSize: const Size.fromHeight(40),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.replay_rounded, size: 18),
                              label: const Text('Repetir Contratación en 1-Clic'),
                              onPressed: () {
                                _addNewRequest(JobRequest(
                                  id: 'REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                                  serviceTitle: item.serviceTitle,
                                  worker: item.worker,
                                  clientName: item.clientName,
                                  date: DateTime.now(),
                                  address: item.address,
                                  description: item.description,
                                  estimatedCost: item.estimatedCost,
                                  paymentMethod: item.paymentMethod,
                                  status: RequestStatus.pendiente,
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('¡Contratación repetida con éxito!')),
                                );
                              },
                            ),
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
}
