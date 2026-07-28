import '../models/models.dart';

/// Datos de ejemplo para demostración del MVP de YOBS.
/// Basado en los datos del documento Logica_de_uso_YOBS.md sección 12.
class MockDataService {
  static const List<ServiceCategory> categories = [
    ServiceCategory(id: 'cat_electricidad',  title: 'Electricidad',  icon: '⚡'),
    ServiceCategory(id: 'cat_plomeria',      title: 'Plomería',      icon: '🔧'),
    ServiceCategory(id: 'cat_construccion',  title: 'Construcción',  icon: '🏗️'),
    ServiceCategory(id: 'cat_limpieza',      title: 'Limpieza',      icon: '🧹'),
    ServiceCategory(id: 'cat_pintura',       title: 'Pintura',       icon: '🎨'),
    ServiceCategory(id: 'cat_mantenimiento', title: 'Mantenimiento', icon: '🛠️'),
  ];

  static final List<WorkerProfile> workers = [
    WorkerProfile(
      id: 'w1',
      name: 'Carlos Mendoza',
      mainTrade: 'Electricista Certificado',
      categoryId: 'cat_electricidad',
      bio: 'Soluciono cortos circuitos, instalo cableado nuevo y hago mantenimiento preventivo.',
      rating: 4.9,
      reviewCount: 124,
      hourlyRate: 350,
      experienceYears: 8,
      certifications: ['Licencia Tipo A', 'Especialista en Alta Tensión'],
      distanceKm: 1.2,
    ),
    WorkerProfile(
      id: 'w2',
      name: 'Roberto Sánchez',
      mainTrade: 'Plomero Profesional',
      categoryId: 'cat_plomeria',
      bio: 'Detección de fugas, instalación de tinacos, tuberías y sistemas hidráulicos.',
      rating: 4.7,
      reviewCount: 89,
      hourlyRate: 280,
      experienceYears: 5,
      certifications: ['Certificado IMSS'],
      distanceKm: 2.8,
    ),
    WorkerProfile(
      id: 'w3',
      name: 'Ana Martínez',
      mainTrade: 'Limpieza de hogar y oficinas',
      categoryId: 'cat_limpieza',
      bio: 'Limpieza profunda, organización, limpieza de muebles y ventanas.',
      rating: 4.8,
      reviewCount: 210,
      hourlyRate: 120,
      experienceYears: 3,
      certifications: [],
      distanceKm: 0.8,
    ),
    WorkerProfile(
      id: 'w4',
      name: 'Juan Ramírez',
      mainTrade: 'Pintor de interiores y exteriores',
      categoryId: 'cat_pintura',
      bio: 'Pintura con acabados profesionales, impermeabilización y texturizados.',
      rating: 4.6,
      reviewCount: 57,
      hourlyRate: 200,
      experienceYears: 6,
      certifications: [],
      distanceKm: 3.5,
    ),
    WorkerProfile(
      id: 'w5',
      name: 'Laura Nieto',
      mainTrade: 'Albañil y Remodeladora',
      categoryId: 'cat_construccion',
      bio: 'Remodelaciones, colocación de pisos, impermeabilización y obra civil.',
      rating: 4.5,
      reviewCount: 41,
      hourlyRate: 320,
      experienceYears: 10,
      certifications: ['Técnico en Construcción'],
      distanceKm: 4.1,
    ),
  ];

  /// Solicitudes del CLIENTE (para mostrar en Mis Solicitudes)
  static List<JobRequest> get initialRequests => [
    JobRequest(
      id: 'REQ-001',
      worker: workers[0],
      serviceTitle: 'Revisión de tablero eléctrico',
      description: 'El tablero eléctrico hace un ruido extraño y una fase parece estar fallando.',
      address: 'Av. Insurgentes 241, Col. Roma',
      requestedDate: DateTime.now().add(const Duration(hours: 3)),
      urgency: UrgencyLevel.normal,
      estimatedPrice: 150,
      status: RequestStatus.aceptada,
      confirmationCode: '8492',
    ),
    JobRequest(
      id: 'REQ-002',
      worker: workers[1],
      serviceTitle: 'Fuga de agua en cocina',
      description: 'Hay una fuga pequeña bajo el fregadero que está mojando el mueble.',
      address: 'Calle Durango 88, Col. Condesa',
      requestedDate: DateTime.now().add(const Duration(days: 1)),
      urgency: UrgencyLevel.urgente,
      estimatedPrice: 200,
      status: RequestStatus.pendiente,
    ),
  ];

