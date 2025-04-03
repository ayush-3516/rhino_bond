import 'package:flutter/material.dart';
import 'package:rhino_bond/models/redemption_product.dart';
import 'package:rhino_bond/widgets/custom_app_drawer.dart' show CustomAppDrawer;
import 'package:rhino_bond/widgets/appbar.dart' show CustomAppBar;
import 'package:provider/provider.dart';
import 'package:rhino_bond/notifiers/redemption_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rhino_bond/utils/logger.dart';
import 'package:rhino_bond/screens/scanner/scanner_screen.dart';

class RewardProductsScreen extends StatefulWidget {
  const RewardProductsScreen({super.key});

  @override
  _RewardProductsScreenState createState() => _RewardProductsScreenState();
}

class _RewardProductsScreenState extends State<RewardProductsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

      Logger.info('Fetched products: $response'); // Debug log

      final products = (response as List)
          .map((product) => RedemptionProduct.fromJson(product))
          .toList();

      Logger.info('Mapped products: $products'); // Debug log
      return products;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        showBackButton: true,
      ),
      drawer: CustomAppDrawer(),
      endDrawer: CustomAppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
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

                  final products = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 24, bottom: 100),
                      itemCount: products.length + 1,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: Text(
                                'Redeem Products',
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
                          );
                        }
                        final product = products[index - 1];
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.surface,
                                  Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Image
                                  Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.1),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.card_giftcard,
                                        size: 60,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Product Details
                                  Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                  ),
                                  const SizedBox(height: 8),

                                  Text(
                                    product.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.8),
                                        ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Points and Action
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${product.pointsRequired} points',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        elevation: 0,
                                        animationDuration:
                                            const Duration(milliseconds: 200),
                                      ).copyWith(
                                        overlayColor: WidgetStateProperty
                                            .resolveWith<Color?>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.hovered)) {
                                              return Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.8);
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      onPressed: () async {
                                        final user = _supabase.auth.currentUser;
                                        if (user == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Please login to redeem products'),
                                            ),
                                          );
                                          return;
                                        }

                                        final redemptionNotifier =
                                            Provider.of<RedemptionNotifier>(
                                                context,
                                                listen: false);

                                        // Get current user points
                                        final userResponse = await _supabase
                                            .from('users')
                                            .select('points_balance')
                                            .eq('id', user.id)
                                            .single();

                                        final userPoints =
                                            userResponse['points_balance']
                                                as int;

                                        if (userPoints <
                                            product.pointsRequired) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Insufficient points. You need ${product.pointsRequired - userPoints} more points'),
                                            ),
                                          );
                                          return;
                                        }

                                        if (product.stock <= 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Product out of stock'),
                                            ),
                                          );
                                          return;
                                        }

                                        await redemptionNotifier.redeemProduct(
                                          productId: product.id,
                                          points: product.pointsRequired,
                                        );

                                        if (redemptionNotifier.error != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  redemptionNotifier.error!),
                                            ),
                                          );
                                        } else {
                                          // Refresh products
                                          setState(() {
                                            _productsFuture =
                                                _fetchRedemptionProducts();
                                          });

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Successfully redeemed ${product.name}'),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Redeem Now',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScannerScreen(),
            ),
          );
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan QR'),
      ),
    );
  }
}
