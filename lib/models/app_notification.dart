enum NotificationType {
  order,
  promotion,
  payment,
  system,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final NotificationType type;
  final bool isRead;
  final String? actionRoute;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
    this.actionRoute,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      timeAgo: timeAgo,
      type: type,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute,
    );
  }
}
