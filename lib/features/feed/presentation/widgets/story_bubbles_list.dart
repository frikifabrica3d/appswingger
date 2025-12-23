import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryBubblesList extends StatelessWidget {
  const StoryBubblesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemBuilder: (context, index) {
          return _StoryBubble(
            imageUrl: 'https://picsum.photos/seed/story$index/200',
            username: 'User $index',
            isMe: index == 0,
          );
        },
      ),
    );
  }
}

class _StoryBubble extends StatelessWidget {
  final String imageUrl;
  final String username;
  final bool isMe;

  const _StoryBubble({
    required this.imageUrl,
    required this.username,
    this.isMe = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isMe
                      ? null
                      : const LinearGradient(
                          colors: [Colors.purple, Colors.orange],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                  border: isMe
                      ? Border.all(color: Colors.grey.shade300, width: 2)
                      : null,
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: CachedNetworkImageProvider(imageUrl),
                  ),
                ),
              ),
              if (isMe)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            isMe ? 'Tu historia' : username,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
