import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'package:rhino_bond/notifiers/authentication.notifier.dart';
import 'package:rhino_bond/l10n/localization.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    bool isLogout = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = ModalRoute.of(context)?.settings.name == route;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          isActive ? activeIcon : icon,
          color: isLogout
              ? colorScheme.error
              : isActive
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface.withOpacity(0.8),
        ),
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isLogout
                    ? colorScheme.error
                    : isActive
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
              ),
        ),
        minLeadingWidth: 24,
        horizontalTitleGap: 12,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () async {
          if (isLogout) {
            final authNotifier = Provider.of<AuthenticationNotifier>(
              context,
              listen: false,
            );
            await authNotifier.logout();
          } else if (route.isNotEmpty) {
            Navigator.pop(context);
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: userData?['avatarUrl'] != null
                      ? NetworkImage(userData!['avatarUrl'])
                      : null,
                  child: userData?['avatarUrl'] == null
                      ? Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  userData?['name'] ?? '',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  userData?['email'] ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: AppLocalizations.of(context).home,
                  route: '/home',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.card_giftcard_outlined,
                  activeIcon: Icons.card_giftcard,
                  label: 'Rewards',
                  route: '/rewards',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'User Details',
                  route: '/user-details',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: AppLocalizations.of(context).settingsTitle,
                  route: '/settings',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.edit_outlined,
                  activeIcon: Icons.edit,
                  label: 'Edit Profile',
                  route: '/edit_profile',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.help_outline,
                  activeIcon: Icons.help,
                  label: AppLocalizations.of(context).contactFAQTitle,
                  route: '/contact_faq',
                ),
                const SizedBox(height: 8),
                const Divider(indent: 16, endIndent: 16),
                const SizedBox(height: 8),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout_outlined,
                  activeIcon: Icons.logout,
                  label: AppLocalizations.of(context).logout,
                  route: '',
                  isLogout: true,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Image.asset(
                      'lib/assets/GPR LOGO.png',
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
