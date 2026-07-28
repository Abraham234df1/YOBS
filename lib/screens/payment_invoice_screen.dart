import 'package:flutter/material.dart';
import '../models/models.dart';

class PaymentInvoiceScreen extends StatelessWidget {
  final JobRequest request;

  const PaymentInvoiceScreen({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final amount = request.finalPrice ?? request.estimatedPrice;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F2),
      appBar: AppBar(
        title: const Text('Comprobante de Servicio'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 15, offset: const Offset(0, 6))],
                border: Border.all(color: const Color(0xFFEBEBE6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: const Color(0xFFFFEAD5), shape: BoxShape.circle),
                          child: const Icon(Icons.receipt_long_rounded, color: Color(0xFFFF6600)),
                        ),
                        const SizedBox(width: 10),
                        const Text('Comprobante YOBS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ]),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(12)),
                        child: const Text('✅ PAGADO', style: TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  _row('Folio:', request.id),
                  _row('Fecha:', '${now.day}/${now.month}/${now.year}'),
                  _row('Especialista:', request.worker.name),
                  _row('Oficio:', request.worker.mainTrade),
                  _row('Servicio:', request.serviceTitle),
                  _row('Dirección:', request.address),
                  _row('Urgencia:', request.urgency == UrgencyLevel.urgente ? '🔴 Urgente' : request.urgency == UrgencyLevel.hoyMismo ? '⚡ Hoy mismo' : 'Normal'),
                  _row('Método de pago:', 'Efectivo'),

                  const Divider(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total del servicio:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('\$${amount.toStringAsFixed(2)} MXN', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF6600))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF111827),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              icon: const Icon(Icons.download_rounded),
              label: const Text('Descargar Comprobante PDF', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(backgroundColor: Color(0xFF10B981), content: Text('Comprobante PDF guardado en descargas.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
          Flexible(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111827)))),
        ],
      ),
    );
  }
}
