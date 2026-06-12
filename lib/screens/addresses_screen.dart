import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  static const List<Map<String, dynamic>> _addresses = [
    {
      'name': 'Home',
      'recipient': 'John Doe',
      'street': '123 Main Street, Apt 4B',
      'city': 'New York, NY 10001',
      'country': 'United States',
      'phone': '+1 (555) 123-4567',
      'isDefault': true,
    },
    {
      'name': 'Office',
      'recipient': 'John Doe',
      'street': '456 Business Ave, Floor 12',
      'city': 'New York, NY 10018',
      'country': 'United States',
      'phone': '+1 (555) 987-6543',
      'isDefault': false,
    },
    {
      'name': 'Parents',
      'recipient': 'Mary Doe',
      'street': '789 Oak Lane',
      'city': 'Brooklyn, NY 11201',
      'country': 'United States',
      'phone': '+1 (555) 456-7890',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      SolarIconsOutline.mapPoint,
                                      size: 20,
                                      color: theme.colorScheme.onSurface.withAlpha(180),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    address['name'] as String,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (address['isDefault'] as bool)
                                _DefaultBadge(theme: theme),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            address['recipient'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address['street'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(150),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            address['city'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(150),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            address['country'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(150),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                SolarIconsOutline.phone,
                                size: 16,
                                color: theme.colorScheme.onSurface.withAlpha(120),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                address['phone'] as String,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(150),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16).copyWith(bottom: 100),
            color: theme.colorScheme.surface,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(SolarIconsOutline.plus),
                label: const Text('Add New Address'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultBadge extends StatelessWidget {
  final ThemeData theme;

  const _DefaultBadge({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Default',
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
