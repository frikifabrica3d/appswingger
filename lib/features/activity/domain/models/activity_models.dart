enum MediaType { image, video, none }

class Announcement {
  final String id;
  final String title;
  final String content;
  final String? mediaUrl;
  final MediaType mediaType;
  final DateTime date;
  final int likes;
  final bool isOfficial;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    this.mediaUrl,
    this.mediaType = MediaType.none,
    required this.date,
    this.likes = 0,
    this.isOfficial = true,
  });
}

class ForumTopic {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String category; // General, Experiencias, Consejos, Locales
  final DateTime timestamp;
  final int votes;
  final int replyCount;

  const ForumTopic({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.category,
    required this.timestamp,
    this.votes = 0,
    this.replyCount = 0,
  });
}

class ForumReply {
  final String id;
  final String topicId;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime timestamp;
  final int votes;

  const ForumReply({
    required this.id,
    required this.topicId,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.timestamp,
    this.votes = 0,
  });
}
