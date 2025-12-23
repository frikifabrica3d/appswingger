import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import '../../domain/models/post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  final String? heroTag;

  const PostDetailPage({super.key, required this.post, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicación')),
      body: SingleChildScrollView(
        child: PostCard(post: post, heroTag: heroTag),
      ),
    );
  }
}
