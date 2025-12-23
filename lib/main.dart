import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/splash_screen_page.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Aquí se inicializarían servicios como Firebase, LocalStorage, etc.

  runApp(const AppSwingger());
}

class AppSwingger extends StatelessWidget {
  const AppSwingger({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController();

    return AnimatedBuilder(
      animation: themeController,
      builder: (context, child) {
        return MaterialApp(
          title: 'Swingo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          home: const SplashScreenPage(),
        );
      },
    );
  }
}
