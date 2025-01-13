class Product {
  final String id;
  final String name;
  final String? description;
  final int pointsValue;
  final bool isActive;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.pointsValue,
    required this.isActive,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pointsValue: json['points_value'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'points_value': pointsValue,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
