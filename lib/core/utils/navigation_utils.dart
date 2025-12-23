import 'package:flutter/material.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class NavigationUtils {
  static void navigateToProfile(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage(userId: userId)),
    );
  }
}
