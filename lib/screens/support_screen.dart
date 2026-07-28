import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportItem {
  final String question;
  final String answer;
  bool isExpanded = false;
  _SupportItem({required this.question, required this.answer});
}

class _SupportScreenState extends State<SupportScreen> {
  final List<_SupportItem> _faqs = [
    _SupportItem(question: '¿Cómo creo una cuenta?', answer: 'Toca "Crear cuenta" en la pantalla de inicio, elige tu rol (cliente o trabajador) y completa el formulario de registro con tus datos.'),
    _SupportItem(question: '¿Cómo solicito un servicio?', answer: 'Entra al Inicio, busca el profesional que necesitas, abre su perfil y toca "Solicitar servicio". Llena el formulario con la descripción, dirección y urgencia del trabajo.'),
    _SupportItem(question: '¿Cómo cancelo una solicitud?', answer: 'Ve a la sección "Solicitudes", selecciona la solicitud que deseas cancelar y toca el botón "Cancelar". Solo puedes cancelar si la solicitud está en estado Pendiente o Aceptada.'),
    _SupportItem(question: '¿Cómo califico a un trabajador?', answer: 'Cuando el servicio esté finalizado, aparecerá en tu Historial con el botón "Calificar". Asigna una puntuación de 1 a 5 estrellas y escribe un comentario opcional.'),
    _SupportItem(question: '¿Cómo contacto al trabajador?', answer: 'Una vez que envíes una solicitud, el chat se habilita automáticamente en la sección "Mensajes". Puedes enviar texto, fotos y tu ubicación.'),
    _SupportItem(question: '¿Cómo veo mis ingresos como trabajador?', answer: 'En el menú inferior del Panel del Trabajador, toca la pestaña "Ingresos". Verás el total del mes, el desglose semanal y el historial de todos tus servicios cobrados.'),
    _SupportItem(question: '¿Es seguro YOBS?', answer: 'Sí. Todos los clientes pasan por verificación de identidad. Los trabajadores tienen certificaciones validadas. Todas las transacciones quedan registradas y puedes reportar cualquier problema desde la app.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F2),
      appBar: AppBar(
        title: const Text('Centro de Ayuda'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner de soporte
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFFF6600).withAlpha(50), shape: BoxShape.circle),
                    child: const Icon(Icons.support_agent_rounded, size: 32, color: Color(0xFFFF6600)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('¿Necesitas ayuda?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text('Soporte YOBS disponible 24/7.', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6600),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 36),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Conectando con un agente de soporte...')),
                            );
                          },
                          child: const Text('Contactar Soporte'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text('Preguntas Frecuentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            const SizedBox(height: 12),

            // FAQ List
            ..._faqs.asMap().entries.map((entry) {
              final i = entry.key;
              final faq = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: faq.isExpanded ? const Color(0xFFFF6600).withAlpha(60) : const Color(0xFFEBEBE6)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(faq.question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      trailing: Icon(faq.isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: const Color(0xFFFF6600)),
                      onTap: () => setState(() {
                        for (var j = 0; j < _faqs.length; j++) {
                          _faqs[j].isExpanded = j == i ? !faq.isExpanded : false;
                        }
                      }),
                    ),
                    if (faq.isExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(faq.answer, style: const TextStyle(color: Color(0xFF4B5563), height: 1.5, fontSize: 13)),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
