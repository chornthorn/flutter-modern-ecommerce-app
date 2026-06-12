import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  static const List<Map<String, dynamic>> _cards = [
    {
      'type': 'Visa',
      'last4': '4242',
      'expiry': '12/26',
      'holder': 'John Doe',
      'isDefault': true,
    },
    {
      'type': 'Mastercard',
      'last4': '8888',
      'expiry': '09/25',
      'holder': 'John Doe',
      'isDefault': false,
    },
    {
      'type': 'Amex',
      'last4': '0005',
      'expiry': '03/27',
      'holder': 'John Doe',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _cardIcon(card['type'] as String),
                              size: 24,
                              color: theme.colorScheme.onSurface.withAlpha(180),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      card['type'] as String,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (card['isDefault'] as bool)
                                      _DefaultBadge(theme: theme),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '•••• •••• •••• ${card['last4']}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withAlpha(150),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Expires ${card['expiry']} • ${card['holder']}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withAlpha(120),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              SolarIconsOutline.menuDots,
                              color: theme.colorScheme.onSurface.withAlpha(120),
                            ),
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
                label: const Text('Add New Card'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _cardIcon(String type) {
    switch (type) {
      case 'Visa':
        return SolarIconsOutline.card;
      case 'Mastercard':
        return SolarIconsOutline.card;
      case 'Amex':
        return SolarIconsOutline.card;
      default:
        return SolarIconsOutline.card;
    }
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
