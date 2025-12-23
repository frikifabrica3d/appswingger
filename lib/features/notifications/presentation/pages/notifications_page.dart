import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import '../../domain/models/app_notification.dart';
import '../../domain/services/notification_service.dart';
import '../../../feed/domain/models/post.dart';
import '../../../feed/presentation/pages/post_detail_page.dart';
import '../../../chat/presentation/pages/chat_detail_page.dart';
import '../../../settings/presentation/pages/support_page.dart';
import '../../../../core/utils/navigation_utils.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _notificationService = NotificationService();
  late ConfettiController _confettiController;
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('es', timeago.EsMessages());
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _loadNotifications();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _notificationService.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    final notifications = await _notificationService.fetchNotifications();
    if (mounted) {
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    }
  }

  void _markAllAsRead() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          '¿Borrar notificaciones leídas?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Esta acción eliminará todas las notificaciones que ya has visto.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await _notificationService.deleteReadNotifications();
              if (context.mounted) {
                setState(() {}); // Refresh UI
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notificaciones leídas eliminadas'),
                  ),
                );
              }
            },
            child: const Text(
              'Borrar',
              style: TextStyle(color: Color(0xFFFF0040)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(AppNotification notification) {
    setState(() {
      notification.isRead = true;
    });

    if (notification.type == NotificationType.MATCH) {
      _confettiController.play();
    }

    switch (notification.type) {
      case NotificationType.LIKE:
      case NotificationType.COMMENT:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(
              post: Post(
                id: notification.referenceId ?? 'unknown',
                userId: notification.fromUserId,
                username: notification.username ?? 'Usuario',
                userAvatarUrl:
                    notification.avatarUrl ??
                    'https://picsum.photos/seed/default/200',
                imageUrl:
                    'https://picsum.photos/seed/${notification.referenceId}/400/600',
                caption: 'Publicación desde notificación',
                timestamp: DateTime.now(),
                likesCount: 0,
                commentsCount: 0,
              ),
              heroTag: 'notification_${notification.id}',
            ),
          ),
        );
        break;
      case NotificationType.MATCH:
      case NotificationType.MESSAGE:
        if (notification.username != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailPage(
                userName: notification.username!,
                userAvatar:
                    notification.avatarUrl ??
                    'https://picsum.photos/seed/default/200',
              ),
            ),
          );
        }
        break;
      case NotificationType.TICKET_UPDATE:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SupportPage()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navegando a ${notification.title}')),
        );
    }
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.LIKE:
        return Icons.favorite;
      case NotificationType.COMMENT:
        return Icons.comment;
      case NotificationType.MATCH:
        return Icons.local_fire_department;
      case NotificationType.MESSAGE:
        return Icons.chat_bubble;
      case NotificationType.ANNOUNCEMENT:
        return Icons.campaign;
      case NotificationType.FORUM_REPLY:
        return Icons.forum;
      case NotificationType.TICKET_UPDATE:
        return Icons.confirmation_number;
      case NotificationType.SYSTEM:
        return Icons.info;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.LIKE:
        return Colors.red;
      case NotificationType.COMMENT:
        return Colors.blue;
      case NotificationType.MATCH:
        return Colors.orange;
      case NotificationType.MESSAGE:
        return Colors.purple;
      case NotificationType.ANNOUNCEMENT:
        return Colors.amber;
      case NotificationType.FORUM_REPLY:
        return Colors.teal;
      case NotificationType.TICKET_UPDATE:
        return Colors.green;
      case NotificationType.SYSTEM:
        return Colors.grey;
    }
  }

  Map<String, List<AppNotification>> _groupNotifications() {
    final now = DateTime.now();
    final grouped = <String, List<AppNotification>>{
      'Hoy': [],
      'Ayer': [],
      'Esta Semana': [],
      'Anteriores': [],
    };

    for (var n in _notifications) {
      final diff = now.difference(n.timestamp);
      if (diff.inDays == 0 && n.timestamp.day == now.day) {
        grouped['Hoy']!.add(n);
      } else if (diff.inDays <= 1 &&
          n.timestamp.day == now.subtract(const Duration(days: 1)).day) {
        grouped['Ayer']!.add(n);
      } else if (diff.inDays < 7) {
        grouped['Esta Semana']!.add(n);
      } else {
        grouped['Anteriores']!.add(n);
      }
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupNotifications();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: _markAllAsRead,
            tooltip: 'Borrar leídas',
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF0040)),
            )
          else
            ListView(
              children: groupedNotifications.entries.map((entry) {
                if (entry.value.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ...entry.value.map(
                      (notification) => _buildNotificationTile(notification),
                    ),
                  ],
                );
              }).toList(),
            ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.orange,
                Colors.purple,
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(AppNotification notification) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        color: notification.isRead ? Colors.black : const Color(0xFF111111),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          onTap: () => _handleNotificationTap(notification),
          leading: Stack(
            children: [
              if (notification.avatarUrl != null)
                GestureDetector(
                  onTap: () {
                    NavigationUtils.navigateToProfile(
                      context,
                      notification.fromUserId,
                    );
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: CachedNetworkImageProvider(
                      notification.avatarUrl!,
                    ),
                  ),
                )
              else
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade900,
                  child: Icon(
                    _getIconForType(notification.type),
                    color: Colors.white,
                    size: 20,
                  ),
                ),

              if (notification.avatarUrl != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForType(notification.type),
                      color: _getColorForType(notification.type),
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          title: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              children: [
                TextSpan(
                  text: notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification.body.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    notification.body,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                timeago.format(notification.timestamp, locale: 'es'),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ),
          trailing: !notification.isRead
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF0040),
                    shape: BoxShape.circle,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
