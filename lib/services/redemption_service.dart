import 'package:supabase_flutter/supabase_flutter.dart';

class RedemptionService {
  final SupabaseClient _supabase;

  RedemptionService() : _supabase = Supabase.instance.client;

  Future<void> redeemProduct({
    required String productId,
    required int points,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Start transaction
      final response = await _supabase.rpc('redeem_product', params: {
        'user_id': userId,
        'product_id': productId,
        'points': points,
      });

      if (response['status'] != 'success') {
        throw Exception(response['message']);
      }
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Redemption failed: $e');
    }
  }
}
