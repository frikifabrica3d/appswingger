import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../chat/presentation/pages/inbox_page.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../pages/account_settings_page.dart';
import '../pages/blocked_users_page.dart';
import '../pages/legal_text_viewer.dart';
import '../pages/support_page.dart';

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          _buildOption(
            context,
            icon: Icons.person_outline,
            label: 'Configuración de cuenta',
            textColor: textColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettingsPage(),
                ),
              );
            },
          ),
          _buildOption(
            context,
            icon: Icons.notifications_outlined,
            label: 'Notificaciones',
            textColor: textColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
          ),
          _buildOption(
            context,
            icon: Icons.chat_bubble_outline,
            label: 'Chats',
            textColor: textColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InboxPage()),
              );
            },
          ),
          _buildOption(
            context,
            icon: Icons.lock_outline,
            label: 'Privacidad y Seguridad',
            textColor: textColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BlockedUsersPage(),
                ),
              );
            },
          ),
          _buildOption(
            context,
            icon: Icons.help_outline,
            label: 'Ayuda y Soporte',
            textColor: textColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportPage()),
              );
            },
          ),
          _buildOption(
            context,
            icon: Icons.description_outlined,
            label: 'Términos y Condiciones',
            textColor: textColor,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const LegalTextViewer(title: 'Términos y Condiciones'),
                ),
              );
            },
          ),
          const Divider(),
          _buildOption(
            context,
            icon: Icons.logout,
            label: 'Cerrar Sesión',
            textColor: Colors.redAccent,
            isDestructive: true,
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color textColor,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.redAccent : textColor),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: isDestructive ? Colors.redAccent : textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isDestructive
          ? null
          : Icon(Icons.chevron_right, color: Colors.grey[600]),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Cerrar Sesión',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de que quieres salir?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Navigate to AuthPage and remove all previous routes
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
                (route) => false,
              );
            },
            child: const Text(
              'Salir',
              style: TextStyle(color: Color(0xFFFF0040)),
            ),
          ),
        ],
      ),
    );
  }
}
