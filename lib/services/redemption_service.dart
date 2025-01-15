import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rhino_bond/utils/logger.dart';

class RedemptionService {
  final SupabaseClient _supabase;

  RedemptionService() : _supabase = Supabase.instance.client;

  Future<void> redeemProduct({
    required String productId,
    required int points,
  }) async {
    Logger.debug('Starting product redemption for product: $productId');

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      Logger.error('User not authenticated for redemption');
      throw Exception('User not authenticated');
    }

    Logger.debug('Authenticated user: $userId attempting redemption');

    try {
      Logger.debug('Initiating redemption transaction');

      // Start transaction
      final response = await _supabase.rpc('redeem_product', params: {
        'user_id': userId,
        'product_id': productId,
        'points': points,
      });

      if (response['status'] != 'success') {
        Logger.error('Redemption failed: ${response['message']}');
        throw Exception(response['message']);
      }

      Logger.success(
          'Product $productId redeemed successfully by user $userId');
    } on PostgrestException catch (e) {
      Logger.error('Database error during redemption: ${e.message}');
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      Logger.error('Redemption failed: $e');
      throw Exception('Redemption failed: $e');
    }
  }
}
