import 'package:supabase_flutter/supabase_flutter.dart';

class CustomUser extends User {
  final String name;

  CustomUser({
    required String id,
    required String email,
    required this.name,
    required String phone,
  }) : super(
          id: id,
          email: email,
          phone: phone,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'name': name,
    };
  }
}
