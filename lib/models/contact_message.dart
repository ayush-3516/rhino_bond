import 'package:rhino_bond/services/session_manager.dart';

class ContactMessage {
  final String id;
  final String name;
  final String email;
  final String topic;
  final String message;
  final DateTime createdAt;
  final String? userId;
  final bool isResolved;
  final String? adminReply;
  final DateTime? repliedAt;

  ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.topic,
    required this.message,
    required this.createdAt,
    this.userId,
    this.isResolved = false,
    this.adminReply,
    this.repliedAt,
  });

  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      topic: json['topic'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      isResolved: json['is_resolved'] ?? false,
      adminReply: json['admin_reply'],
      repliedAt: json['replied_at'] != null
          ? DateTime.parse(json['replied_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'topic': topic,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'is_resolved': isResolved,
      'admin_reply': adminReply,
      'replied_at': repliedAt?.toIso8601String(),
    };
  }

  static List<String> get validTopics => [
        'General Inquiry',
        'Technical Support',
        'Account Issues',
        'Rewards Program',
        'Other Topic'
      ];
}
