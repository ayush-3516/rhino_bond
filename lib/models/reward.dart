class Reward {
  final String id;
  final String title;
  final String description;
  final int points;
  final String imageUrl;
  final String category;
  final bool isAvailable;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.imageUrl,
    required this.category,
    this.isAvailable = true,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      points: json['points'] as int,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
    };
  }
}
