import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/models.dart';
import '../models/order_model.dart';

class OrderDatabaseService {
  // MongoDB Atlas Connection String
  static const String mongoUri =
      "mongodb+srv://manuelrosadoochoa_db_user:sy7ZHQK5MbOidvtt@cluster0.qfiq5ym.mongodb.net/yobs_db?retryWrites=true&w=majority";

  static Db? _db;
  static DbCollection? _ordersCollection;
  static bool _isConnected = false;

  /// Connect to MongoDB Order Database
  static Future<bool> initDatabase() async {
    if (_isConnected && _db != null && _db!.isConnected) {
      return true;
    }
    try {
      debugPrint("📦 Conectando a la Base de Datos de Pedidos MongoDB...");
      _db = await Db.create(mongoUri);
      await _db!.open();

      _ordersCollection = _db!.collection('pedidos_yobs');
      _isConnected = true;

      // Ensure indexes on orderId and status
      await _ordersCollection!.createIndex(keys: {'orderId': 1}, unique: true);
      await _ordersCollection!.createIndex(keys: {'clientName': 1});
      await _ordersCollection!.createIndex(keys: {'workerId': 1});

      debugPrint("✅ Base de Datos MongoDB 'pedidos_yobs' inicializada correctamente.");
      return true;
    } catch (e) {
      debugPrint("⚠️ No se pudo conectar directamente a MongoDB para pedidos: $e");
      _isConnected = false;
      return false;
    }
  }

  /// Create a new order in MongoDB
  static Future<OrderModel?> createOrder({
    required WorkerProfile worker,
    required String clientName,
    required String address,
    required String description,
    required String paymentMethod,
    double hours = 2.0,
  }) async {
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    final newOrder = OrderModel(
      orderId: orderId,
      serviceTitle: worker.mainTrade,
      categoryId: worker.categoryId,
      workerId: worker.id,
      workerName: worker.name,
      workerTrade: worker.mainTrade,
      clientName: clientName,
      orderDate: DateTime.now(),
      serviceAddress: address,
      serviceDescription: description,
      estimatedCost: worker.hourlyRate * hours,
      hourlyRate: worker.hourlyRate,
      estimatedHours: hours.toInt(),
      status: 'pendiente',
      paymentMethod: paymentMethod,
      isPaid: true, // Retenido de forma segura en MongoDB
      receiptNumber: 'REC-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
    );

    await initDatabase();

    if (_isConnected && _ordersCollection != null) {
      try {
        await _ordersCollection!.insertOne(newOrder.toMongoBson());
        debugPrint("💾 ¡Pedido ${newOrder.orderId} guardado exitosamente en MongoDB!");
      } catch (e) {
        debugPrint("Error guardando pedido en MongoDB: $e");
      }
    }

    return newOrder;
  }

  /// Get all orders for a client from MongoDB
  static Future<List<OrderModel>> getOrdersByClient(String clientName) async {
    await initDatabase();
    if (!_isConnected || _ordersCollection == null) return [];

    try {
      final docs = await _ordersCollection!.find(where.eq('clientName', clientName)).toList();
      return docs.map((doc) => OrderModel.fromMongoBson(doc)).toList();
    } catch (e) {
      debugPrint("Error obteniendo pedidos de cliente: $e");
      return [];
    }
  }

  /// Get all orders for a worker from MongoDB
  static Future<List<OrderModel>> getOrdersByWorker(String workerId) async {
    await initDatabase();
    if (!_isConnected || _ordersCollection == null) return [];

    try {
      final docs = await _ordersCollection!.find(where.eq('workerId', workerId)).toList();
      return docs.map((doc) => OrderModel.fromMongoBson(doc)).toList();
    } catch (e) {
      debugPrint("Error obteniendo pedidos del trabajador: $e");
      return [];
    }
  }

  /// Update status of an order in MongoDB
  static Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    await initDatabase();
    if (!_isConnected || _ordersCollection == null) return false;

    try {
      final res = await _ordersCollection!.updateOne(
        where.eq('orderId', orderId),
        modify
            .set('status', newStatus)
            .set('updatedAt', DateTime.now().toIso8601String())
            .set('completedAt', newStatus == 'finalizado' ? DateTime.now().toIso8601String() : null),
      );
      debugPrint("🔄 Estado del pedido $orderId actualizado a '$newStatus' en MongoDB");
      return res.nModified > 0;
    } catch (e) {
      debugPrint("Error actualizando estado del pedido en MongoDB: $e");
      return false;
    }
  }
}
