import 'package:flutter/material.dart';

class OnlineStatusIndicator extends StatelessWidget {
  final bool isOnline;
  final double size;
  final Color onlineColor;
  final Color offlineColor;
  final bool showBorder;
  final Color borderColor;

  const OnlineStatusIndicator({
    super.key,
    required this.isOnline,
    this.size = 12.0,
    this.onlineColor = const Color(0xFF00E676), // Green Accent
    this.offlineColor = Colors.grey,
    this.showBorder = true,
    this.borderColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOnline ? onlineColor : offlineColor,
        shape: BoxShape.circle,
        border: showBorder ? Border.all(color: borderColor, width: 2.0) : null,
      ),
    );
  }
}
