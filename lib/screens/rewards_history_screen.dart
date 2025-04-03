import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rhino_bond/widgets/appbar.dart';
import 'package:rhino_bond/widgets/custom_app_drawer.dart';
import 'package:rhino_bond/models/reward_history.dart';
import 'package:flutter/services.dart';

class RewardsHistoryScreen extends StatefulWidget {
  const RewardsHistoryScreen({super.key});

  @override
  State<RewardsHistoryScreen> createState() => _RewardsHistoryScreenState();
}

class _RewardsHistoryScreenState extends State<RewardsHistoryScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

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
          .limit(50);

      return (response as List).map((transaction) {
        try {
          return RewardHistory(
            id: transaction['id'],
            title: transaction['type'] == 'earn'
                ? 'Points Earned'
                : transaction['type'] == 'airdrop'
                    ? 'Airdrop Received'
                    : 'Product Redeemed',
            description: transaction['type'] == 'earn'
                ? 'Earned points'
                : transaction['type'] == 'airdrop'
                    ? 'Received airdrop'
                    : transaction['product_id'] != null
                        ? 'Redeemed product'
                        : 'Points deducted',
            points: (transaction['type'] == 'earn' ||
                    transaction['type'] == 'airdrop')
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
            points: (transaction['type'] == 'earn' ||
                    transaction['type'] == 'airdrop')
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
    if (history.isEmpty) return [];

    switch (_selectedFilter) {
      case 'Earned':
        return history.where((item) => item.type == 'earn').toList();
      case 'Redeemed':
        return history.where((item) => item.type != 'redeem').toList();
      case 'All':
      default:
        return history;
    }
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTransactionDetails(RewardHistory transaction) async {
    // Fetch product details if product_id is available
    String productName = 'N/A';
    if (transaction.productId != null) {
      final response = await _supabase
          .from('products')
          .select('name')
          .eq('id', transaction.productId!)
          .single();
      productName = response['name'];
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(),
                  blurRadius: 10,
                  offset: Offset(0, -2),
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
                    'Transaction ID', transaction.transactionId ?? 'N/A'),
                _buildCopyableField('Type', transaction.type),
                _buildCopyableField('Date', _formatDate(transaction.date)),
                _buildCopyableField('Product', productName),
                _buildCopyableField('Points', transaction.points.toString()),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor:
                        Theme.of(context).primaryColor, // Button color
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCopyableField(String label, String value) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Light grey background for better contrast
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
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
              final transactions = await _fetchTransactions();
              setState(() {
                _transactionsFuture = Future.value(transactions);
              });
            },
            child: FutureBuilder<List<RewardHistory>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerLoader();
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Failed to load transactions',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('Please check your internet connection',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(
                              () => _transactionsFuture = _fetchTransactions()),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFilter == 'Earned'
                              ? 'No earned transactions found'
                              : _selectedFilter == 'Redeemed'
                                  ? 'No redeemed transactions found'
                                  : 'No transactions found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(
                              () => _transactionsFuture = _fetchTransactions()),
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  );
                }

                final transactions = snapshot.data!;
                final filteredHistory = _getFilteredHistory(transactions);
                final totalPoints =
                    transactions.fold<int>(0, (sum, item) => sum + item.points);

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
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColor.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
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
                                    Icon(Icons.stars,
                                        color: Colors.white.withOpacity(0.9),
                                        size: 28),
                                    const SizedBox(width: 12),
                                    Text(totalPoints.toString(),
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('Total Points',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              const Text('Filter by:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  )),
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
                                          onSelected: (selected) => setState(
                                              () => _selectedFilter = filter),
                                          avatar: AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: isSelected
                                                ? Icon(Icons.check,
                                                    size: 18,
                                                    color: Theme.of(context)
                                                        .primaryColor)
                                                : const SizedBox.shrink(),
                                          ),
                                          selectedColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2),
                                          checkmarkColor:
                                              Theme.of(context).primaryColor,
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
                        AnimatedList(
                          key: _listKey,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          initialItemCount: filteredHistory.isEmpty
                              ? 1
                              : filteredHistory.length,
                          itemBuilder: (context, index, animation) {
                            if (filteredHistory.isEmpty) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.history,
                                            size: 64, color: Colors.grey[400]),
                                        const SizedBox(height: 16),
                                        Text(
                                          _selectedFilter == 'Earned'
                                              ? 'No earned transactions found'
                                              : _selectedFilter == 'Redeemed'
                                                  ? 'No redeemed transactions found'
                                                  : 'No transactions found',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            final item = filteredHistory[index];
                            return SizeTransition(
                              sizeFactor: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Hero(
                                    tag: 'reward_${item.id}',
                                    flightShuttleBuilder: (flightContext,
                                        animation,
                                        flightDirection,
                                        fromHeroContext,
                                        toHeroContext) {
                                      return ScaleTransition(
                                        scale: animation.drive(
                                            Tween<double>(begin: 0.8, end: 1.0)
                                                .chain(CurveTween(
                                                    curve: Curves.easeInOut))),
                                        child: toHeroContext.widget,
                                      );
                                    },
                                    child: AnimatedScale(
                                      scale: 1,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            onTap: () {
                                              _showTransactionDetails(item);
                                            },
                                            hoverColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.05),
                                            highlightColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                            splashColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: 40,
                                                            height: 40,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  item.type ==
                                                                          'earn'
                                                                      ? Colors
                                                                          .green
                                                                          .shade50
                                                                      : item.type ==
                                                                              'airdrop'
                                                                          ? Colors
                                                                              .blue
                                                                              .shade50
                                                                          : Colors
                                                                              .red
                                                                              .shade50,
                                                                  item.type ==
                                                                          'earn'
                                                                      ? Colors
                                                                          .green
                                                                          .shade100
                                                                      : item.type ==
                                                                              'airdrop'
                                                                          ? Colors
                                                                              .blue
                                                                              .shade100
                                                                          : Colors
                                                                              .red
                                                                              .shade100,
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: Icon(
                                                              item.type ==
                                                                      'earn'
                                                                  ? Icons
                                                                      .trending_up
                                                                  : item.type ==
                                                                          'airdrop'
                                                                      ? Icons
                                                                          .airplanemode_active
                                                                      : Icons
                                                                          .shopping_bag,
                                                              color: item.type ==
                                                                      'earn'
                                                                  ? Colors.green
                                                                      .shade700
                                                                  : item.type ==
                                                                          'airdrop'
                                                                      ? Colors
                                                                          .blue
                                                                          .shade700
                                                                      : Colors
                                                                          .red
                                                                          .shade700,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: item.type ==
                                                                      'earn'
                                                                  ? Colors.green
                                                                      .shade50
                                                                  : item.type ==
                                                                          'airdrop'
                                                                      ? Colors
                                                                          .blue
                                                                          .shade50
                                                                      : Colors
                                                                          .red
                                                                          .shade50,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            child: Text(
                                                              item.type ==
                                                                      'earn'
                                                                  ? 'Earned'
                                                                  : item.type ==
                                                                          'airdrop'
                                                                      ? 'Airdrop'
                                                                      : 'Redeemed',
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: item.type ==
                                                                        'earn'
                                                                    ? Colors
                                                                        .green
                                                                        .shade700
                                                                    : item.type ==
                                                                            'airdrop'
                                                                        ? Colors
                                                                            .blue
                                                                            .shade700
                                                                        : Colors
                                                                            .red
                                                                            .shade700,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(item.title,
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                                item
                                                                    .description,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade600,
                                                                  fontSize: 14,
                                                                  height: 1.4,
                                                                ),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                              '${item.points > 0 ? '+' : ''}${item.points}',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: item.type ==
                                                                        'earn'
                                                                    ? Colors
                                                                        .green
                                                                        .shade700
                                                                    : item.type ==
                                                                            'airdrop'
                                                                        ? Colors
                                                                            .blue
                                                                            .shade700
                                                                        : Colors
                                                                            .red
                                                                            .shade700,
                                                              )),
                                                          Text('Points',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .blueGrey
                                                                    .shade500,
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Divider(height: 1),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.calendar_today,
                                                          size: 14,
                                                          color: Colors.blueGrey
                                                              .shade400),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                          _formatDate(
                                                              item.date),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .blueGrey
                                                                .shade500,
                                                          )),
                                                      const Spacer(),
                                                      Text('Completed',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .green.shade600,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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
