import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'package:rhino_bond/notifiers/authentication.notifier.dart';
import 'package:rhino_bond/l10n/localization.dart';

class CustomAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userData?['name'] ?? ''),
            accountEmail: Text(userData?['email'] ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: userData?['avatarUrl'] != null
                  ? NetworkImage(userData!['avatarUrl'])
                  : null,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(AppLocalizations.of(context).home),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('Rewards'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/rewards');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('User Details'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/user-details');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(AppLocalizations.of(context).settingsTitle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text(AppLocalizations.of(context).contactFAQTitle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/contact_faq');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(AppLocalizations.of(context).logout,
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              final authNotifier = Provider.of<AuthenticationNotifier>(
                context,
                listen: false,
              );
              await authNotifier.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/send_otp',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
