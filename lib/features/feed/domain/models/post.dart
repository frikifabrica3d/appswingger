class Post {
  final String id;
  final String userId;
  final String username;
  final String userAvatarUrl;
  final String imageUrl;
  final String caption;
  final DateTime timestamp;
  final int likesCount;
  final int commentsCount;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.userAvatarUrl,
    required this.imageUrl,
    required this.caption,
    required this.timestamp,
    required this.likesCount,
    required this.commentsCount,
  });
}
