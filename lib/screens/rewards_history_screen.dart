import 'package:flutter/material.dart';
import 'package:rhino_bond/widgets/appbar.dart';
import 'package:rhino_bond/widgets/custom_app_drawer.dart';
import 'package:rhino_bond/models/reward_history.dart';
import 'package:rhino_bond/services/rewards_history_service.dart';
import 'package:rhino_bond/widgets/rewards_history/transaction_details_sheet.dart';
import 'package:rhino_bond/widgets/rewards_history/rewards_history_header.dart';
import 'package:rhino_bond/widgets/rewards_history/rewards_history_list.dart';
import 'package:rhino_bond/widgets/rewards_history/rewards_history_shimmer.dart';
import 'package:rhino_bond/utils/rewards_history_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RewardsHistoryScreen extends StatefulWidget {
  const RewardsHistoryScreen({super.key});

  @override
  State<RewardsHistoryScreen> createState() => _RewardsHistoryScreenState();
}

class _RewardsHistoryScreenState extends State<RewardsHistoryScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final RewardsHistoryService _historyService = RewardsHistoryService(
    Supabase.instance.client,
  );
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Earned', 'Redeemed', 'Airdrops'];
  late Future<List<RewardHistory>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _historyService.fetchTransactions();
  }

  void _showTransactionDetails(RewardHistory transaction) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => TransactionDetailsSheet(
            transaction: transaction,
            supabase: Supabase.instance.client,
            formattedDate: formatRewardsHistoryDate(transaction.date),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey, showBackButton: true),
        drawer: const CustomAppDrawer(),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _transactionsFuture = _historyService.fetchTransactions();
              });
            },
            child: FutureBuilder<List<RewardHistory>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const RewardsHistoryShimmer();
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No transactions found'));
                }

                final transactions = snapshot.data!;
                final filteredHistory = _historyService.filterHistory(
                  transactions,
                  _selectedFilter,
                );
                final totalPoints = transactions.fold<int>(
                  0,
                  (sum, item) => sum + item.points,
                );

                if (filteredHistory.isEmpty) {
                  return Column(
                    children: [
                      RewardsHistoryHeader(
                        totalPoints: totalPoints,
                        selectedFilter: _selectedFilter,
                        filters: _filters,
                        onFilterChanged:
                            (filter) =>
                                setState(() => _selectedFilter = filter),
                        primaryColor: Theme.of(context).primaryColor,
                      ),
                      const Expanded(
                        child: Center(
                          child: Text('No transactions found for this filter'),
                        ),
                      ),
                    ],
                  );
                }

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    RewardsHistoryHeader(
                      totalPoints: totalPoints,
                      selectedFilter: _selectedFilter,
                      filters: _filters,
                      onFilterChanged:
                          (filter) => setState(() => _selectedFilter = filter),
                      primaryColor: Theme.of(context).primaryColor,
                    ),
                    RewardsHistoryList(
                      transactions: filteredHistory,
                      onItemTap: _showTransactionDetails,
                      listKey: _listKey,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
