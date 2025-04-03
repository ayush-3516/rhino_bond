import 'package:flutter/material.dart';
import 'package:rhino_bond/widgets/rewards_history/total_points_widget.dart';
import 'package:rhino_bond/widgets/rewards_history/rewards_history_filter.dart';

class RewardsHistoryHeader extends StatelessWidget {
  final int totalPoints;
  final String selectedFilter;
  final List<String> filters;
  final Function(String) onFilterChanged;
  final Color primaryColor;

  const RewardsHistoryHeader({
    super.key,
    required this.totalPoints,
    required this.selectedFilter,
    required this.filters,
    required this.onFilterChanged,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Rewards History',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        TotalPointsWidget(points: totalPoints, primaryColor: primaryColor),
        RewardsHistoryFilter(
          selectedFilter: selectedFilter,
          filters: filters,
          onFilterChanged: onFilterChanged,
          primaryColor: primaryColor,
        ),
      ],
    );
  }
}
