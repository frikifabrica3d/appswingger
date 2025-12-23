import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../chat/presentation/pages/chat_detail_page.dart';

class MatchOverlay extends StatefulWidget {
  final String currentUserAvatar;
  final String matchUserAvatar;
  final String matchUsername;
  final String matchId;

  const MatchOverlay({
    super.key,
    required this.currentUserAvatar,
    required this.matchUserAvatar,
    required this.matchUsername,
    required this.matchId,
  });

  @override
  State<MatchOverlay> createState() => _MatchOverlayState();
}

class _MatchOverlayState extends State<MatchOverlay> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Blur Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withValues(alpha: 0.9)),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.orange,
                Colors.pink,
                Colors.purple,
                Colors.white,
              ],
            ),
          ),

          // Content
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.5, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatars
                  SizedBox(
                    height: 160,
                    width: 300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Left Avatar (User)
                        Positioned(
                          left: 0,
                          child: _buildAvatar(widget.currentUserAvatar),
                        ),
                        // Right Avatar (Match)
                        Positioned(
                          right: 0,
                          child: _buildAvatar(widget.matchUserAvatar),
                        ),
                        // Burning Heart Icon
                        const Positioned(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.favorite, color: Colors.red, size: 64),
                              Icon(
                                Icons.local_fire_department,
                                color: Colors.orangeAccent,
                                size: 48,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Text
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFF0040), Color(0xFFFF5500)],
                    ).createShader(bounds),
                    child: const Text(
                      '¡ES UN MATCH!',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tú y @${widget.matchUsername} se gustan mutuamente',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade300),
                  ),
                  const SizedBox(height: 60),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close overlay
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetailPage(
                                    userName: widget.matchUsername,
                                    userAvatar: widget.matchUserAvatar,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF0040),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                              shadowColor: const Color(
                                0xFFFF0040,
                              ).withValues(alpha: 0.5),
                            ),
                            child: const Text(
                              'ENVIAR MENSAJE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'SEGUIR BUSCANDO',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String url) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFF0040), width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[900]),
          errorWidget: (context, url, error) => const Icon(Icons.person),
        ),
      ),
    );
  }
}
