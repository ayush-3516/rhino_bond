/// Represents a user in the application.
class User {
  /// Unique identifier for the user.
  final String id;

  /// Full name of the user.
  final String name;

  /// Email address of the user.
  final String email;

  /// Phone number of the user.
  final String? phone;

  /// PAN card number of the user.
  final String? panCard;

  /// KYC verification status of the user.
  final bool kycStatus;

  /// Points balance of the user.
  final int pointsBalance;

  /// Role of the user in the system.
  final String role;

  /// Whether the user account is active.
  final bool isActive;

  /// Date and time when the user was created.
  final DateTime createdAt;

  /// Creates an instance of [User].
  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.panCard,
    required this.kycStatus,
    required this.pointsBalance,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  /// Creates a [User] instance from JSON data.
  ///
  /// The JSON should contain the keys `id`, `name`, `email`, `phone`, `pan_card`,
  /// `kyc_status`, `points_balance`, `role`, `is_active`, and `created_at`.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      panCard: json['pan_card'],
      kycStatus: json['kyc_status'] ?? false,
      pointsBalance: json['points_balance'] ?? 0,
      role: json['role'] ?? 'user',
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// Converts the [User] instance to JSON.
  ///
  /// The resulting JSON will contain the keys `id`, `name`, `email`, `phone`,
  /// `pan_card`, `kyc_status`, `points_balance`, `role`, `is_active`, and `created_at`.
  Map<String, dynamic> toJson() {
    return {
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
}
