import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

import '../data/mock_notifications.dart';
import '../models/app_notification.dart';

enum _NotificationFilter {
  all('All'),
  orders('Orders'),
  promotions('Promotions'),
  system('System');

  final String label;
  const _NotificationFilter(this.label);
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<AppNotification> _notifications;
  _NotificationFilter _selectedFilter = _NotificationFilter.all;

  @override
  void initState() {
    super.initState();
    _notifications = List<AppNotification>.from(mockNotifications);
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<AppNotification> get _filteredNotifications {
    return switch (_selectedFilter) {
      _NotificationFilter.all => _notifications,
      _NotificationFilter.orders =>
        _notifications.where((n) => n.type == NotificationType.order).toList(),
      _NotificationFilter.promotions =>
        _notifications.where((n) => n.type == NotificationType.promotion).toList(),
      _NotificationFilter.system =>
        _notifications.where((n) => n.type == NotificationType.system).toList(),
    };
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();
    });
  }

  void _markAsRead(String id) {
    setState(() {
      _notifications = _notifications
          .map(
            (notification) => notification.id == id
                ? notification.copyWith(isRead: true)
                : notification,
          )
          .toList();
    });
  }

  void _onNotificationTap(AppNotification notification) {
    _markAsRead(notification.id);

    final route = notification.actionRoute;
    if (route != null) {
      Navigator.of(context).pushNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredNotifications = _filteredNotifications;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notifications'),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_unreadCount',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: _NotificationFilter.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _NotificationFilter.values[index];
                final isSelected = filter == _selectedFilter;
                final count = switch (filter) {
                  _NotificationFilter.all => _notifications.length,
                  _NotificationFilter.orders => _notifications
                      .where((n) => n.type == NotificationType.order)
                      .length,
                  _NotificationFilter.promotions => _notifications
                      .where((n) => n.type == NotificationType.promotion)
                      .length,
                  _NotificationFilter.system => _notifications
                      .where((n) => n.type == NotificationType.system)
                      .length,
                };

                return FilterChip(
                  label: Text('${filter.label} ($count)'),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedFilter = filter);
                  },
                  showCheckmark: false,
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                  ),
                  backgroundColor: const Color(0xFFF2F2F2),
                  selectedColor: Colors.black,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                );
              },
            ),
          ),
          Expanded(
            child: filteredNotifications.isEmpty
                ? _EmptyState(filter: _selectedFilter)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _NotificationTile(
                        notification: notification,
                        onTap: () => _onNotificationTap(notification),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnread
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnread
                ? Colors.black.withAlpha(40)
                : theme.colorScheme.onSurface.withAlpha(20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotificationIcon(type: notification.type),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(160),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        SolarIconsOutline.clockCircle,
                        size: 14,
                        color: theme.colorScheme.onSurface.withAlpha(120),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        notification.timeAgo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(140),
                        ),
                      ),
                      if (notification.actionRoute != null) ...[
                        const Spacer(),
                        Text(
                          'View',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          SolarIconsOutline.altArrowRight,
                          size: 14,
                          color: theme.colorScheme.onSurface.withAlpha(160),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final NotificationType type;

  const _NotificationIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (icon, backgroundColor, iconColor) = switch (type) {
      NotificationType.order => (
          SolarIconsOutline.delivery,
          Colors.black,
          Colors.white,
        ),
      NotificationType.promotion => (
          SolarIconsOutline.tag,
          const Color(0xFFF2F2F2),
          theme.colorScheme.onSurface,
        ),
      NotificationType.payment => (
          SolarIconsOutline.wallet,
          const Color(0xFFF2F2F2),
          theme.colorScheme.onSurface,
        ),
      NotificationType.system => (
          SolarIconsOutline.bell,
          const Color(0xFFF2F2F2),
          theme.colorScheme.onSurface,
        ),
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, size: 22, color: iconColor),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final _NotificationFilter filter;

  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              SolarIconsOutline.bell,
              size: 80,
              color: theme.colorScheme.onSurface.withAlpha(100),
            ),
            const SizedBox(height: 24),
            Text(
              'No ${filter.label.toLowerCase()} notifications',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You are all caught up. New updates will appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
