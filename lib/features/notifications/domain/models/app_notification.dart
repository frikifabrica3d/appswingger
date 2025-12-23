enum NotificationType {
  LIKE,
  COMMENT,
  MATCH,
  MESSAGE,
  ANNOUNCEMENT,
  FORUM_REPLY,
  TICKET_UPDATE,
  SYSTEM,
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final String? username;
  final String? avatarUrl;
  final DateTime timestamp;
  bool isRead;
  final String? referenceId;
  final String fromUserId;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.fromUserId,
    this.username,
    this.avatarUrl,
    this.isRead = false,
    this.referenceId,
  });
}
