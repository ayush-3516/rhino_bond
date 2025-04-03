import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rhino_bond/models/reward_history.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionDetailsSheet extends StatelessWidget {
  final RewardHistory transaction;
  final SupabaseClient supabase;
  final String formattedDate;

  const TransactionDetailsSheet({
    super.key,
    required this.transaction,
    required this.supabase,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).primaryColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Transaction Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildCopyableField(
              context,
              'Transaction ID',
              transaction.transactionId ?? 'N/A',
            ),
            _buildCopyableField(context, 'Type', transaction.type),
            _buildCopyableField(context, 'Date', formattedDate),
            FutureBuilder<String>(
              future: _getProductName(),
              builder: (context, snapshot) {
                return _buildCopyableField(
                  context,
                  'Product',
                  snapshot.data ?? 'N/A',
                );
              },
            ),
            _buildCopyableField(
              context,
              'Points',
              transaction.points.toString(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getProductName() async {
    if (transaction.productId == null) return 'N/A';

    try {
      final response =
          await supabase
              .from('products')
              .select('name')
              .eq('id', transaction.productId!)
              .single();
      return response['name'];
    } catch (e) {
      return 'N/A';
    }
  }

  Widget _buildCopyableField(BuildContext context, String label, String value) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '$label:',
                style: TextStyle(color: Colors.black54, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(color: Colors.black87, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
