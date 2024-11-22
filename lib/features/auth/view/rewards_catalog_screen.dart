import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';

class RewardsCatalogScreen extends StatefulWidget {
  @override
  _RewardsCatalogScreenState createState() => _RewardsCatalogScreenState();
}

class _RewardsCatalogScreenState extends State<RewardsCatalogScreen> {
  List<dynamic> _rewards = [];

  @override
  void initState() {
    super.initState();
    _fetchRewards();
  }

  Future<void> _fetchRewards() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    try {
      final response = await ApiService.getRewardsCatalog(token);
      setState(() {
        _rewards = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch rewards: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards Catalog'),
      ),
      body: ListView.builder(
        itemCount: _rewards.length,
        itemBuilder: (context, index) {
          final reward = _rewards[index];
          return ListTile(
            title: Text(reward['name']),
            subtitle: Text('Points: ${reward['points']}'),
          );
        },
      ),
    );
  }
}
