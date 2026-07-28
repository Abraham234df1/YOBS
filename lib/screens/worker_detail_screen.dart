import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/order_database_service.dart';

class WorkerDetailScreen extends StatefulWidget {
  final WorkerProfile worker;
  final Function(JobRequest newRequest) onRequestCreated;

  const WorkerDetailScreen({
    super.key,
    required this.worker,
    required this.onRequestCreated,
  });

  @override
  State<WorkerDetailScreen> createState() => _WorkerDetailScreenState();
}

class _WorkerDetailScreenState extends State<WorkerDetailScreen> {
  void _showHiringDialog(BuildContext context) {
    final addressController = TextEditingController(text: 'Av. Las Palmas #450, Col. Jardines');
    final descController = TextEditingController();
    String selectedPayment = 'Tarjeta de Crédito';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Contratar a ${widget.worker.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tarifa estimada: \$${widget.worker.hourlyRate.toStringAsFixed(0)} USD/hr',
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dirección
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Dirección del trabajo',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Descripción
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Detalles o requerimientos del trabajo',
                        hintText: 'Ej. Necesito revisar el cableado del segundo piso...',
                        prefixIcon: const Icon(Icons.description_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Método de Pago
                    DropdownButtonFormField<String>(
                      initialValue: selectedPayment,
                      decoration: InputDecoration(
                        labelText: 'Método de pago preferido',
                        prefixIcon: const Icon(Icons.payment_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Tarjeta de Crédito',
                          child: Text('Tarjeta de Crédito / Débito'),
                        ),
                        DropdownMenuItem(
                          value: 'Transferencia bancaria',
                          child: Text('Transferencia bancaria (SPEI)'),
                        ),
                        DropdownMenuItem(
                          value: 'Efectivo',
                          child: Text('Efectivo al finalizar'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedPayment = val);
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        if (descController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor describe los detalles del servicio.')),
                          );
                          return;
                        }

                        final desc = descController.text;
                        final payment = selectedPayment;

                        Navigator.pop(ctx);
                        Navigator.pop(context);

                        // Guardar el pedido en MongoDB Database
                        final savedOrder = await OrderDatabaseService.createOrder(
                          worker: widget.worker,
                          clientName: 'Manuel López',
                          address: addressController.text,
                          description: desc,
                          paymentMethod: payment,
                        );

                        final newReq = JobRequest(
                          id: savedOrder?.orderId ?? 'REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                          serviceTitle: widget.worker.mainTrade,
                          worker: widget.worker,
                          clientName: 'Manuel López',
                          date: DateTime.now(),
                          address: addressController.text,
                          description: desc,
                          estimatedCost: widget.worker.hourlyRate * 2,
                          paymentMethod: payment,
                          status: RequestStatus.pendiente,
                          isPaid: true,
                        );

                        widget.onRequestCreated(newReq);
                      },
                      child: const Text(
                        'Confirmar y Enviar Solicitud',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final worker = widget.worker;

    return Scaffold(
      appBar: AppBar(
        title: Text(worker.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: const Color(0xFF2563EB).withAlpha(30),
                    child: Text(
                      worker.name.substring(0, 2).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
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
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          worker.mainTrade,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${worker.rating}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' (${worker.totalJobs} trabajos)',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.work_history_outlined,
                    title: 'Experiencia',
                    value: '${worker.experienceYears} años',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.attach_money_rounded,
                    title: 'Tarifa Estimada',
                    value: '\$${worker.hourlyRate.toStringAsFixed(0)}/hr',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bio
            const Text(
              'Acerca del Especialista',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              worker.bio,
              style: const TextStyle(color: Color(0xFF475569), height: 1.5),
            ),

            const SizedBox(height: 24),

            // Certificaciones
            const Text(
              'Certificaciones y Licencias',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              children: worker.certifications.map((cert) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          cert,
                          style: const TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Trabajos Anteriores / Fotos
            const Text(
              'Galería de Trabajos Realizados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: worker.workPhotos.length,
                itemBuilder: (ctx, idx) {
                  final photo = worker.workPhotos[idx];
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.photo_library_rounded, color: Color(0xFF2563EB), size: 30),
                        const SizedBox(height: 8),
                        Text(
                          photo,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Reseñas de Clientes
            const Text(
              'Opiniones de Clientes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              children: worker.reviews.map((rev) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            rev.clientName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < rev.rating ? Icons.star_rounded : Icons.star_border_rounded,
                                color: const Color(0xFFF59E0B),
                                size: 16,
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        rev.comment,
                        style: const TextStyle(color: Color(0xFF475569), fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        rev.date,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.send_rounded),
          label: const Text(
            'Contratar / Enviar Solicitud',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _showHiringDialog(context),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
