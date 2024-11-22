import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rhino_bond/models/reward.dart';
import 'package:rhino_bond/widgets/reward_card.dart';
import 'package:rhino_bond/widgets/app_drawer.dart';
import 'package:rhino_bond/appbar.dart';

class RewardProductsScreen extends StatefulWidget {
  const RewardProductsScreen({Key? key}) : super(key: key);

  @override
  _RewardProductsScreenState createState() => _RewardProductsScreenState();
}

class _RewardProductsScreenState extends State<RewardProductsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Electronics', 'Fashion', 'Food', 'Travel', 'Entertainment', 'Wellness'];
  
  // TODO: Replace with actual data from API
  final List<Reward> _rewards = [
    Reward(
      id: '1',
      title: 'Wireless Earbuds',
      description: 'High-quality wireless earbuds with noise cancellation',
      points: 5000,
      imageUrl: 'assets/images/earbuds.png',
      category: 'Electronics',
    ),
    Reward(
      id: '2',
      title: 'Premium Coffee',
      description: 'Enjoy a free premium coffee at any of our partner cafes.',
      points: 50,
      imageUrl: 'assets/images/coffee.png',
      category: 'Food',
    ),
    Reward(
      id: '3',
      title: 'Movie Tickets',
      description: 'Get two movie tickets for any show at partner cinemas.',
      points: 100,
      imageUrl: 'assets/images/movie.png',
      category: 'Entertainment',
    ),
    Reward(
      id: '4',
      title: 'Shopping Voucher',
      description: 'R500 shopping voucher at selected retail stores.',
      points: 200,
      imageUrl: 'assets/images/shopping.png',
      category: 'Fashion',
    ),
    Reward(
      id: '5',
      title: 'Spa Day',
      description: 'Relaxing spa day package at luxury wellness centers.',
      points: 300,
      imageUrl: 'assets/images/spa.png',
      category: 'Wellness',
    ),
    Reward(
      id: '6',
      title: 'Adventure Package',
      description: 'Exciting outdoor adventure experience for two.',
      points: 400,
      imageUrl: 'assets/images/adventure.png',
      category: 'Travel',
    ),
  ];

  List<Reward> get _filteredRewards {
    if (_selectedCategory == 'All') {
      return _rewards;
    }
    return _rewards.where((reward) => reward.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Rewards',
        scaffoldKey: _scaffoldKey,
      ),
      endDrawer: const AppDrawer(),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: _filteredRewards.length,
                itemBuilder: (context, index) {
                  final reward = _filteredRewards[index];
                  return RewardCard(reward: reward);
                },
              ),
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
