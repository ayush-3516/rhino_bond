import 'package:flutter/material.dart';

class RewardsHistoryFilter extends StatelessWidget {
  final String selectedFilter;
  final List<String> filters;
  final ValueChanged<String> onFilterChanged;
  final Color primaryColor;

  const RewardsHistoryFilter({
    super.key,
    required this.selectedFilter,
    required this.filters,
    required this.onFilterChanged,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Filter by:',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    filters.map((filter) {
                      final isSelected = selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(filter),
                          onSelected: (selected) => onFilterChanged(filter),
                          avatar: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child:
                                isSelected
                                    ? Icon(
                                      Icons.check,
                                      size: 18,
                                      color: primaryColor,
                                    )
                                    : const SizedBox.shrink(),
                          ),
                          selectedColor: primaryColor.withOpacity(0.2),
                          checkmarkColor: primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? primaryColor : Colors.black87,
                            fontWeight:
                                isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
