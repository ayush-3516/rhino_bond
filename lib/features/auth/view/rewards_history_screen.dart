import 'package:flutter/material.dart';
import 'package:rhino_bond/appbar.dart';
import 'package:rhino_bond/widgets/app_drawer.dart';
import 'package:rhino_bond/models/reward_history.dart';

class RewardsHistoryScreen extends StatefulWidget {
  const RewardsHistoryScreen({Key? key}) : super(key: key);

  @override
  State<RewardsHistoryScreen> createState() => _RewardsHistoryScreenState();
}

class _RewardsHistoryScreenState extends State<RewardsHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Earned', 'Redeemed'];
  
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // TODO: Replace with actual API call
  List<RewardHistory> _getDummyData() {
    return [
      RewardHistory(
        id: '1',
        title: 'Welcome Bonus',
        description: 'New user registration bonus',
        points: 100,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: 'earned',
      ),
      RewardHistory(
        id: '2',
        title: 'Coffee Mug',
        description: 'Redeemed for premium coffee mug',
        points: -50,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: 'redeemed',
        productImage: 'assets/images/mug.png',
      ),
      RewardHistory(
        id: '3',
        title: 'Product Purchase',
        description: 'Points earned from buying Product X',
        points: 75,
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: 'earned',
        transactionId: 'TXN123456',
      ),
    ];
  }

  List<RewardHistory> _getFilteredHistory() {
    final List<RewardHistory> history = _getDummyData();
    if (_selectedFilter == 'All') return history;
    return history.where((item) => 
      item.type.toLowerCase() == _selectedFilter.toLowerCase()
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<RewardHistory> filteredHistory = _getFilteredHistory();
    final totalPoints = filteredHistory.fold<int>(
      0, (sum, item) => sum + item.points
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Rewards History',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSelected,
                            label: Text(filter),
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                            checkmarkColor: Theme.of(context).primaryColor,
                            labelStyle: TextStyle(
                              color: isSelected 
                                ? Theme.of(context).primaryColor
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
          Expanded(
            child: filteredHistory.isEmpty
              ? Center(
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
                    ],
                  ),
                )
              : ListView.builder(
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
                                color: item.type == 'earned'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(
                                item.type == 'earned'
                                  ? Icons.add_circle_outline
                                  : Icons.remove_circle_outline,
                                color: item.type == 'earned'
                                  ? Colors.green
                                  : Colors.red,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Transaction Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '${item.points > 0 ? '+' : ''}${item.points}',
                                        style: TextStyle(
                                          color: item.type == 'earned'
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
            ),
        ],
      ),
    );
  }
}
