import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../models/app_notification.dart';

class NotificationService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Mock stream controller for real-time updates
  final _notificationsController =
      StreamController<List<AppNotification>>.broadcast();
  Stream<List<AppNotification>> get notificationsStream =>
      _notificationsController.stream;

  List<AppNotification> _currentNotifications = [];

  void dispose() {
    _notificationsController.close();
    _audioPlayer.dispose();
  }

  // Simulate fetching notifications
  Future<List<AppNotification>> fetchNotifications() async {
    // In a real app, this would be an API call
    await Future.delayed(const Duration(seconds: 1));

    _currentNotifications = [
      AppNotification(
        id: 'notif_1',
        type: NotificationType.MATCH,
        title: '¡Nuevo Match!',
        body: 'Hiciste match con @LadySwingo 🔥',
        username: 'LadySwingo',
        avatarUrl: 'https://picsum.photos/seed/lady/200',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        referenceId: 'chat_001',
        fromUserId: 'user_001', // Link a LadySwingo
      ),
      AppNotification(
        id: 'notif_2',
        type: NotificationType.LIKE,
        title: '@CarlosYAna le gustó tu foto',
        body: '',
        username: 'Carlos y Ana',
        avatarUrl: 'https://picsum.photos/seed/couple1/200',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        referenceId: 'post_101',
        fromUserId: 'user_002', // Link a Carlos y Ana
      ),
      AppNotification(
        id: 'notif_3',
        type: NotificationType.COMMENT,
        title: '@ClubParaiso comentó tu post',
        body: '"¡Os esperamos este sábado! 🥂"',
        username: 'Club Paraíso',
        avatarUrl: 'https://picsum.photos/seed/club/200',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        referenceId: 'post_103',
        fromUserId: 'user_004', // Link a Club Paraíso
      ),
      AppNotification(
        id: 'notif_4',
        type: NotificationType.MESSAGE,
        title: 'Nuevo mensaje de @VanesaFree',
        body: '¿Os apetece tomar algo el finde?',
        username: 'Vanesa Free',
        avatarUrl: 'https://picsum.photos/seed/vanesa/200',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
        referenceId: 'chat_002',
        fromUserId: 'user_003', // Link a Vanesa Free
      ),
    ];

    _notificationsController.add(_currentNotifications);
    return _currentNotifications;
  }

  Future<void> markAsRead(String id) async {
    final index = _currentNotifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _currentNotifications[index].isRead = true;
      _notificationsController.add(_currentNotifications);
    }
  }

  Future<void> markAllAsRead() async {
    for (var n in _currentNotifications) {
      n.isRead = true;
    }
    _notificationsController.add(_currentNotifications);
  }

  Future<void> deleteReadNotifications() async {
    _currentNotifications.removeWhere((n) => n.isRead);
    _notificationsController.add(_currentNotifications);
  }

  Future<void> playNotificationSound() async {
    // Ensure you have a sound file at assets/sounds/notification.mp3
    // For now we'll just log it or try to play a default if available
    try {
      // await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}
