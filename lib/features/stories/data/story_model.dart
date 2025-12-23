class StoryModel {
  final String id;
  final String userId;
  final String username;
  final String userAvatar;
  final String imageUrl;
  final DateTime createdAt;
  final Duration duration;
  bool isViewed;

  StoryModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userAvatar,
    required this.imageUrl,
    required this.createdAt,
    this.duration = const Duration(seconds: 5),
    this.isViewed = false,
  });

  bool get isExpired {
    final now = DateTime.now();
    return now.difference(createdAt).inHours >= 24;
  }
}

// Dummy Data
final List<StoryModel> dummyStories = [
  StoryModel(
    id: '1',
    userId: 'u2',
    username: 'Ana García',
    userAvatar: 'https://picsum.photos/seed/u2/100',
    imageUrl: 'https://picsum.photos/seed/story1/800/1200',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    isViewed: false,
  ),
  StoryModel(
    id: '2',
    userId: 'u2',
    username: 'Ana García',
    userAvatar: 'https://picsum.photos/seed/u2/100',
    imageUrl: 'https://picsum.photos/seed/story2/800/1200',
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    isViewed: false,
  ),
  StoryModel(
    id: '3',
    userId: 'u3',
    username: 'Carlos Ruiz',
    userAvatar: 'https://picsum.photos/seed/u3/100',
    imageUrl: 'https://picsum.photos/seed/story3/800/1200',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    isViewed: true,
  ),
  StoryModel(
    id: '4',
    userId: 'u4',
    username: 'Lucía M.',
    userAvatar: 'https://picsum.photos/seed/u4/100',
    imageUrl: 'https://picsum.photos/seed/story4/800/1200',
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    isViewed: false,
  ),
];
