import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const List<Map<String, dynamic>> _orders = [
    {
      'number': '#ORD-2024-001',
      'date': 'Jun 10, 2024',
      'status': 'Delivered',
      'total': 249.99,
      'items': 3,
    },
    {
      'number': '#ORD-2024-002',
      'date': 'Jun 08, 2024',
      'status': 'Shipped',
      'total': 129.50,
      'items': 1,
    },
    {
      'number': '#ORD-2024-003',
      'date': 'May 28, 2024',
      'status': 'Processing',
      'total': 459.00,
      'items': 2,
    },
    {
      'number': '#ORD-2024-004',
      'date': 'May 15, 2024',
      'status': 'Cancelled',
      'total': 89.99,
      'items': 1,
    },
    {
      'number': '#ORD-2024-005',
      'date': 'May 02, 2024',
      'status': 'Delivered',
      'total': 314.75,
      'items': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: _orders.isEmpty
          ? _buildEmptyState(context, theme)
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
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
                              Text(
                                order['number'] as String,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _StatusBadge(status: order['status'] as String),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: theme.colorScheme.onSurface.withAlpha(120),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                order['date'] as String,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(150),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 16,
                                color: theme.colorScheme.onSurface.withAlpha(120),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${order['items']} items',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(150),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(150),
                                ),
                              ),
                              Text(
                                '\$${(order['total'] as double).toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: theme.colorScheme.onSurface.withAlpha(100),
          ),
          const SizedBox(height: 16),
          Text(
            'No orders yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed('/product-list'),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor;
    Color foregroundColor;

    switch (status) {
      case 'Delivered':
        backgroundColor = Colors.black;
        foregroundColor = Colors.white;
      case 'Cancelled':
        backgroundColor = theme.colorScheme.error.withAlpha(20);
        foregroundColor = theme.colorScheme.error;
      case 'Shipped':
      case 'Processing':
      default:
        backgroundColor = const Color(0xFFF2F2F2);
        foregroundColor = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: theme.textTheme.bodySmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
