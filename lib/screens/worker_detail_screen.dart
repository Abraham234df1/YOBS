import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../services/order_database_service.dart';
import 'chat_screen.dart';

/// Pantalla de detalle del perfil público de un trabajador (sección 4.4 del doc)
/// y formulario de solicitud de servicio (sección 4.5 del doc).
class WorkerDetailScreen extends StatefulWidget {
  final WorkerProfile worker;
  final Function(JobRequest) onRequestCreated;

  const WorkerDetailScreen({
    super.key,
    required this.worker,
    required this.onRequestCreated,
  });

  @override
  State<WorkerDetailScreen> createState() => _WorkerDetailScreenState();
}

class _WorkerDetailScreenState extends State<WorkerDetailScreen> {
  void _openRequestForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RequestFormSheet(
        worker: widget.worker,
        onSubmit: (req) {
          widget.onRequestCreated(req);
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFFFF6600),
              content: Text('✅ Solicitud enviada. El trabajador recibirá una notificación.'),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.worker;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F2),
      body: CustomScrollView(
        slivers: [
          // AppBar con avatar y nombre
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: Colors.white,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6600), Color(0xFFFF8533)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white,
                      child: Text(
                        w.name.substring(0, 2).toUpperCase(),
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFF6600)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(w.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(w.mainTrade, style: const TextStyle(color: Color(0xFFFFEAD5), fontSize: 14)),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges de verificación y disponibilidad
                  Row(
                    children: [
                      if (w.isVerified) _badge('🛡️ Verificado', const Color(0xFFFFEAD5), const Color(0xFFFF6600)),
                      const SizedBox(width: 8),
                      if (w.isAvailable) _badge('⚡ Disponible', const Color(0xFFD1FAE5), const Color(0xFF047857)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Rating y reseñas
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEBEBE6))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem('⭐', '${w.rating}', 'Calificación'),
                        _divider(),
                        _statItem('💬', '${w.reviewCount}', 'Reseñas'),
                        _divider(),
                        _statItem('🏅', '${w.experienceYears} años', 'Experiencia'),
                        _divider(),
                        _statItem('📍', '${w.distanceKm} km', 'Distancia'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Información de contacto
                  _sectionTitle('CONTACTO'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
                    child: Column(
                      children: [
                        _contactRow(Icons.location_on_outlined, w.city),
                        const Divider(height: 16),
                        _contactRow(Icons.phone_outlined, w.phone),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Descripción / Sobre mí
                  _sectionTitle('SOBRE MÍ'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
                    child: Text(w.bio, style: const TextStyle(color: Color(0xFF4B5563), height: 1.5)),
                  ),

                  // Tarifas
                  const SizedBox(height: 20),
                  _sectionTitle('TARIFA'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_money_rounded, color: Color(0xFFFF6600)),
                        const SizedBox(width: 10),
                        Text('\$${w.hourlyRate.toStringAsFixed(0)} / hora aprox.', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF111827))),
                      ],
                    ),
                  ),

                  // Certificaciones
                  if (w.certifications.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _sectionTitle('CERTIFICACIONES'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: w.certifications.map((c) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: const Color(0xFFFFEAD5), borderRadius: BorderRadius.circular(16)),
                        child: Text('🛡 $c', style: const TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 12)),
                      )).toList(),
                    ),
                  ],

                  // Reseñas recientes
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionTitle('RESEÑAS RECIENTES'),
                      Row(children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFFF6600), size: 16),
                        Text(' ${w.rating}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600))),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...MockDataService.workerReviews.map((rev) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(radius: 16, backgroundColor: const Color(0xFFFF6600).withAlpha(20), child: Text(rev.clientName.substring(0, 2), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFFF6600)))),
                            const SizedBox(width: 10),
                            Expanded(child: Text(rev.clientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                            Row(children: List.generate(5, (i) => Icon(i < rev.rating ? Icons.star_rounded : Icons.star_outline_rounded, color: const Color(0xFFFF6600), size: 13))),
                            const SizedBox(width: 6),
                            Text('${rev.date.day}/${rev.date.month}', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(rev.comment, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12)),
                      ],
                    ),
                  )),

                  const SizedBox(height: 100), // Espacio para el botón flotante
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEBEBE6)))),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0EFE6),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFEBEBE6)),
              ),
              child: IconButton(
                icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF111827)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(title: widget.worker.name, messages: MockDataService.initialMessages))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _openRequestForm,
                icon: const Icon(Icons.send_rounded, size: 20),
                label: const Text('Solicitar servicio'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color bg, Color textColor) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
    child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
  );

  Widget _statItem(String emoji, String value, String label) => Column(
    children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFFF6600))),
      Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
    ],
  );

  Widget _divider() => Container(width: 1, height: 40, color: const Color(0xFFEBEBE6));

  Widget _sectionTitle(String t) => Text(t, style: const TextStyle(color: Color(0xFFFF6600), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.2));

  Widget _contactRow(IconData icon, String text) => Row(
    children: [Icon(icon, color: const Color(0xFFFF6600), size: 18), const SizedBox(width: 10), Text(text, style: const TextStyle(color: Color(0xFF111827), fontSize: 13))],
  );
}

