enum UserStatus { online, offline, away, custom }

class ChatUser {
  final String id;
  final String name;
  final String avatarUrl;
  final UserStatus status;
  final String? customStatus;

  const ChatUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.status = UserStatus.offline,
    this.customStatus,
  });
}

class Conversation {
  final String id;
  final List<ChatUser> users;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isGroup;
  final bool isTyping;

  const Conversation({
    required this.id,
    required this.users,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.isGroup = false,
    this.isTyping = false,
  });

  // Helper to get the display name (other user's name or group name)
  String getDisplayName(String currentUserId) {
    if (isGroup) {
      // Logic for group name could be here, for now just join names
      return users.map((u) => u.name).join(', ');
    }
    // Return the name of the first user that isn't the current user
    final otherUser = users.firstWhere(
      (u) => u.id != currentUserId,
      orElse: () => users.first,
    );
    return otherUser.name;
  }

  // Helper to get the display avatar
  String getDisplayAvatar(String currentUserId) {
    final otherUser = users.firstWhere(
      (u) => u.id != currentUserId,
      orElse: () => users.first,
    );
    return otherUser.avatarUrl;
  }

  // Helper to get the status of the other user
  UserStatus getDisplayStatus(String currentUserId) {
    final otherUser = users.firstWhere(
      (u) => u.id != currentUserId,
      orElse: () => users.first,
    );
    return otherUser.status;
  }
}
