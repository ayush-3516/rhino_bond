import 'dart:convert';

class AppUser {
  final String? id;
  final DateTime? createdAt;
  final String? phone;
  final String? name;
  final String? email;

  AppUser({
    this.id,
    this.createdAt,
    this.phone,
    this.name,
    this.email,
  });

  AppUser copyWith({
    String? id,
    DateTime? createdAt,
    String? phone,
    String? name,
    String? email,
  }) {
    return AppUser(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'phone': phone,
      'name': name,
      'email': email,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      phone: map['phone'],
      name: map['name'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(id: $id, createdAt: $createdAt, phone: $phone, name: $name, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.phone == phone &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        phone.hashCode ^
        name.hashCode ^
        email.hashCode;
  }
}
