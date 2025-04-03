import 'package:flutter/material.dart';
import 'package:rhino_bond/models/reward_history.dart';

class RewardsHistoryCard extends StatelessWidget {
  final RewardHistory transaction;
  final String formattedDate;
  final VoidCallback onTap;
  final String heroTag;

  const RewardsHistoryCard({
    super.key,
    required this.transaction,
    required this.formattedDate,
    required this.onTap,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      flightShuttleBuilder: (
        flightContext,
        animation,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        return ScaleTransition(
          scale: animation.drive(
            Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: toHeroContext.widget,
        );
      },
      child: AnimatedScale(
        scale: 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              hoverColor: Theme.of(context).primaryColor.withOpacity(0.05),
              highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
              splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    transaction.type == 'earn'
                                        ? Colors.green.shade50
                                        : transaction.type == 'airdrop'
                                        ? Colors.blue.shade50
                                        : Colors.red.shade50,
                                    transaction.type == 'earn'
                                        ? Colors.green.shade100
                                        : transaction.type == 'airdrop'
                                        ? Colors.blue.shade100
                                        : Colors.red.shade100,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                transaction.type == 'earn'
                                    ? Icons.trending_up
                                    : transaction.type == 'airdrop'
                                    ? Icons.airplanemode_active
                                    : Icons.shopping_bag,
                                color:
                                    transaction.type == 'earn'
                                        ? Colors.green.shade700
                                        : transaction.type == 'airdrop'
                                        ? Colors.blue.shade700
                                        : Colors.red.shade700,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    transaction.type == 'earn'
                                        ? Colors.green.shade50
                                        : transaction.type == 'airdrop'
                                        ? Colors.blue.shade50
                                        : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                transaction.type == 'earn'
                                    ? 'Earned'
                                    : transaction.type == 'airdrop'
                                    ? 'Airdrop'
                                    : 'Redeemed',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      transaction.type == 'earn'
                                          ? Colors.green.shade700
                                          : transaction.type == 'airdrop'
                                          ? Colors.blue.shade700
                                          : Colors.red.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                transaction.description,
                                style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${transaction.points > 0 ? '+' : ''}${transaction.points}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    transaction.type == 'earn'
                                        ? Colors.green.shade700
                                        : transaction.type == 'airdrop'
                                        ? Colors.blue.shade700
                                        : Colors.red.shade700,
                              ),
                            ),
                            Text(
                              'Points',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.blueGrey.shade400,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey.shade500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
