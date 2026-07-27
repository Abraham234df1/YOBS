import 'package:flutter/material.dart';
import '../models/models.dart';

class MockDataService {
  static final List<ServiceCategory> categories = [
    ServiceCategory(
      id: 'cat_electricidad',
      title: 'Electricidad',
      icon: Icons.bolt_rounded,
      color: const Color(0xFFF59E0B),
      description: 'Instalaciones, cableado, cortocircuitos y tableros.',
    ),
    ServiceCategory(
      id: 'cat_plomeria',
      title: 'Plomería',
      icon: Icons.water_drop_rounded,
      color: const Color(0xFF0EA5E9),
      description: 'Reparación de fugas, tuberías, destapes y grifería.',
    ),
    ServiceCategory(
      id: 'cat_carpinteria',
      title: 'Carpintería',
      icon: Icons.hardware_rounded,
      color: const Color(0xFF8B5CF6),
      description: 'Muebles a medida, puertas, barniz y reparaciones.',
    ),
    ServiceCategory(
      id: 'cat_construccion',
      title: 'Construcción',
      icon: Icons.foundation_rounded,
      color: const Color(0xFFEF4444),
      description: 'Remodelaciones, mampostería, pisos y acabados.',
    ),
    ServiceCategory(
      id: 'cat_limpieza',
      title: 'Limpieza',
      icon: Icons.cleaning_services_rounded,
      color: const Color(0xFF10B981),
      description: 'Limpieza residencial, comercial y de obras.',
    ),
    ServiceCategory(
      id: 'cat_pintura',
      title: 'Pintura',
      icon: Icons.format_paint_rounded,
      color: const Color(0xFFEC4899),
      description: 'Pintura de interiores, fachadas e impermeabilización.',
    ),
    ServiceCategory(
      id: 'cat_jardineria',
      title: 'Jardinería',
      icon: Icons.park_rounded,
      color: const Color(0xFF22C55E),
      description: 'Corte de césped, poda, paisajismo y sistemas de riego.',
    ),
    ServiceCategory(
      id: 'cat_cerrajeria',
      title: 'Cerrajería',
      icon: Icons.key_rounded,
      color: const Color(0xFF64748B),
      description: 'Apertura de chapas, duplicado de llaves y cerraduras.',
    ),
  ];

  static final List<WorkerProfile> workers = [
    WorkerProfile(
      id: 'w1',
      name: 'Carlos Mendoza',
      mainTrade: 'Electricista Certificado',
      categoryId: 'cat_electricidad',
      rating: 4.9,
      totalJobs: 142,
      experienceYears: 8,
      hourlyRate: 35.0,
      bio: 'Especialista en instalaciones residenciales e industriales. Certificado por CONOCER con atención inmediata a emergencias.',
      certifications: [
        'Técnico Electricista Industrial (SEC)',
        'Certificación en Seguridad Operativa',
        'Norma Oficial de Cableado Estructurado'
      ],
      workPhotos: [
        'Tablero Eléctrico Residencial',
        'Instalación Iluminación LED',
        'Reparación Breaker Principal'
      ],
      reviews: [
        Review(
          clientName: 'María Fernanda R.',
          rating: 5.0,
          comment: 'Excelente trabajo, llegó puntual y resolvió el corto en menos de una hora. Muy profesional.',
          date: '2026-07-20',
        ),
        Review(
          clientName: 'Roberto Gómez',
          rating: 4.8,
          comment: 'Instaló todo el cableado de mi negocio. Impecable limpieza y garantía.',
          date: '2026-07-12',
        ),
      ],
    ),
    WorkerProfile(
      id: 'w2',
      name: 'Alejandro Ramos',
      mainTrade: 'Plomero Máster',
      categoryId: 'cat_plomeria',
      rating: 4.8,
      totalJobs: 98,
      experienceYears: 6,
      hourlyRate: 30.0,
      bio: 'Reparación de fugas urgentes, instalación de calentadores solares y tuberías Termofusión.',
      certifications: [
        'Técnico en Hidrosanitarias',
        'Instalador Autorizado de Calentadores Solares'
      ],
      workPhotos: [
        'Instalación de Calentador Solar',
        'Red de Tubería PPR',
        'Cambio de Grifería de Lujo'
      ],
      reviews: [
        Review(
          clientName: 'Laura Torres',
          rating: 5.0,
          comment: 'Solucionó la fuga de agua caliente en minutos. 100% recomendado.',
          date: '2026-07-22',
        ),
      ],
    ),
    WorkerProfile(
      id: 'w3',
      name: 'Javier Castillo',
      mainTrade: 'Carpintero de Muebles Finos',
      categoryId: 'cat_carpinteria',
      rating: 5.0,
      totalJobs: 75,
      experienceYears: 12,
      hourlyRate: 40.0,
      bio: 'Diseño e instalación de cocinas integrales, closets a medida y restauración de maderas nobles.',
      certifications: [
        'Maestro Carpintero Artesanal',
        'Especialista en Diseños Modulares'
      ],
      workPhotos: [
        'Cocina Integral de Encino',
        'Closet de Cedro Blanco',
        'Mesa de Centro Rústica'
      ],
      reviews: [
        Review(
          clientName: 'Gabriel Solís',
          rating: 5.0,
          comment: 'Hizo los closets de las habitaciones. Superó nuestras expectativas.',
          date: '2026-07-18',
        ),
      ],
    ),
    WorkerProfile(
      id: 'w4',
      name: 'Sofía Valenzuela',
      mainTrade: 'Especialista en Pintura & Acabados',
      categoryId: 'cat_pintura',
      rating: 4.9,
      totalJobs: 110,
      experienceYears: 5,
      hourlyRate: 28.0,
      bio: 'Servicios de pintura interior, impermeabilización de azoteas y colocación de papel tapiz.',
      certifications: [
        'Certificación en Texturas y Acabados Comex',
        'Aplicador Autorizado Impermeabilizante Fibratado'
      ],
      workPhotos: [
        'Mural Interior Moderno',
        'Impermeabilización de Azotea',
        'Pintura Exterior de Casa'
      ],
      reviews: [
        Review(
          clientName: 'Ana Belén P.',
          rating: 4.9,
          comment: 'Dejó mi sala increíble. Muy detallista y cuidó todo el mobiliario.',
          date: '2026-07-15',
        ),
      ],
    ),
  ];

