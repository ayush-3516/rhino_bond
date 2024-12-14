class RedemptionProduct {
  final String id;
  final String name;
  final String? description;
  final int pointsRequired;
  final bool isActive;
  final int stock;
  final DateTime createdAt;

  RedemptionProduct({
    required this.id,
    required this.name,
    this.description,
    required this.pointsRequired,
    this.isActive = true,
    required this.stock,
    required this.createdAt,
  });

  factory RedemptionProduct.fromJson(Map<String, dynamic> json) =>
      RedemptionProduct(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        pointsRequired: json['points_required'],
        isActive: json['is_active'],
        stock: json['stock'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'points_required': pointsRequired,
        'is_active': isActive,
        'stock': stock,
        'created_at': createdAt.toIso8601String(),
      };
}
