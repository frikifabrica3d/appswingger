import 'package:flutter/material.dart';
import 'dart:ui';

enum ReactionType { like, devil, dislike, hot, kiss, fire, peach, drops, smirk }

class ReactionData {
  final ReactionType type;
  final String assetPath;
  final String label;
  final Color color;
  final String emoji; // Fallback for now

  const ReactionData({
    required this.type,
    required this.assetPath,
    required this.label,
    required this.color,
    required this.emoji,
  });
}

final List<ReactionData> reactions = [
  const ReactionData(
    type: ReactionType.like,
    assetPath: 'assets/reactions/love.png',
    label: 'Me encanta',
    color: Colors.red,
    emoji: '❤️',
  ),
  const ReactionData(
    type: ReactionType.devil,
    assetPath: 'assets/reactions/devil.png',
    label: 'Travieso',
    color: Colors.purple,
    emoji: '😈',
  ),
  const ReactionData(
    type: ReactionType.dislike,
    assetPath: 'assets/reactions/dislike.png',
    label: 'No me gusta',
    color: Colors.blueGrey,
    emoji: '👎',
  ),
  const ReactionData(
    type: ReactionType.hot,
    assetPath: 'assets/reactions/hot.png',
    label: 'Calor',
    color: Colors.orange,
    emoji: '🥵',
  ),
  const ReactionData(
    type: ReactionType.kiss,
    assetPath: 'assets/reactions/kiss.png',
    label: 'Beso',
    color: Colors.pink,
    emoji: '💋',
  ),
  const ReactionData(
    type: ReactionType.fire,
    assetPath: 'assets/reactions/fire.png',
    label: 'Fuego',
    color: Colors.deepOrange,
    emoji: '🔥',
  ),
  const ReactionData(
    type: ReactionType.peach,
    assetPath: 'assets/reactions/peach.png',
    label: 'Durazno',
    color: Colors.pinkAccent,
    emoji: '🍑',
  ),
  const ReactionData(
    type: ReactionType.drops,
    assetPath: 'assets/reactions/drops.png',
    label: 'Mojado',
    color: Colors.blue,
    emoji: '💦',
  ),
  const ReactionData(
    type: ReactionType.smirk,
    assetPath: 'assets/reactions/smirk.png',
    label: 'Pícaro',
    color: Colors.amber,
    emoji: '😏',
  ),
];

class SwingoReactionButton extends StatefulWidget {
  final Function(ReactionType) onReactionSelected;
  final ReactionType? initialReaction;
  final double iconSize;

  const SwingoReactionButton({
    super.key,
    required this.onReactionSelected,
    this.initialReaction,
    this.iconSize = 28,
  });

  @override
  State<SwingoReactionButton> createState() => _SwingoReactionButtonState();
}

class _SwingoReactionButtonState extends State<SwingoReactionButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey<_ReactionOverlayState> _overlayKey = GlobalKey();

  void _showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: 350, // Fixed width for the capsule
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(-20, -70), // Position above the button
            child: _ReactionOverlay(
              key: _overlayKey,
              onReactionSelected: (reaction) {
                widget.onReactionSelected(reaction);
                _hideOverlay();
              },
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    // Pass the global position to the overlay to determine hover
    _overlayKey.currentState?.updateHover(details.globalPosition);
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    // Finalize selection
    _overlayKey.currentState?.finalizeSelection();
    _hideOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final selectedData = widget.initialReaction != null
        ? reactions.firstWhere((r) => r.type == widget.initialReaction)
        : null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          // Default toggle behavior: if already selected, unselect (pass null logic in parent if needed),
          // or just select 'like' if nothing selected.
          // For this widget, we just emit 'like' if nothing is selected, or let parent handle toggle.
          // Assuming simple "Like" on tap if not selected.
          widget.onReactionSelected(ReactionType.like);
        },
        onLongPressStart: (_) => _showOverlay(),
        onLongPressMoveUpdate: _onLongPressMoveUpdate,
        onLongPressEnd: _onLongPressEnd,
        onLongPressUp: _hideOverlay, // Fallback if no selection logic in End
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selectedData?.color.withOpacity(0.1) ?? Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: selectedData != null
              ? Text(
                  selectedData.emoji,
                  style: TextStyle(fontSize: widget.iconSize - 4),
                )
              : Icon(
                  Icons.favorite_border,
                  size: widget.iconSize,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
        ),
      ),
    );
  }
}

class _ReactionOverlay extends StatefulWidget {
  final Function(ReactionType) onReactionSelected;

  const _ReactionOverlay({super.key, required this.onReactionSelected});

  @override
  State<_ReactionOverlay> createState() => _ReactionOverlayState();
}

class _ReactionOverlayState extends State<_ReactionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  int? _hoveredIndex;
  final GlobalKey _containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateHover(Offset globalPosition) {
    // Get render box of the container
    final RenderBox? renderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Convert global to local
    final localPosition = renderBox.globalToLocal(globalPosition);

    // Check if inside bounds vertically (with some buffer)
    if (localPosition.dy < -20 || localPosition.dy > 70) {
      if (_hoveredIndex != null) {
        setState(() => _hoveredIndex = null);
      }
      return;
    }

    // Determine index based on width
    // Assuming equal width distribution
    final itemWidth = renderBox.size.width / reactions.length;
    int index = (localPosition.dx / itemWidth).floor();

    if (index >= 0 && index < reactions.length) {
      if (_hoveredIndex != index) {
        setState(() => _hoveredIndex = index);
      }
    } else {
      if (_hoveredIndex != null) {
        setState(() => _hoveredIndex = null);
      }
    }
  }

  void finalizeSelection() {
    if (_hoveredIndex != null) {
      widget.onReactionSelected(reactions[_hoveredIndex!].type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      alignment: Alignment.bottomLeft,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          key: _containerKey,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(reactions.length, (index) {
                  final reaction = reactions[index];
                  final isHovered = _hoveredIndex == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOutBack,
                    transform: Matrix4.identity()
                      ..scale(isHovered ? 1.5 : 1.0)
                      ..translate(0.0, isHovered ? -10.0 : 0.0),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Using Text emoji as placeholder for image assets
                        // In a real app, use Image.asset(reaction.assetPath)
                        Text(
                          reaction.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        if (isHovered)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              reaction.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
