class PointsTransaction {
  final String id;
  final String userId;
  final String type;
  final int points;
  final String? qrCodeId;
  final String? productId;
  final DateTime timestamp;

  PointsTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.points,
    this.qrCodeId,
    this.productId,
    required this.timestamp,
  });

  factory PointsTransaction.fromJson(Map<String, dynamic> json) =>
      PointsTransaction(
        id: json['id'],
        userId: json['user_id'],
        type: json['type'],
        points: json['points'],
        qrCodeId: json['qr_code_id'],
        productId: json['product_id'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'type': type,
        'points': points,
        'qr_code_id': qrCodeId,
        'product_id': productId,
        'timestamp': timestamp.toIso8601String(),
      };
}
