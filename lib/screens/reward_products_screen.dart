import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rhino_bond/models/redemption_product.dart';
import 'package:rhino_bond/widgets/reward_card.dart';
import 'package:rhino_bond/widgets/custom_app_drawer.dart' show CustomAppDrawer;
import 'package:rhino_bond/widgets/appbar.dart' show CustomAppBar;
import 'package:provider/provider.dart';
import 'package:rhino_bond/notifiers/redemption_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RewardProductsScreen extends StatefulWidget {
  const RewardProductsScreen({Key? key}) : super(key: key);

  @override
  _RewardProductsScreenState createState() => _RewardProductsScreenState();
}

class _RewardProductsScreenState extends State<RewardProductsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Electronics',
    'Fashion',
    'Food',
    'Travel',
    'Entertainment',
    'Wellness'
  ];

  late Future<List<RedemptionProduct>> _productsFuture;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchRedemptionProducts();
  }

  Future<List<RedemptionProduct>> _fetchRedemptionProducts() async {
    try {
      final response = await _supabase
          .from('redemption_products')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      print('Fetched products: $response'); // Debug log

      final products = (response as List)
          .map((product) => RedemptionProduct.fromJson(product))
          .toList();

      print('Mapped products: $products'); // Debug log
      return products;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  List<RedemptionProduct> _filterProducts(List<RedemptionProduct> products) {
    if (_selectedCategory == 'All') {
      return products;
    }
    return products
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Rewards',
        scaffoldKey: _scaffoldKey,
      ),
      endDrawer: CustomAppDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                const Text(
                  'Available Rewards',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<RedemptionProduct>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products available'));
                }

                final products = _filterProducts(snapshot.data!);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return RewardCard(
                        title: product.name,
                        description: product.description,
                        points: product.pointsRequired,
                        stock: product.stock,
                        onRedeem: () async {
                          final user = _supabase.auth.currentUser;
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please login to redeem products'),
                              ),
                            );
                            return;
                          }

                          final redemptionNotifier =
                              Provider.of<RedemptionNotifier>(context,
                                  listen: false);

                          // Get current user points
                          final userResponse = await _supabase
                              .from('users')
                              .select('points_balance')
                              .eq('id', user.id)
                              .single();

                          final userPoints =
                              userResponse['points_balance'] as int;

                          if (userPoints < product.pointsRequired) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Insufficient points. You need ${product.pointsRequired - userPoints} more points'),
                              ),
                            );
                            return;
                          }

                          if (product.stock <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product out of stock'),
                              ),
                            );
                            return;
                          }

                          await redemptionNotifier.redeemProduct(
                            productId: product.id,
                            points: product.pointsRequired,
                          );

                          if (redemptionNotifier.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(redemptionNotifier.error!),
                              ),
                            );
                          } else {
                            // Refresh products
                            setState(() {
                              _productsFuture = _fetchRedemptionProducts();
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Successfully redeemed ${product.name}'),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/scan');
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan QR'),
      ),
    );
  }
}
