import 'package:flutter/material.dart';

class TransactionStatusWidget extends StatelessWidget {
  final String selectedFilter;
  final VoidCallback onRefresh;
  final bool isError;

  const TransactionStatusWidget({
    super.key,
    required this.selectedFilter,
    required this.onRefresh,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.history,
            size: isError ? 48 : 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isError
                ? 'Failed to load transactions'
                : selectedFilter == 'Earned'
                ? 'No earned transactions found'
                : selectedFilter == 'Redeemed'
                ? 'No redeemed transactions found'
                : 'No transactions found',
            style: TextStyle(
              fontSize: isError ? 16 : 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isError) ...[
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh,
            child: Text(isError ? 'Try Again' : 'Refresh'),
          ),
        ],
      ),
    );
  }
}