/// Formulario de solicitud de servicio (sección 4.5 del documento de lógica)
class _RequestFormSheet extends StatefulWidget {
  final WorkerProfile worker;
  final Function(JobRequest) onSubmit;

  const _RequestFormSheet({required this.worker, required this.onSubmit});

  @override
  State<_RequestFormSheet> createState() => _RequestFormSheetState();
}

class _RequestFormSheetState extends State<_RequestFormSheet> {
  final _descCtrl = TextEditingController();
  final _addressCtrl = TextEditingController(text: 'Av. Insurgentes 241, Col. Roma');
  UrgencyLevel _urgency = UrgencyLevel.normal;
  bool _isLoading = false;

  void _submit() async {
    if (_descCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor describe el servicio que necesitas.')));
      return;
    }

    setState(() => _isLoading = true);

    final newReq = JobRequest(
      id: 'REQ-${DateTime.now().millisecondsSinceEpoch}',
      worker: widget.worker,
      serviceTitle: widget.worker.mainTrade,
      description: _descCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      requestedDate: DateTime.now().add(const Duration(hours: 2)),
      urgency: _urgency,
      estimatedPrice: widget.worker.hourlyRate,
      status: RequestStatus.pendiente,
    );

    // Guardar en MongoDB
    await OrderDatabaseService.createOrder(newReq);

    if (!mounted) return;
    setState(() => _isLoading = false);
    widget.onSubmit(newReq);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),

            Text('Solicitar a ${widget.worker.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            Text(widget.worker.mainTrade, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),

            const SizedBox(height: 20),

            const Text('Descripción del problema *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
            const SizedBox(height: 6),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Describe el servicio que necesitas con detalle...'),
            ),

            const SizedBox(height: 16),

            const Text('Dirección del servicio *', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
            const SizedBox(height: 6),
            TextField(
              controller: _addressCtrl,
              decoration: const InputDecoration(
                hintText: 'Ingresa la dirección donde necesitas el servicio',
                prefixIcon: Icon(Icons.location_on_outlined, color: Color(0xFF6B7280)),
              ),
            ),

            const SizedBox(height: 16),

            const Text('Nivel de urgencia', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827))),
            const SizedBox(height: 8),
            Row(
              children: [
                _urgencyOption('Normal', UrgencyLevel.normal),
                const SizedBox(width: 8),
                _urgencyOption('🔴 Urgente', UrgencyLevel.urgente),
                const SizedBox(width: 8),
                _urgencyOption('⚡ Hoy mismo', UrgencyLevel.hoyMismo),
              ],
            ),

            const SizedBox(height: 16),

            // Resumen
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFEBEBE6))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Precio estimado:', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text('\$${widget.worker.hourlyRate.toStringAsFixed(0)} aprox.', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6600), fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send_rounded),
              label: Text(_isLoading ? 'Enviando...' : 'Enviar solicitud'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _urgencyOption(String label, UrgencyLevel level) {
    final isSelected = _urgency == level;
    return GestureDetector(
      onTap: () => setState(() => _urgency = level),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6600) : const Color(0xFFF0EFE6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? const Color(0xFFFF6600) : const Color(0xFFEBEBE6)),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF6B7280), fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}
