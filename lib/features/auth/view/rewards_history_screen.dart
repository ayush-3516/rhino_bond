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
      endDrawer: const AppDrawer(),
      body: Column(
        children: [
          // Summary Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    totalPoints.toString(),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Total Points',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Filter: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: _filters.map((String filter) {
                    return DropdownMenuItem<String>(
                      value: filter,
                      child: Text(filter),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedFilter = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredHistory.length,
              itemBuilder: (context, index) {
                final item = filteredHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
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
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.description),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(item.date),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      '${item.points > 0 ? '+' : ''}${item.points}',
                      style: TextStyle(
                        color: item.type == 'earned' 
                          ? Colors.green
                          : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    isThreeLine: true,
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
