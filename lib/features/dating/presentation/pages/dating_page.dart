import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import '../widgets/dating_card.dart';
import '../widgets/match_overlay.dart';
import 'swinger_guide_page.dart';

class DatingPage extends StatefulWidget {
  const DatingPage({super.key});

  @override
  State<DatingPage> createState() => _DatingPageState();
}

class _DatingPageState extends State<DatingPage> {
  final AppinioSwiperController _swiperController = AppinioSwiperController();
  final List<int> _cards = List.generate(10, (index) => index);

  void _swipeLeft() {
    _swiperController.swipeLeft();
  }

  void _swipeRight() {
    _swiperController.swipeRight();
    // Simulate a match for demonstration purposes
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const MatchOverlay(
            currentUserAvatar: 'https://picsum.photos/seed/me/200',
            matchUserAvatar: 'https://picsum.photos/seed/match/200',
            matchUsername: 'crush_swing',
            matchId: '12345',
          ),
        );
      }
    });
  }

  void _swipeUp() {
    _swiperController.swipeUp();
  }

  void _unswipe() {
    _swiperController.unswipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.tune, size: 16),
                    label: const Text('Filtros'),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 300,
                          color: Colors.white,
                          child: const Center(child: Text('Filtros Avanzados')),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  const FilterChip(label: Text('Cerca'), onSelected: null),
                  const SizedBox(width: 8),
                  const FilterChip(label: Text('Online'), onSelected: null),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SwingerGuidePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Swiper Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppinioSwiper(
                  controller: _swiperController,
                  cardCount: _cards.length,
                  cardBuilder: (BuildContext context, int index) {
                    return DatingCard(index: _cards[index]);
                  },
                ),
              ),
            ),

            // Bottom Action Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Rewind
                  _ActionButton(
                    icon: Icons.refresh,
                    color: Colors.amber,
                    size: 50,
                    iconSize: 24,
                    onPressed: _unswipe,
                  ),
                  // Dislike
                  _ActionButton(
                    icon: Icons.close,
                    color: Colors.red,
                    size: 64,
                    iconSize: 32,
                    onPressed: _swipeLeft,
                  ),
                  // Super Like
                  _ActionButton(
                    icon: Icons.star,
                    color: Colors.blue,
                    size: 50,
                    iconSize: 24,
                    onPressed: _swipeUp,
                  ),
                  // Like
                  _ActionButton(
                    icon: Icons.favorite,
                    color: Colors.green,
                    size: 64,
                    iconSize: 32,
                    onPressed: _swipeRight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: color,
        iconSize: iconSize,
        onPressed: onPressed,
      ),
    );
  }
}
