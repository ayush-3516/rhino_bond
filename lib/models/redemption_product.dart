class RedemptionProduct {
  final String id;
  final String name;
  final String description;
  final int pointsRequired;
  final bool isActive;
  final int stock;
  final DateTime createdAt;
  final String category;

  RedemptionProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsRequired,
    required this.isActive,
    required this.stock,
    required this.createdAt,
    this.category = 'All',
  });

  factory RedemptionProduct.fromJson(Map<String, dynamic> json) {
    return RedemptionProduct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pointsRequired: json['points_required'],
      isActive: json['is_active'],
      stock: json['stock'],
      createdAt: DateTime.parse(json['created_at']),
      category: json['category'] ?? 'All',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'points_required': pointsRequired,
      'is_active': isActive,
      'stock': stock,
      'created_at': createdAt.toIso8601String(),
      'category': category,
    };
  }
}
