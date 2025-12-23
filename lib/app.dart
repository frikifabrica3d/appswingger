import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/presentation/main_layout.dart';

class AppSwingger extends StatelessWidget {
  const AppSwingger({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppSwingger',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainLayout(),
    );
  }
}
