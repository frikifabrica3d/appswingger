import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/story_model.dart';
import '../pages/story_viewer_page.dart';

class StoriesBar extends StatelessWidget {
  const StoriesBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Group stories by user for the feed
    final Map<String, List<StoryModel>> userStories = {};
    for (var story in dummyStories) {
      if (!userStories.containsKey(story.userId)) {
        userStories[story.userId] = [];
      }
      userStories[story.userId]!.add(story);
    }

    final users = userStories.keys.toList();

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: users.length + 1, // +1 for "Your Story"
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddStoryItem(context);
          }

          final userId = users[index - 1];
          final stories = userStories[userId]!;
          return _buildStoryItem(context, stories);
        },
      ),
    );
  }

  Widget _buildAddStoryItem(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 68,
                height: 68,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    'https://picsum.photos/seed/me/100',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tu historia',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, List<StoryModel> stories) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final firstStory = stories.first;
    final hasUnviewed = stories.any((s) => !s.isViewed);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryViewerPage(stories: stories),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasUnviewed
                    ? const LinearGradient(
                        colors: [Color(0xFFFF0040), Color(0xFFFF5500)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: hasUnviewed ? null : Colors.grey,
                border: !hasUnviewed
                    ? Border.all(color: Colors.grey, width: 2)
                    : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.black : Colors.white,
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: CachedNetworkImageProvider(
                    firstStory.userAvatar,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              firstStory.username.split(' ')[0], // First name only
              style: TextStyle(
                fontSize: 12,
                fontWeight: hasUnviewed ? FontWeight.bold : FontWeight.normal,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
