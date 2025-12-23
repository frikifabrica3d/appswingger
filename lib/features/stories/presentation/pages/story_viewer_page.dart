import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/story_model.dart';

class StoryViewerPage extends StatefulWidget {
  final List<StoryModel> stories;
  final int initialIndex;

  const StoryViewerPage({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  late int _currentIndex;
  Timer? _countdownTimer;
  String _timeLeft = "";

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _animController = AnimationController(vsync: this);

    _loadStory(animate: true);
    _startCountdown();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _loadStory({bool animate = true}) {
    _animController.stop();
    _animController.reset();
    _animController.duration = widget.stories[_currentIndex].duration;

    if (animate) {
      _animController.forward().whenComplete(_onStoryComplete);
    }

    // Mark as viewed logic could go here
    setState(() {});
  }

  void _onStoryComplete() {
    if (_currentIndex < widget.stories.length - 1) {
      _nextStory();
    } else {
      Navigator.pop(context);
    }
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.jumpToPage(_currentIndex);
      _loadStory();
    } else {
      Navigator.pop(context);
    }
  }

  void _prevStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.jumpToPage(_currentIndex);
      _loadStory();
    } else {
      // Restart current story or close? Usually restart if at beginning
      _loadStory();
    }
  }

  void _pauseStory() {
    _animController.stop();
  }

  void _resumeStory() {
    _animController.forward();
  }

  void _startCountdown() {
    _updateTimeLeft();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeLeft();
    });
  }

  void _updateTimeLeft() {
    final story = widget.stories[_currentIndex];
    final now = DateTime.now();
    final expiration = story.createdAt.add(const Duration(hours: 24));
    final diff = expiration.difference(now);

    if (diff.isNegative) {
      setState(() => _timeLeft = "Expirada");
    } else {
      final hours = diff.inHours.toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
      setState(() => _timeLeft = "Expira en: $hours:$minutes:$seconds");
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _pauseStory(),
        onTapUp: (details) {
          _resumeStory();
          final width = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < width / 3) {
            _prevStory();
          } else {
            _nextStory();
          }
        },
        onLongPress: _pauseStory,
        onLongPressUp: _resumeStory,
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 10) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            // Story Image
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: widget.stories[index].imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, color: Colors.white),
                  ),
                );
              },
            ),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.black54,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.2, 0.8],
                  ),
                ),
              ),
            ),

            // Progress Bars
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Row(
                children: widget.stories.asMap().entries.map((entry) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _buildProgressBar(entry.key),
                    ),
                  );
                }).toList(),
              ),
            ),

            // User Info & Countdown
            Positioned(
              top: 55,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                      story.userAvatar,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _timeLeft,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int index) {
    if (index < _currentIndex) {
      return Container(
        height: 3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    } else if (index == _currentIndex) {
      return AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: _animController.value,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 3,
            borderRadius: BorderRadius.circular(2),
          );
        },
      );
    } else {
      return Container(
        height: 3,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }
  }
}
