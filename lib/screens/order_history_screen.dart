import 'package:flutter/material.dart';

import '../models/order.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  static const List<Order> _orders = [
    Order(
      id: '#ORD-2024-001',
      date: 'Jun 10, 2024',
      status: 'Delivered',
      total: 249.99,
      shippingAddress: '123 Main Street, Apt 4B\nNew York, NY 10001',
      paymentMethod: 'Visa ending in 4242',
      items: [
        OrderItem(name: 'Wireless Headphones', imageUrl: '', price: 199.99, quantity: 1),
        OrderItem(name: 'Phone Case', imageUrl: '', price: 25.00, quantity: 2),
      ],
    ),
    Order(
      id: '#ORD-2024-002',
      date: 'Jun 08, 2024',
      status: 'Shipped',
      total: 129.50,
      shippingAddress: '456 Business Ave, Floor 12\nNew York, NY 10018',
      paymentMethod: 'Mastercard ending in 8888',
      items: [
        OrderItem(name: 'Running Shoes', imageUrl: '', price: 129.50, quantity: 1),
      ],
    ),
    Order(
      id: '#ORD-2024-003',
      date: 'May 28, 2024',
      status: 'Processing',
      total: 459.00,
      shippingAddress: '123 Main Street, Apt 4B\nNew York, NY 10001',
      paymentMethod: 'Visa ending in 4242',
      items: [
        OrderItem(name: 'Smart Watch', imageUrl: '', price: 299.00, quantity: 1),
        OrderItem(name: 'Sport Band', imageUrl: '', price: 80.00, quantity: 2),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
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
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(
                      '/order-detail',
                      arguments: order,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.onSurface.withAlpha(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.id,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _StatusBadge(status: order.status),
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
                                order.date,
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
                                '${order.items.length} items',
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
                                '\$${order.total.toStringAsFixed(2)}',
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

    final (backgroundColor, foregroundColor) = switch (status) {
      'Delivered' => (Colors.black, Colors.white),
      'Cancelled' => (theme.colorScheme.error.withAlpha(20), theme.colorScheme.error),
      _ => (const Color(0xFFF2F2F2), Colors.black),
    };

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
