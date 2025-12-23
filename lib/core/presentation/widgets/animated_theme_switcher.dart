import 'package:flutter/material.dart';

class AnimatedThemeSwitcher extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const AnimatedThemeSwitcher({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  State<AnimatedThemeSwitcher> createState() => _AnimatedThemeSwitcherState();
}

class _AnimatedThemeSwitcherState extends State<AnimatedThemeSwitcher> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.isDarkMode
              ? const Color(0xFF0F172A)
              : const Color(0xFF87CEEB),
          border: Border.all(
            color: widget.isDarkMode ? Colors.white24 : Colors.white54,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isDarkMode
                  ? Colors.black26
                  : Colors.blue.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              left: widget.isDarkMode ? 22.0 : 2.0,
              top: 2.0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return RotationTransition(
                    turns: child.key == const ValueKey('moon')
                        ? Tween<double>(
                            begin: 0.75,
                            end: 1.0,
                          ).animate(animation)
                        : Tween<double>(
                            begin: 0.75,
                            end: 1.0,
                          ).animate(animation),
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: widget.isDarkMode ? _buildMoonIcon() : _buildSunIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSunIcon() {
    return Container(
      key: const ValueKey('sun'),
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
      ),
      child: const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 16),
    );
  }

  Widget _buildMoonIcon() {
    return Container(
      key: const ValueKey('moon'),
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            left: 6,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            right: 8,
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Center(
            child: Icon(Icons.nightlight_round, color: Colors.grey, size: 14),
          ),
        ],
      ),
    );
  }
}
