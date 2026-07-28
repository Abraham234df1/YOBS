import 'package:flutter/material.dart';
import '../models/models.dart';

/// Pantalla de solicitar servicio — placeholder que ahora está integrada en worker_detail_screen.dart
/// Se mantiene para compatibilidad de imports.
class RequestFormScreen extends StatelessWidget {
  final WorkerProfile? worker;

  const RequestFormScreen({super.key, this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F2),
      appBar: AppBar(title: const Text('Solicitar Servicio')),
      body: const Center(child: Text('Usa el botón "Solicitar servicio" desde el perfil del trabajador.')),
    );
  }
}
