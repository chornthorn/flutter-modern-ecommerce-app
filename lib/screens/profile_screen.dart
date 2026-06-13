import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed('/settings'),
                    icon: const Icon(SolarIconsOutline.settings),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white,
                      child: Icon(
                        SolarIconsOutline.user,
                        size: 48,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'John Doe',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'john.doe@example.com',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _StatCard(
                    value: '12',
                    label: 'Orders',
                    theme: theme,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    value: '5',
                    label: 'Favorites',
                    theme: theme,
                    onTap: () => Navigator.of(context).pushNamed('/favorites'),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    value: '8',
                    label: 'Reviews',
                    theme: theme,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Account',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    _ProfileListTile(
                      icon: SolarIconsOutline.bag,
                      title: 'My Orders',
                      onTap: () => Navigator.of(context).pushNamed('/orders'),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _ProfileListTile(
                      icon: SolarIconsOutline.mapPoint,
                      title: 'Addresses',
                      onTap: () => Navigator.of(context).pushNamed('/addresses'),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _ProfileListTile(
                      icon: SolarIconsOutline.wallet,
                      title: 'Payment Methods',
                      onTap: () => Navigator.of(context).pushNamed('/payment-methods'),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _ProfileListTile(
                      icon: SolarIconsOutline.bell,
                      title: 'Notifications',
                      onTap: () => Navigator.of(context).pushNamed('/notifications'),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _ProfileListTile(
                      icon: SolarIconsOutline.settings,
                      title: 'Settings',
                      onTap: () => Navigator.of(context).pushNamed('/settings'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Support',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    _ProfileListTile(
                      icon: SolarIconsOutline.help,
                      title: 'Help Center',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: _ProfileListTile(
                  icon: SolarIconsOutline.logout,
                  title: 'Logout',
                  textColor: theme.colorScheme.error,
                  iconColor: theme.colorScheme.error,
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final ThemeData theme;
  final VoidCallback? onTap;

  const _StatCard({
    required this.value,
    required this.label,
    required this.theme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onSurface.withAlpha(20),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class _ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _ProfileListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor == null ? const Color(0xFFF2F2F2) : iconColor!.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? theme.colorScheme.onSurface.withAlpha(180),
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        SolarIconsOutline.altArrowRight,
        color: theme.colorScheme.onSurface.withAlpha(120),
      ),
      onTap: onTap,
    );
  }
}
