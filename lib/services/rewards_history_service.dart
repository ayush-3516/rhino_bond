import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rhino_bond/models/reward_history.dart';

class RewardsHistoryService {
  final SupabaseClient _supabase;

  RewardsHistoryService(this._supabase);

  Future<List<RewardHistory>> fetchTransactions() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('points_transactions')
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false)
          .limit(50);

      return (response as List).map((transaction) {
        try {
          return RewardHistory(
            id: transaction['id'],
            title: transaction['type'] == 'earn'
                ? 'Points Earned'
                : transaction['type'] == 'airdrop'
                    ? 'Airdrop Received'
                    : 'Product Redeemed',
            description: transaction['type'] == 'earn'
                ? 'Earned points'
                : transaction['type'] == 'airdrop'
                    ? 'Received airdrop'
                    : transaction['product_id'] != null
                        ? 'Redeemed product'
                        : 'Points deducted',
            points: (transaction['type'] == 'earn' ||
                    transaction['type'] == 'airdrop')
                ? transaction['points']
                : -transaction['points'],
            date: DateTime.parse(transaction['timestamp']),
            type: transaction['type'],
            transactionId: transaction['id'],
            productId: transaction['product_id'],
          );
        } catch (e) {
          return RewardHistory(
            id: transaction['id'],
            title: 'Transaction',
            description: 'Transaction completed',
            points: (transaction['type'] == 'earn' ||
                    transaction['type'] == 'airdrop')
                ? transaction['points']
                : -transaction['points'],
            date: DateTime.parse(transaction['timestamp']),
            type: transaction['type'],
            transactionId: transaction['id'],
          );
        }
      }).toList();
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  List<RewardHistory> filterHistory(
    List<RewardHistory> history,
    String selectedFilter,
  ) {
    if (history.isEmpty) return [];

    switch (selectedFilter) {
      case 'Earned':
        return history.where((item) => item.type == 'earn').toList();
      case 'Redeemed':
        return history.where((item) => item.type == 'redeem').toList();
      case 'Airdrops':
        return history.where((item) => item.type == 'airdrop').toList();
      case 'All':
      default:
        return history;
    }
  }
}
