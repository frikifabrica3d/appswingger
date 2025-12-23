import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/navigation_utils.dart';

class Comment {
  final String id;
  final String userId;
  final String username;
  final String userAvatarUrl;
  final String text;
  final DateTime timestamp;
  final int likesCount;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.userAvatarUrl,
    required this.text,
    required this.timestamp,
    required this.likesCount,
  });
}

class CommentsBottomSheet extends StatefulWidget {
  final int postId;

  const CommentsBottomSheet({super.key, required this.postId});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadDummyComments();
  }

  void _loadDummyComments() {
    _comments.addAll([
      Comment(
        id: '1',
        userId: 'u1',
        username: 'Ana García',
        userAvatarUrl: 'https://picsum.photos/seed/u1/100',
        text: '¡Me encanta esta foto! 😍',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 12,
      ),
      Comment(
        id: '2',
        userId: 'u2',
        username: 'Carlos Ruiz',
        userAvatarUrl: 'https://picsum.photos/seed/u2/100',
        text: 'El lugar se ve increíble, ¿dónde es?',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likesCount: 5,
      ),
      Comment(
        id: '3',
        userId: 'u3',
        username: 'Lucía M.',
        userAvatarUrl: 'https://picsum.photos/seed/u3/100',
        text: '🔥🔥🔥',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        likesCount: 3,
      ),
      Comment(
        id: '4',
        userId: 'u4',
        username: 'David K.',
        userAvatarUrl: 'https://picsum.photos/seed/u4/100',
        text: 'Totalmente de acuerdo contigo.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        likesCount: 8,
      ),
      Comment(
        id: '5',
        userId: 'u5',
        username: 'Elena V.',
        userAvatarUrl: 'https://picsum.photos/seed/u5/100',
        text: 'Espero verte pronto! 😊',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        likesCount: 1,
      ),
    ]);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(
        0,
        Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: 'me',
          username: 'Yo',
          userAvatarUrl: 'https://picsum.photos/seed/me/100',
          text: _commentController.text.trim(),
          timestamp: DateTime.now(),
          likesCount: 0,
        ),
      );
      _commentController.clear();
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} h';
    } else {
      return '${diff.inDays} d';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comentarios (${_comments.length})',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: textColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => NavigationUtils.navigateToProfile(
                          context,
                          comment.userId,
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: CachedNetworkImageProvider(
                            comment.userAvatarUrl,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                ),
                                children: [
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () =>
                                          NavigationUtils.navigateToProfile(
                                            context,
                                            comment.userId,
                                          ),
                                      child: Text(
                                        '${comment.username} ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextSpan(text: comment.text),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  _formatTimestamp(comment.timestamp),
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Responder',
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 16,
                            color: subtitleColor,
                          ),
                          if (comment.likesCount > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                '${comment.likesCount}',
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Input
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 12 + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: const CachedNetworkImageProvider(
                    'https://picsum.photos/seed/me/100',
                  ),
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2C2C2C)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Escribe un comentario...',
                        hintStyle: TextStyle(color: subtitleColor),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    color: _commentController.text.trim().isNotEmpty
                        ? Colors.blueAccent
                        : subtitleColor,
                  ),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
