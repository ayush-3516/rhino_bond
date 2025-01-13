class RewardHistory {
  final String id;
  final String title;
  final String description;
  final int points;
  final DateTime date;
  final String type;
  final String? productImage;
  final String? transactionId;

  RewardHistory({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.date,
    required this.type,
    this.productImage,
    this.transactionId,
  });
}
