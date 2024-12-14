class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? panCard;
  final bool kycStatus;
  final int pointsBalance;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.panCard,
    this.kycStatus = false,
    this.pointsBalance = 0,
    this.role = 'user',
    this.isActive = true,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        panCard: json['pan_card'],
        kycStatus: json['kyc_status'],
        pointsBalance: json['points_balance'],
        role: json['role'],
        isActive: json['is_active'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'pan_card': panCard,
        'kyc_status': kycStatus,
        'points_balance': pointsBalance,
        'role': role,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
      };
}
