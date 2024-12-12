import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final userData = userProvider.userData;
              return DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: userData?.avatarUrl != null
                          ? NetworkImage(userData!.avatarUrl!)
                          : null,
                      child: userData?.avatarUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userData?.name ?? 'Guest User',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData?.id ?? 'No ID',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('Reward Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/reward-products');
            },
          ),
          ListTile(
            leading: const Icon(Icons.stars),
            title: const Text('My Rewards'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/my-rewards');
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('KYC Request'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/kyc-request');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Redeem History'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/redeem-history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('QR Scanner'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/qr-scanner');
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/contact-us');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('My Account'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/my-account');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              // Implement logout logic
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
