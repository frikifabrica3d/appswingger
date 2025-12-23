import 'package:flutter/material.dart';

class GradientIconBtn extends StatelessWidget {
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color iconColor;
  final Widget? badge;
  final double? rotation;

  const GradientIconBtn({
    super.key,
    required this.icon,
    required this.gradient,
    required this.onPressed,
    this.size = 40,
    this.iconSize = 24,
    this.iconColor = Colors.white,
    this.badge,
    this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: rotation != null
            ? Transform.rotate(
                angle: rotation!,
                child: Icon(icon, color: iconColor, size: iconSize),
              )
            : Icon(icon, color: iconColor, size: iconSize),
      ),
    );

    if (badge != null) {
      content = Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          Positioned(right: -2, top: -2, child: badge!),
        ],
      );
    }

    return GestureDetector(onTap: onPressed, child: content);
  }
}

class NewPostIcon3D extends StatelessWidget {
  final VoidCallback onPressed;

  const NewPostIcon3D({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GradientIconBtn(
      icon: Icons.camera_alt_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF00E5FF), Color(0xFF2979FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onPressed: onPressed,
      badge: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            color: Color(0xFFFF6D00), // Orange
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 10),
          ),
        ),
      ),
    );
  }
}

class NotificationBellAnimated extends StatefulWidget {
  final bool hasUnread;
  final VoidCallback onPressed;

  const NotificationBellAnimated({
    super.key,
    this.hasUnread = false,
    required this.onPressed,
  });

  @override
  State<NotificationBellAnimated> createState() =>
      _NotificationBellAnimatedState();
}

class _NotificationBellAnimatedState extends State<NotificationBellAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    if (widget.hasUnread) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant NotificationBellAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasUnread != oldWidget.hasUnread) {
      if (widget.hasUnread) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          RotationTransition(
            turns: Tween(begin: -0.05, end: 0.05).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          if (widget.hasUnread)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MessageIcon3D extends StatelessWidget {
  final VoidCallback onPressed;

  const MessageIcon3D({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GradientIconBtn(
      icon: Icons.send_rounded,
      rotation: -0.2, // Slight tilt
      gradient: const LinearGradient(
        colors: [Color(0xFFD500F9), Color(0xFF651FFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onPressed: onPressed,
    );
  }
}
