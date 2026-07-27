import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/models.dart';

class MongoDbService {
  // Default MongoDB Connection String (MongoDB Atlas or Local MongoDB instance)
  // Replace with your MongoDB Connection String (e.g. mongodb+srv://<user>:<password>@cluster.mongodb.net/yobs_db)
  static const String mongoUri =
      "mongodb+srv://manuelrosadoochoa_db_user:sy7ZHQK5MbOidvtt@cluster0.qfiq5ym.mongodb.net/yobs_db?retryWrites=true&w=majority";

  static Db? _db;
  static DbCollection? _workersCollection;
  static DbCollection? _requestsCollection;
  static DbCollection? _chatCollection;

  static bool _isConnected = false;
  static bool get isConnected => _isConnected;

  /// Connect to MongoDB Database
  static Future<bool> connect() async {
    try {
      if (_db != null && _db!.isConnected) {
        _isConnected = true;
        return true;
      }

      debugPrint("🔌 Conectando a la base de datos MongoDB...");
      _db = await Db.create(mongoUri);
      await _db!.open();

      _workersCollection = _db!.collection('workers');
      _requestsCollection = _db!.collection('job_requests');
      _chatCollection = _db!.collection('chat_messages');

      _isConnected = true;
      debugPrint("✅ Conexión exitosa a MongoDB database: yobs_db");

      // Initialize collections if empty
      await seedInitialData();

      return true;
    } catch (e) {
      debugPrint("⚠️ No se pudo conectar a MongoDB direct URI ($e). Usando modo caché offline/mock.");
      _isConnected = false;
      return false;
    }
  }

  /// Close MongoDB connection
  static Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _isConnected = false;
      debugPrint("🔌 Conexión a MongoDB cerrada.");
    }
  }

  /// Seed MongoDB with initial collections if empty
  static Future<void> seedInitialData() async {
    if (!_isConnected || _workersCollection == null) return;

    final count = await _workersCollection!.count();
    if (count == 0) {
      debugPrint("🌱 Insertando datos iniciales en colecciones de MongoDB...");
      await _workersCollection!.insertMany([
        {
          "workerId": "w1",
          "name": "Carlos Mendoza",
          "mainTrade": "Electricista Certificado",
          "categoryId": "cat_electricidad",
          "rating": 4.9,
          "totalJobs": 142,
          "experienceYears": 8,
          "hourlyRate": 35.0,
          "bio": "Especialista en instalaciones residenciales e industriales. Certificado por CONOCER con atención inmediata a emergencias.",
          "certifications": ["Técnico Electricista Industrial (SEC)", "Certificación en Seguridad Operativa"],
          "workPhotos": ["Tablero Eléctrico Residencial", "Instalación Iluminación LED"],
          "isAvailable": true
        },
        {
          "workerId": "w2",
          "name": "Alejandro Ramos",
          "mainTrade": "Plomero Máster",
          "categoryId": "cat_plomeria",
          "rating": 4.8,
          "totalJobs": 98,
          "experienceYears": 6,
          "hourlyRate": 30.0,
          "bio": "Reparación de fugas urgentes e instalación de tuberías Termofusión.",
          "certifications": ["Técnico en Hidrosanitarias"],
          "workPhotos": ["Instalación de Calentador Solar"],
          "isAvailable": true
        }
      ]);
    }
  }

  /// Get Workers from MongoDB
  static Future<List<Map<String, dynamic>>> getWorkers() async {
    if (!_isConnected || _workersCollection == null) return [];
    try {
      final list = await _workersCollection!.find().toList();
      return list;
    } catch (e) {
      debugPrint("Error fetching workers from MongoDB: $e");
      return [];
    }
  }

  /// Insert Job Request into MongoDB
  static Future<bool> insertJobRequest(JobRequest request) async {
    if (!_isConnected || _requestsCollection == null) return false;
    try {
      await _requestsCollection!.insertOne({
        "requestId": request.id,
        "serviceTitle": request.serviceTitle,
        "workerName": request.worker.name,
        "clientName": request.clientName,
        "date": request.date.toIso8601String(),
        "address": request.address,
        "description": request.description,
        "estimatedCost": request.estimatedCost,
        "status": request.status.name,
        "paymentMethod": request.paymentMethod,
        "isPaid": request.isPaid,
        "createdAt": DateTime.now().toIso8601String(),
      });
      debugPrint("✅ Solicitud guardada en MongoDB con ID: ${request.id}");
      return true;
    } catch (e) {
      debugPrint("Error inserting request into MongoDB: $e");
      return false;
    }
  }

  /// Insert Chat Message into MongoDB
  static Future<bool> insertChatMessage(ChatMessage msg) async {
    if (!_isConnected || _chatCollection == null) return false;
    try {
      await _chatCollection!.insertOne({
        "messageId": msg.id,
        "senderName": msg.senderName,
        "isWorker": msg.isWorker,
        "text": msg.text,
        "timestamp": msg.timestamp.toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint("Error inserting chat message into MongoDB: $e");
      return false;
    }
  }
}
