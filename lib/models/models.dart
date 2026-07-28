// YOBS Data Models — based on Logica_de_uso_YOBS.md section 12

// --- Enums ---

enum RequestStatus {
  pendiente,
  aceptada,
  rechazada,
  enConversacion,
  confirmada,
  enProceso,
  finalizada,
  pendienteDeCalificacion,
  calificada,
  cancelada,
  enRevision,
}

enum UrgencyLevel {
  normal,
  urgente,
  hoyMismo,
}

// --- ServiceCategory ---
class ServiceCategory {
  final String id;
  final String title;
  final String icon; // emoji
  const ServiceCategory({required this.id, required this.title, required this.icon});
}

// --- WorkerProfile ---
class WorkerProfile {
  final String id;
  final String name;
  final String mainTrade;
  final String categoryId;
  final String bio;
  final double rating;
  final int reviewCount;
  final double hourlyRate;
  final int experienceYears;
  final bool isVerified;
  final bool isAvailable;
  final List<String> certifications;
  final String city;
  final String phone;
  final double distanceKm;

  const WorkerProfile({
    required this.id,
    required this.name,
    required this.mainTrade,
    required this.categoryId,
    required this.bio,
    required this.rating,
    required this.reviewCount,
    required this.hourlyRate,
    required this.experienceYears,
    this.isVerified = true,
    this.isAvailable = true,
    this.certifications = const [],
    this.city = 'Ciudad de México, Centro',
    this.phone = '+52 55 1234 5678',
    this.distanceKm = 2.5,
  });
}

// --- Review ---
class Review {
  final String id;
  final String serviceId;
  final String clientName;
  final String workerName;
  final double rating;
  final String comment;
  final DateTime date;

  const Review({
    required this.id,
    required this.serviceId,
    required this.clientName,
    required this.workerName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

// --- JobRequest ---
class JobRequest {
  final String id;
  final WorkerProfile worker;
  final String serviceTitle;
  final String description;
  final String address;
  final DateTime requestedDate;
  final UrgencyLevel urgency;
  final double estimatedPrice;
  RequestStatus status;
  double? finalPrice;
  String? rejectionReason;
  String? confirmationCode;

  JobRequest({
    required this.id,
    required this.worker,
    required this.serviceTitle,
    required this.description,
    required this.address,
    required this.requestedDate,
    this.urgency = UrgencyLevel.normal,
    required this.estimatedPrice,
    this.status = RequestStatus.pendiente,
    this.finalPrice,
    this.rejectionReason,
    this.confirmationCode,
  });

  /// Etiqueta legible del estado actual de la solicitud
  String get statusLabel {
    switch (status) {
      case RequestStatus.pendiente:                return '🕒 Pendiente';
      case RequestStatus.aceptada:                 return '✓ Aceptada';
      case RequestStatus.rechazada:                return '✗ Rechazada';
      case RequestStatus.enConversacion:           return '💬 En conversación';
      case RequestStatus.confirmada:               return '📋 Confirmada';
      case RequestStatus.enProceso:                return '🔧 En proceso';
      case RequestStatus.finalizada:               return '✅ Finalizada';
      case RequestStatus.pendienteDeCalificacion:  return '⭐ Calificar';
      case RequestStatus.calificada:               return '⭐ Calificada';
      case RequestStatus.cancelada:                return '❌ Cancelada';
      case RequestStatus.enRevision:               return '⚠️ En revisión';
    }
  }

  /// Reglas de cambio de estado (Logica_de_uso_YOBS.md sección 7)
  bool get canCancel =>
      status == RequestStatus.pendiente ||
      status == RequestStatus.aceptada ||
      status == RequestStatus.enConversacion;

  bool get canChat =>
      status != RequestStatus.rechazada &&
      status != RequestStatus.cancelada;

  bool get needsRating => status == RequestStatus.pendienteDeCalificacion;
}

// --- ChatMessage ---
class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isFromClient;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isFromClient,
  });
}

// --- IncomeRecord ---
class IncomeRecord {
  final String id;
  final String serviceId;
  final String clientName;
  final String serviceTitle;
  final double amount;
  final DateTime date;
  final String paymentStatus;

  const IncomeRecord({
    required this.id,
    required this.serviceId,
    required this.clientName,
    required this.serviceTitle,
    required this.amount,
    required this.date,
    this.paymentStatus = 'Pagado',
  });
}

