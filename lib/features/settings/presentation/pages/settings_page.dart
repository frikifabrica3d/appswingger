import 'package:flutter/material.dart';
import '../../../../features/auth/presentation/pages/privacy_policy_page.dart';
import '../../../../features/auth/presentation/pages/login_page.dart';
import 'account_settings_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _invisibleMode = false;
  bool _blockScreenshots = false;
  bool _darkTheme = true;
  bool _pushNotifications = true;
  bool _chatSounds = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Configuración',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('CUENTA'),
          _buildListTile(
            icon: Icons.manage_accounts_outlined,
            title: 'Configuración de Cuenta',
            subtitle: 'Email, contraseña, privacidad',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettingsPage(),
                ),
              );
            },
          ),
          _buildListTile(
            icon: Icons.lock_outline,
            title: 'Cambiar Contraseña',
            onTap: () {},
          ),
          _buildListTile(
            icon: Icons.favorite_border,
            title: 'Vincular Pareja',
            subtitle: 'Busca por ID de usuario',
            onTap: () {
              _showLinkPartnerDialog(context);
            },
          ),
          _buildListTile(
            icon: Icons.verified_user_outlined,
            title: 'Verificación de Identidad',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red),
              ),
              child: const Text(
                'No verificado',
                style: TextStyle(color: Colors.red, fontSize: 10),
              ),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('PRIVACIDAD Y SEGURIDAD'),
          _buildSwitchTile(
            title: 'Modo Invisible',
            subtitle: 'Nadie te verá en el mapa ni en el feed',
            value: _invisibleMode,
            onChanged: (val) => setState(() => _invisibleMode = val),
          ),
          _buildSwitchTile(
            title: 'Bloquear Capturas',
            subtitle: 'Evita que tomen screenshots de tu perfil',
            value: _blockScreenshots,
            onChanged: (val) => setState(() => _blockScreenshots = val),
          ),
          _buildListTile(
            icon: Icons.block,
            title: 'Usuarios Bloqueados',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('PREFERENCIAS'),
          _buildSwitchTile(
            title: 'Tema Oscuro',
            value: _darkTheme,
            onChanged: (val) => setState(() => _darkTheme = val),
          ),
          _buildSwitchTile(
            title: 'Notificaciones Push',
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          _buildSwitchTile(
            title: 'Sonidos del Chat',
            value: _chatSounds,
            onChanged: (val) => setState(() => _chatSounds = val),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('LEGAL'),
          _buildListTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Política de Privacidad',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyPage(),
                ),
              );
            },
          ),
          _buildListTile(
            icon: Icons.description_outlined,
            title: 'Términos y Condiciones',
            onTap: () {
              // Reuse PrivacyPolicyPage or similar for now
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyPage(),
                ),
              );
            },
          ),
          _buildListTile(
            icon: Icons.copyright,
            title: 'Licencias',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('ZONA DE PELIGRO'),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              'Eliminar Cuenta',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () => _showDeleteAccountDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey.shade400),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            )
          : null,
      trailing:
          trailing ?? Icon(Icons.chevron_right, color: Colors.grey.shade600),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      activeThumbColor: const Color(0xFFFF0040),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            )
          : null,
      value: value,
      onChanged: onChanged,
    );
  }

  void _showLinkPartnerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Vincular Pareja',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'ID de Usuario',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFF0040)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Solicitud enviada')),
              );
            },
            child: const Text(
              'Vincular',
              style: TextStyle(color: Color(0xFFFF0040)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          '¿Eliminar Cuenta?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Esta acción es irreversible. Perderás todos tus datos, matches y mensajes.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