  /// Solicitudes recibidas por el TRABAJADOR (para el Panel del Trabajador)
  static List<JobRequest> get workerRequests => [
    JobRequest(
      id: 'REQ-101',
      worker: workers[0],
      serviceTitle: 'Instalación de 3 enchufes en habitación',
      description: 'El cliente necesita 3 contactos nuevos y conexión a tierra en la habitación principal.',
      address: 'Av. Insurgentes 24, Col. Roma Norte',
      requestedDate: DateTime.now().add(const Duration(hours: 2)),
      urgency: UrgencyLevel.normal,
      estimatedPrice: 180,
      status: RequestStatus.pendiente,
    ),
    JobRequest(
      id: 'REQ-102',
      worker: workers[0],
      serviceTitle: 'Corto circuito en cocina',
      description: 'Se fue la luz en toda la cocina, posible corto en el panel.',
      address: 'Calle Durango 88, Col. Condesa',
      requestedDate: DateTime.now().add(const Duration(hours: 1)),
      urgency: UrgencyLevel.urgente,
      estimatedPrice: 250,
      status: RequestStatus.pendiente,
    ),
  ];

  /// Mensajes de ejemplo para el chat
  static final List<ChatMessage> initialMessages = [
    ChatMessage(
      id: 'msg1',
      senderId: 'client1',
      senderName: 'Tú',
      content: 'Hola Carlos, ¿puedes venir hoy en la tarde?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isFromClient: true,
    ),
    ChatMessage(
      id: 'msg2',
      senderId: 'w1',
      senderName: 'Carlos Mendoza',
      content: '¡Claro! Puedo estar a las 5pm. ¿Me puedes dar la dirección exacta?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      isFromClient: false,
    ),
    ChatMessage(
      id: 'msg3',
      senderId: 'client1',
      senderName: 'Tú',
      content: '¡Perfecto! Es en Av. Insurgentes 241, depto 3B.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      isFromClient: true,
    ),
    ChatMessage(
      id: 'msg4',
      senderId: 'w1',
      senderName: 'Carlos Mendoza',
      content: 'Anotado, ahí estaré puntual. 👍',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isFromClient: false,
    ),
  ];

  /// Ingresos del trabajador (para la pantalla de Ingresos)
  static final List<IncomeRecord> workerIncomes = [
    IncomeRecord(id: 'INC-001', serviceId: 'REQ-050', clientName: 'María G.', serviceTitle: 'Tablero eléctrico', amount: 420, date: DateTime(2026, 7, 5)),
    IncomeRecord(id: 'INC-002', serviceId: 'REQ-051', clientName: 'Pedro L.', serviceTitle: 'Cableado nuevo', amount: 580, date: DateTime(2026, 7, 12)),
    IncomeRecord(id: 'INC-003', serviceId: 'REQ-052', clientName: 'Sofía R.', serviceTitle: 'Contactos y luces', amount: 310, date: DateTime(2026, 7, 19)),
    IncomeRecord(id: 'INC-004', serviceId: 'REQ-053', clientName: 'Ana M.', serviceTitle: 'Instalación general', amount: 690, date: DateTime(2026, 7, 28)),
  ];

  /// Reseñas del trabajador (para la pantalla de Historial)
  static final List<Review> workerReviews = [
    Review(id: 'rev1', serviceId: 'REQ-050', clientName: 'María G.', workerName: 'Carlos Mendoza', rating: 5, comment: 'Excelente trabajo, muy profesional y puntual.', date: DateTime(2026, 7, 15)),
    Review(id: 'rev2', serviceId: 'REQ-051', clientName: 'Pedro L.', workerName: 'Carlos Mendoza', rating: 4.5, comment: 'Resolvió el problema rápido. Lo recomiendo.', date: DateTime(2026, 7, 8)),
    Review(id: 'rev3', serviceId: 'REQ-052', clientName: 'Sofía R.', workerName: 'Carlos Mendoza', rating: 4, comment: 'Buen servicio, quedé muy satisfecha.', date: DateTime(2026, 7, 5)),
  ];
}
