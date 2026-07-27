import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  ServiceCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });
}

class Review {
  final String clientName;
  final double rating;
  final String comment;
  final String date;

  Review({
    required this.clientName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class WorkerProfile {
  final String id;
  final String name;
  final String mainTrade;
  final String categoryId;
  final double rating;
  final int totalJobs;
  final int experienceYears;
  final double hourlyRate;
  final String bio;
  final List<String> certifications;
  final List<String> workPhotos;
  final List<Review> reviews;
  final bool isAvailable;

  WorkerProfile({
    required this.id,
    required this.name,
    required this.mainTrade,
    required this.categoryId,
    required this.rating,
    required this.totalJobs,
    required this.experienceYears,
    required this.hourlyRate,
    required this.bio,
    required this.certifications,
    required this.workPhotos,
    required this.reviews,
    this.isAvailable = true,
  });
}

enum RequestStatus {
  pendiente,
  enProceso,
  finalizado,
  cancelado,
}

class JobRequest {
  final String id;
  final String serviceTitle;
  final WorkerProfile worker;
  final String clientName;
  final DateTime date;
  final String address;
  final String description;
  final double estimatedCost;
  RequestStatus status;
  final String paymentMethod;
  bool isPaid;

  JobRequest({
    required this.id,
    required this.serviceTitle,
    required this.worker,
    required this.clientName,
    required this.date,
    required this.address,
    required this.description,
    required this.estimatedCost,
    this.status = RequestStatus.pendiente,
    required this.paymentMethod,
    this.isPaid = false,
  });
}

class ChatMessage {
  final String id;
  final String senderName;
  final bool isWorker;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderName,
    required this.isWorker,
    required this.text,
    required this.timestamp,
  });
}

class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}
