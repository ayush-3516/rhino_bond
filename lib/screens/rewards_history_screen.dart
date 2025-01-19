import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rhino_bond/widgets/appbar.dart';
import 'package:rhino_bond/widgets/custom_app_drawer.dart';
import 'package:rhino_bond/models/reward_history.dart';

class RewardsHistoryScreen extends StatefulWidget {
  const RewardsHistoryScreen({Key? key}) : super(key: key);

  @override
  State<RewardsHistoryScreen> createState() => _RewardsHistoryScreenState();
}

class _RewardsHistoryScreenState extends State<RewardsHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SupabaseClient _supabase = Supabase.instance.client;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Earned', 'Redeemed'];
  late Future<List<RewardHistory>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _fetchTransactions();
  }

  Future<List<RewardHistory>> _fetchTransactions() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('points_transactions')
          .select()
          .eq('user_id', userId)
          .order('timestamp', ascending: false)
          .limit(50); // Add pagination limit

      return (response as List).map((transaction) {
        try {
          return RewardHistory(
            id: transaction['id'],
            title: transaction['type'] == 'earn'
                ? 'Points Earned'
                : 'Product Redeemed',
            description: transaction['type'] == 'earn'
                ? 'Earned points'
                : transaction['product_id'] != null
                    ? 'Redeemed product'
                    : 'Points deducted',
            points: transaction['type'] == 'earn'
                ? transaction['points']
                : -transaction['points'],
            date: DateTime.parse(transaction['timestamp']),
            type: transaction['type'],
            transactionId: transaction['id'],
          );
        } catch (e) {
          return RewardHistory(
            id: transaction['id'],
            title: 'Transaction',
            description: 'Transaction completed',
            points: transaction['type'] == 'earn'
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

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  List<RewardHistory> _getFilteredHistory(List<RewardHistory> history) {
    if (_selectedFilter == 'All') return history;
    if (_selectedFilter == 'Earned') {
      return history.where((item) => item.type == 'earn').toList();
    }
    if (_selectedFilter == 'Redeemed') {
      return history.where((item) => item.type != 'earn').toList();
    }
    return history;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back navigation
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          showBackButton: true,
        ),
        drawer: CustomAppDrawer(),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _transactionsFuture = _fetchTransactions();
              });
              await _transactionsFuture;
            },
            child: FutureBuilder<List<RewardHistory>>(
                future: _transactionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load transactions',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please check your internet connection',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _transactionsFuture = _fetchTransactions();
                              });
                            },
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No transactions found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _transactionsFuture = _fetchTransactions();
                              });
                            },
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    );
                  }

                  final transactions = snapshot.data!;
                  final filteredHistory = _getFilteredHistory(transactions);
                  final totalPoints = transactions.fold<int>(
                      0, (sum, item) => sum + item.points);
                  // final totalPoints = filteredHistory.fold<int>(
                  // 0, (sum, item) => sum + item.points);

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Rewards History',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                            ),
                          ),
                          // Summary Card
                          Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.stars,
                                        color: Colors.white.withOpacity(0.9),
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        totalPoints.toString(),
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Total Points',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Filter Section
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                const Text(
                                  'Filter by:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: _filters.map((filter) {
                                        final isSelected =
                                            _selectedFilter == filter;
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: FilterChip(
                                            selected: isSelected,
                                            label: Text(filter),
                                            onSelected: (bool selected) {
                                              setState(() {
                                                _selectedFilter = filter;
                                              });
                                            },
                                            selectedColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2),
                                            checkmarkColor:
                                                Theme.of(context).primaryColor,
                                            labelStyle: TextStyle(
                                              color: isSelected
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.black87,
                                              fontWeight: isSelected
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
                          ),

                          // History List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredHistory.length,
                            itemBuilder: (context, index) {
                              final item = filteredHistory[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      // Transaction Icon
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: item.type == 'earn'
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.red.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        child: Icon(
                                          item.type == 'earn'
                                              ? Icons.add_circle_outline
                                              : Icons.remove_circle_outline,
                                          color: item.type == 'earn'
                                              ? Colors.green
                                              : Colors.red,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Transaction Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.title,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  '${item.points > 0 ? '+' : ''}${item.points}',
                                                  style: TextStyle(
                                                    color: item.type == 'earn'
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.description,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              _formatDate(item.date),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
