import 'package:flutter/material.dart';
import 'package:rhino_bond/models/reward_history.dart';
import 'package:rhino_bond/widgets/rewards_history/rewards_history_card.dart';
import 'package:rhino_bond/utils/rewards_history_utils.dart';

class RewardsHistoryList extends StatelessWidget {
  final List<RewardHistory> transactions;
  final Function(RewardHistory) onItemTap;
  final GlobalKey<AnimatedListState> listKey;

  const RewardsHistoryList({
    super.key,
    required this.transactions,
    required this.onItemTap,
    required this.listKey,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      initialItemCount: transactions.isEmpty ? 1 : transactions.length,
      itemBuilder: (context, index, animation) {
        if (transactions.isEmpty) {
          return SizeTransition(
            sizeFactor: animation,
            child: FadeTransition(
              opacity: animation,
              child: const Center(child: Text('No transactions found')),
            ),
          );
        }
        if (index < 0 || index >= transactions.length) {
          return const SizedBox.shrink();
        }
        final item = transactions[index];
        if (item == null) {
          return const SizedBox.shrink();
        }
        return SizeTransition(
          sizeFactor: animation,
          child: FadeTransition(
            opacity: animation,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: RewardsHistoryCard(
                transaction: item,
                formattedDate: formatRewardsHistoryDate(item.date),
                onTap: () => onItemTap(item),
                heroTag: 'reward_${item.id}',
              ),
            ),
          ),
        );
      },
    );
  }
}
