import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HighlightModel {
  final String id;
  final String title;
  final String coverUrl;
  final List<String> imageUrls;

  HighlightModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.imageUrls,
  });
}

final List<HighlightModel> dummyHighlights = [
  HighlightModel(
    id: '1',
    title: 'Viajes ✈️',
    coverUrl: 'https://picsum.photos/seed/h1/200',
    imageUrls: [
      'https://picsum.photos/seed/h1a/800/1200',
      'https://picsum.photos/seed/h1b/800/1200',
      'https://picsum.photos/seed/h1c/800/1200',
    ],
  ),
  HighlightModel(
    id: '2',
    title: 'Comida 🍔',
    coverUrl: 'https://picsum.photos/seed/h2/200',
    imageUrls: [
      'https://picsum.photos/seed/h2a/800/1200',
      'https://picsum.photos/seed/h2b/800/1200',
    ],
  ),
  HighlightModel(
    id: '3',
    title: 'Gym 💪',
    coverUrl: 'https://picsum.photos/seed/h3/200',
    imageUrls: [
      'https://picsum.photos/seed/h3a/800/1200',
      'https://picsum.photos/seed/h3b/800/1200',
      'https://picsum.photos/seed/h3c/800/1200',
      'https://picsum.photos/seed/h3d/800/1200',
    ],
  ),
];

class ProfileHighlights extends StatelessWidget {
  const ProfileHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: dummyHighlights.length + 1, // +1 for "New" placeholder
        itemBuilder: (context, index) {
          if (index == dummyHighlights.length) {
            return _buildNewHighlight(context);
          }
          return _buildHighlightItem(context, dummyHighlights[index]);
        },
      ),
    );
  }

  Widget _buildNewHighlight(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Icon(Icons.add, color: isDark ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 6),
          Text(
            'Nuevo',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(BuildContext context, HighlightModel highlight) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HighlightViewerPage(highlight: highlight),
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
                border: Border.all(
                  color: Colors.amber, // Gold border
                  width: 2,
                ),
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
                    highlight.coverUrl,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              highlight.title,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HighlightViewerPage extends StatefulWidget {
  final HighlightModel highlight;

  const HighlightViewerPage({super.key, required this.highlight});

  @override
  State<HighlightViewerPage> createState() => _HighlightViewerPageState();
}

class _HighlightViewerPageState extends State<HighlightViewerPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.highlight.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          PageView.builder(
            itemCount: widget.highlight.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.highlight.imageUrls[index],
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentIndex + 1} / ${widget.highlight.imageUrls.length}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
