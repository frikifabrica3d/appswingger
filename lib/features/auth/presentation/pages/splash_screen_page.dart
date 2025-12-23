import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'auth_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    // Navigate after 4 seconds
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AuthPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Text with Gradient
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFFF0040), Color(0xFFFF5500)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                'Swingo',
                style: TextStyle(
                  fontFamily:
                      'Cursive', // Ensure this font is available or use a fallback
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white, // Required for ShaderMask
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Lottie Animation
            Lottie.asset(
              'assets/animations/Cat_feeling_love.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              repeat: true,
              errorBuilder: (context, error, stackTrace) {
                // Fallback in case animation fails to load
                return const Icon(
                  Icons.favorite,
                  color: Color(0xFFFF0040),
                  size: 100,
                );
              },
            ),

            const SizedBox(height: 40),

            // Loading Text
            Text(
              'Cargando...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
