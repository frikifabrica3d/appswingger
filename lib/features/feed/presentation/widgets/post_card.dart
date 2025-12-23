import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/post.dart';
import 'swingo_reaction_button.dart';
import 'comments_bottom_sheet.dart';
import '../../../../core/utils/navigation_utils.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final bool isExplore; // To differentiate styles
  final String? heroTag;

  const PostCard({
    super.key,
    required this.post,
    this.isExplore = false,
    this.heroTag,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Reacciones
  String? _selectedReaction;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: -2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: widget.isExplore
                ? _buildExploreContent(widget.post.imageUrl)
                : _buildFeedContent(isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildExploreContent(String imageUrl) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        AspectRatio(
          aspectRatio: 0.8,
          child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.favorite, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${widget.post.likesCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.chat_bubble, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${widget.post.commentsCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => NavigationUtils.navigateToProfile(
                  context,
                  widget.post.userId,
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF0040), Color(0xFFFF5500)],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.post.userAvatarUrl,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => NavigationUtils.navigateToProfile(
                        context,
                        widget.post.userId,
                      ),
                      child: Text(
                        widget.post.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      'Hace 2 horas', // Placeholder for timeago
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Image
        Hero(
          tag: widget.heroTag ?? widget.post.imageUrl,
          child: CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 400,
          ),
        ),

        // Action Bar (Glassmorphism style if dark, or just clean)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Row(
            children: [
              SwingoReactionButton(
                initialReaction: _selectedReaction != null
                    ? ReactionType.values.firstWhere(
                        (e) => e.toString() == _selectedReaction,
                        orElse: () => ReactionType.like,
                      )
                    : null,
                onReactionSelected: (reaction) {
                  setState(() {
                    if (_selectedReaction == reaction.toString()) {
                      _selectedReaction = null;
                    } else {
                      _selectedReaction = reaction.toString();
                    }
                  });
                },
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                color: Colors.blueAccent,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CommentsBottomSheet(
                      postId: int.tryParse(widget.post.id) ?? 0,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                icon: Icons.send_rounded,
                color: isDark ? Colors.white : Colors.black,
                onTap: () {},
              ),
              const Spacer(),
              _buildActionButton(
                icon: Icons.bookmark_border_rounded,
                color: isDark ? Colors.white : Colors.black,
                onTap: () {},
              ),
            ],
          ),
        ),

        // Caption & Likes
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Les gusta a usuario_x y ${widget.post.likesCount} personas más',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: '${widget.post.username} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: widget.post.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}
