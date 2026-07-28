import 'package:mongo_dart/mongo_dart.dart';
import '../models/models.dart';

class OrderModel {
  final String orderId;
  final String serviceTitle;
  final String categoryId;
  final String workerId;
  final String workerName;
  final String workerTrade;
  final String clientName;
  final String clientPhone;
  final DateTime orderDate;
  final String serviceAddress;
  final String serviceDescription;
  final double estimatedCost;
  final double hourlyRate;
  final int estimatedHours;
  String status; // 'pendiente', 'enProceso', 'finalizado', 'cancelado'
  String paymentMethod; // 'Tarjeta de Crédito', 'Transferencia bancaria', 'Efectivo'
  bool isPaid;
  String? receiptNumber;
  DateTime? completedAt;

  OrderModel({
    required this.orderId,
    required this.serviceTitle,
    required this.categoryId,
    required this.workerId,
    required this.workerName,
    required this.workerTrade,
    required this.clientName,
    this.clientPhone = '+52 55 1234 5678',
    required this.orderDate,
    required this.serviceAddress,
    required this.serviceDescription,
    required this.estimatedCost,
    required this.hourlyRate,
    this.estimatedHours = 2,
    this.status = 'pendiente',
    required this.paymentMethod,
    this.isPaid = false,
    this.receiptNumber,
    this.completedAt,
  });

  /// Convert to MongoDB BSON / Map format
  Map<String, dynamic> toMongoBson() {
    return {
      '_id': ObjectId(),
      'orderId': orderId,
      'serviceTitle': serviceTitle,
      'categoryId': categoryId,
      'workerId': workerId,
      'workerName': workerName,
      'workerTrade': workerTrade,
      'clientName': clientName,
      'clientPhone': clientPhone,
      'orderDate': orderDate.toIso8601String(),
      'serviceAddress': serviceAddress,
      'serviceDescription': serviceDescription,
      'estimatedCost': estimatedCost,
      'hourlyRate': hourlyRate,
      'estimatedHours': estimatedHours,
      'status': status,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'receiptNumber': receiptNumber ?? 'REC-${orderId.replaceAll('ORD-', '')}',
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Factory from MongoDB document / BSON
  factory OrderModel.fromMongoBson(Map<String, dynamic> bson) {
    return OrderModel(
      orderId: bson['orderId'] ?? '',
      serviceTitle: bson['serviceTitle'] ?? '',
      categoryId: bson['categoryId'] ?? '',
      workerId: bson['workerId'] ?? '',
      workerName: bson['workerName'] ?? '',
      workerTrade: bson['workerTrade'] ?? '',
      clientName: bson['clientName'] ?? '',
      clientPhone: bson['clientPhone'] ?? '+52 55 1234 5678',
      orderDate: bson['orderDate'] != null ? DateTime.parse(bson['orderDate']) : DateTime.now(),
      serviceAddress: bson['serviceAddress'] ?? '',
      serviceDescription: bson['serviceDescription'] ?? '',
      estimatedCost: (bson['estimatedCost'] as num?)?.toDouble() ?? 0.0,
      hourlyRate: (bson['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      estimatedHours: (bson['estimatedHours'] as num?)?.toInt() ?? 2,
      status: bson['status'] ?? 'pendiente',
      paymentMethod: bson['paymentMethod'] ?? 'Tarjeta de Crédito',
      isPaid: bson['isPaid'] ?? false,
      receiptNumber: bson['receiptNumber'],
      completedAt: bson['completedAt'] != null ? DateTime.parse(bson['completedAt']) : null,
    );
  }

  /// Convert to app JobRequest object
  JobRequest toJobRequest(WorkerProfile worker) {
    RequestStatus reqStatus;
    switch (status) {
      case 'enProceso':
        reqStatus = RequestStatus.enProceso;
        break;
      case 'finalizado':
        reqStatus = RequestStatus.finalizado;
        break;
      case 'cancelado':
        reqStatus = RequestStatus.cancelado;
        break;
      default:
        reqStatus = RequestStatus.pendiente;
    }

    return JobRequest(
      id: orderId,
      serviceTitle: serviceTitle,
      worker: worker,
      clientName: clientName,
      date: orderDate,
      address: serviceAddress,
      description: serviceDescription,
      estimatedCost: estimatedCost,
      status: reqStatus,
      paymentMethod: paymentMethod,
      isPaid: isPaid,
    );
  }
}
