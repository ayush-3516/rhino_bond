import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/widgets/providers/user_provider.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Center(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'User Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (userProvider.userData != null) ...[
                    ListTile(
                      title: const Text('ID'),
                      subtitle: Text(userProvider.userData!['id']?.toString() ??
                          'Not available'),
                    ),
                    ListTile(
                      title: const Text('Name'),
                      subtitle: Text(
                          userProvider.userData!['name']?.toString() ??
                              'Not available'),
                    ),
                    ListTile(
                      title: const Text('Email'),
                      subtitle: Text(
                          userProvider.userData!['email']?.toString() ??
                              'Not available'),
                    ),
                    ListTile(
                      title: const Text('Phone'),
                      subtitle: Text(
                          userProvider.userData!['phone']?.toString() ??
                              'Not provided'),
                    ),
                    ListTile(
                      title: const Text('PAN Card'),
                      subtitle: Text(
                          userProvider.userData!['pan_card']?.toString() ??
                              'Not provided'),
                    ),
                    ListTile(
                      title: const Text('KYC Status'),
                      subtitle: Text(
                          userProvider.userData!['kyc_status'] != null
                              ? (userProvider.userData!['kyc_status']
                                  ? 'Verified'
                                  : 'Not Verified')
                              : 'Not available'),
                    ),
                    ListTile(
                      title: const Text('Points Balance'),
                      subtitle: Text(userProvider.userData!['points_balance']
                              ?.toString() ??
                          'Not available'),
                    ),
                    ListTile(
                      title: const Text('Role'),
                      subtitle: Text(
                          userProvider.userData!['role']?.toString() ??
                              'Not available'),
                    ),
                    ListTile(
                      title: const Text('Account Status'),
                      subtitle: Text(userProvider.userData!['is_active'] != null
                          ? (userProvider.userData!['is_active']
                              ? 'Active'
                              : 'Inactive')
                          : 'Not available'),
                    ),
                    ListTile(
                      title: const Text('Created At'),
                      subtitle: Text(userProvider.userData!['created_at'] !=
                              null
                          ? DateTime.parse(userProvider.userData!['created_at'])
                              .toString()
                          : 'Not available'),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