  static List<JobRequest> requests = [
    JobRequest(
      id: 'REQ-101',
      serviceTitle: 'Reparación de Cortocircuito en Cocina',
      worker: workers[0],
      clientName: 'Manuel López',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      address: 'Av. Las Palmas #450, Col. Jardines',
      description: 'El breaker principal se bota al encender el horno eléctrico.',
      estimatedCost: 70.0,
      status: RequestStatus.enProceso,
      paymentMethod: 'Tarjeta de Crédito',
      isPaid: true,
    ),
    JobRequest(
      id: 'REQ-102',
      serviceTitle: 'Instalación de Fregadero Doble',
      worker: workers[1],
      clientName: 'Manuel López',
      date: DateTime.now().subtract(const Duration(days: 2)),
      address: 'Av. Las Palmas #450, Col. Jardines',
      description: 'Cambio de fregadero antiguo por modelo tarja acero inoxidable.',
      estimatedCost: 90.0,
      status: RequestStatus.finalizado,
      paymentMethod: 'Transferencia bancaria',
      isPaid: true,
    ),
    JobRequest(
      id: 'REQ-103',
      serviceTitle: 'Pintado de Fachada Principal',
      worker: workers[3],
      clientName: 'Manuel López',
      date: DateTime.now().add(const Duration(days: 1)),
      address: 'Av. Las Palmas #450, Col. Jardines',
      description: 'Pintura vinílica lavable tono gris oxford.',
      estimatedCost: 150.0,
      status: RequestStatus.pendiente,
      paymentMethod: 'Efectivo',
      isPaid: false,
    ),
  ];

  static List<ChatMessage> initialMessages = [
    ChatMessage(
      id: 'm1',
      senderName: 'Carlos Mendoza',
      isWorker: true,
      text: '¡Hola! Ya revisé tu solicitud para el cortocircuito en cocina. ¿Sigues disponible hoy?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    ChatMessage(
      id: 'm2',
      senderName: 'Manuel López',
      isWorker: false,
      text: 'Sí Carlos, estoy en el domicilio. ¿En cuánto tiempo calculas llegar?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    ChatMessage(
      id: 'm3',
      senderName: 'Carlos Mendoza',
      isWorker: true,
      text: 'Voy en camino, llego en aproximadamente 15 minutos con las herramientas.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];

  static List<FAQItem> faqs = [
    FAQItem(
      question: '¿Cómo funciona la garantía de contratación en YOBS?',
      answer: 'Todos los servicios contratados a través de YOBS cuentan con la Garantía YOBS Shield de hasta 30 días posteriores al trabajo realizado.',
    ),
    FAQItem(
      question: '¿Cómo se procesan los pagos a los trabajadores?',
      answer: 'El pago se retiene de forma segura y se libera al trabajador únicamente cuando confirmas que el trabajo se ha finalizado a tu entera satisfacción.',
    ),
    FAQItem(
      question: '¿Puedo solicitar factura de los servicios?',
      answer: 'Sí. En la sección de facturación puedes ingresar tus datos fiscales y solicitar la factura correspondiente de cada contratación.',
    ),
    FAQItem(
      question: '¿Cómo puedo registrarme como trabajador?',
      answer: 'Selecciona "Soy trabajador" en la pantalla de inicio, completa tu perfil profesional, sube tus certificaciones y listo.',
    ),
  ];
}
