import 'package:flutter/material.dart';
import '../../stories/presentation/widgets/stories_bar.dart';
import 'widgets/post_card.dart';
import '../domain/models/post.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadDummyPosts();
  }

  void _loadDummyPosts() {
    _posts.addAll([
      Post(
        id: 'post_101',
        userId: 'user_001', // LadySwingo
        username: 'LadySwingo',
        userAvatarUrl: 'https://picsum.photos/seed/lady/200',
        imageUrl: 'https://picsum.photos/seed/post101/600/750',
        caption:
            'Noche increíble en el club! 💃 Lista para la próxima aventura.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        likesCount: 120,
        commentsCount: 15,
      ),
      Post(
        id: 'post_102',
        userId: 'user_002', // Carlos y Ana
        username: 'Carlos y Ana',
        userAvatarUrl: 'https://picsum.photos/seed/couple1/200',
        imageUrl: 'https://picsum.photos/seed/post102/600/800',
        caption: 'Disfrutando de una cena romántica antes de la fiesta 🍷',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 85,
        commentsCount: 8,
      ),
      Post(
        id: 'post_103',
        userId: 'user_004', // Club Paraíso
        username: 'Club Paraíso',
        userAvatarUrl: 'https://picsum.photos/seed/club/200',
        imageUrl: 'https://picsum.photos/seed/post103/600/600',
        caption: '¡Este viernes tenemos evento especial! No faltéis 🎭',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likesCount: 340,
        commentsCount: 42,
      ),
      Post(
        id: 'post_104',
        userId: 'user_003', // Vanesa Free
        username: 'Vanesa Free',
        userAvatarUrl: 'https://picsum.photos/seed/vanesa/200',
        imageUrl: 'https://picsum.photos/seed/post104/600/900',
        caption: 'Conectando con la naturaleza 🌿',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        likesCount: 210,
        commentsCount: 20,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          _posts.clear();
          _loadDummyPosts();
        });
      },
      child: ListView.builder(
        itemCount: _posts.length + 1, // 1 para historias
        itemBuilder: (context, index) {
          if (index == 0) {
            return const StoriesBar();
          }
          final post = _posts[index - 1];
          return PostCard(post: post);
        },
      ),
    );
  }
}
