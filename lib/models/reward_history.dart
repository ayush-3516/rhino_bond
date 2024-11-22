class RewardHistory {
  final String id;
  final String title;
  final String description;
  final int points;
  final DateTime date;
  final String type; // 'earned' or 'redeemed'
  final String? transactionId;
  final String? productImage;

  RewardHistory({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.date,
    required this.type,
    this.transactionId,
    this.productImage,
  });

  factory RewardHistory.fromJson(Map<String, dynamic> json) {
    return RewardHistory(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      points: json['points'] as int,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      transactionId: json['transactionId'] as String?,
      productImage: json['productImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'date': date.toIso8601String(),
      'type': type,
      'transactionId': transactionId,
      'productImage': productImage,
    };
  }
}
