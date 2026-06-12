import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    DateTime baseDate;
    try {
      baseDate = DateFormat('MMM d, y').parse(order.date);
    } catch (_) {
      baseDate = DateTime.now();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Placed on ${order.date}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(150),
                ),
              ),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Status'),
              const SizedBox(height: 12),
              _StatusTimeline(status: order.status, orderDate: baseDate),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Items'),
              const SizedBox(height: 12),
              ...order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withAlpha(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.shopping_bag_outlined),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Qty: ${item.quantity}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(150),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Shipping Address'),
              const SizedBox(height: 12),
              _InfoCard(content: order.shippingAddress),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Payment Method'),
              const SizedBox(height: 12),
              _InfoCard(content: order.paymentMethod),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Order Summary'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withAlpha(20),
                  ),
                ),
                child: Column(
                  children: [
                    _SummaryRow(label: 'Subtotal', value: '\$${order.total.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _SummaryRow(label: 'Shipping', value: 'Free'),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: 'Total',
                      value: '\$${order.total.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
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

class _StatusTimeline extends StatelessWidget {
  final String status;
  final DateTime orderDate;

  const _StatusTimeline({
    required this.status,
    required this.orderDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, h:mm a');
    final steps = [
      _TimelineStep(
        title: 'Ordered',
        subtitle: 'Order placed successfully',
        icon: Icons.receipt_outlined,
        time: orderDate.copyWith(hour: 9, minute: 0),
      ),
      _TimelineStep(
        title: 'Processing',
        subtitle: 'Order is being prepared',
        icon: Icons.inventory_2_outlined,
        time: orderDate.copyWith(hour: 14, minute: 30),
      ),
      _TimelineStep(
        title: 'Shipped',
        subtitle: 'Order is on the way',
        icon: Icons.local_shipping_outlined,
        time: orderDate.add(const Duration(days: 1)).copyWith(hour: 8, minute: 15),
      ),
      _TimelineStep(
        title: 'Delivered',
        subtitle: 'Order has been delivered',
        icon: Icons.check_circle_outline,
        time: orderDate.add(const Duration(days: 2)).copyWith(hour: 16, minute: 45),
      ),
    ];
    final activeIndex = switch (status) {
      'Cancelled' => -1,
      'Processing' => 1,
      'Shipped' => 2,
      'Delivered' => 3,
      _ => 0,
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(20),
        ),
      ),
      child: Column(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isActive = index <= activeIndex;
          final isLast = index == steps.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.black : theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive ? Colors.black : theme.colorScheme.onSurface.withAlpha(40),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        step.icon,
                        size: 16,
                        color: isActive ? Colors.white : theme.colorScheme.onSurface.withAlpha(100),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: index < activeIndex
                              ? Colors.black
                              : theme.colorScheme.onSurface.withAlpha(40),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            step.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                              color: isActive
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurface.withAlpha(100),
                            ),
                          ),
                          Text(
                            dateFormat.format(step.time),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isActive
                                  ? theme.colorScheme.onSurface.withAlpha(150)
                                  : theme.colorScheme.onSurface.withAlpha(100),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isActive
                              ? theme.colorScheme.onSurface.withAlpha(150)
                              : theme.colorScheme.onSurface.withAlpha(100),
                        ),
                      ),
                      if (!isLast) const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TimelineStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final DateTime time;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.time,
  });
}

class _InfoCard extends StatelessWidget {
  final String content;

  const _InfoCard({required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(20),
        ),
      ),
      child: Text(
        content,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withAlpha(150),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isTotal ? null : theme.colorScheme.onSurface.withAlpha(150),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
