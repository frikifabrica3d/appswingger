import 'package:flutter/material.dart';
import '../../../../features/auth/presentation/pages/login_page.dart';
import 'blocked_users_page.dart';
import 'legal_text_viewer.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _privateProfile = false;
  bool _showOnlineStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Configuración de Cuenta',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('GESTIÓN DE USUARIOS'),
          _buildListTile(
            title: 'Usuarios Bloqueados',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BlockedUsersPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('CUENTA'),
          _buildListTile(
            title: 'Cambiar Email',
            onTap: () => _showChangeEmailDialog(context),
          ),
          _buildListTile(
            title: 'Cambiar Contraseña',
            onTap: () => _showChangePasswordDialog(context),
          ),
          _buildListTile(
            title: 'Eliminar Cuenta',
            textColor: Colors.red,
            onTap: () => _showDeleteAccountDialog(context),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('PRIVACIDAD'),
          _buildSwitchTile(
            title: 'Perfil Privado',
            subtitle: 'Solo tus seguidores podrán ver tu contenido',
            value: _privateProfile,
            onChanged: (val) => setState(() => _privateProfile = val),
          ),
          _buildSwitchTile(
            title: 'Mostrar estado En Línea',
            subtitle: 'Permite que otros vean cuando estás activo',
            value: _showOnlineStatus,
            onChanged: (val) => setState(() => _showOnlineStatus = val),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('LEGAL'),
          _buildListTile(
            title: 'Reglas de la Comunidad',
            onTap: () => _openLegalDoc('Reglas de la Comunidad'),
          ),
          _buildListTile(
            title: 'Consejos de Seguridad',
            onTap: () => _openLegalDoc('Consejos de Seguridad'),
          ),
          _buildListTile(
            title: 'Términos y Condiciones',
            onTap: () => _openLegalDoc('Términos y Condiciones'),
          ),
          _buildListTile(
            title: 'Políticas de Privacidad',
            onTap: () => _openLegalDoc('Políticas de Privacidad'),
          ),
          _buildListTile(
            title: 'Licencias de Software',
            onTap: () => _openLegalDoc('Licencias de Software'),
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
    required String title,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
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

  void _openLegalDoc(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LegalTextViewer(title: title)),
    );
  }

  void _showChangeEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Cambiar Email',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Por seguridad, ingresa tu contraseña actual.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Contraseña Actual',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF0040)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nuevo Email',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF0040)),
                ),
              ),
            ),
          ],
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
                const SnackBar(content: Text('Email actualizado')),
              );
            },
            child: const Text(
              'Guardar',
              style: TextStyle(color: Color(0xFFFF0040)),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Cambiar Contraseña',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogTextField('Contraseña Actual', obscure: true),
            const SizedBox(height: 12),
            _buildDialogTextField('Nueva Contraseña', obscure: true),
            const SizedBox(height: 12),
            _buildDialogTextField('Confirmar Nueva', obscure: true),
          ],
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
                const SnackBar(content: Text('Contraseña actualizada')),
              );
            },
            child: const Text(
              'Actualizar',
              style: TextStyle(color: Color(0xFFFF0040)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(String label, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFF0040)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
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
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'Esta acción es IRREVERSIBLE. Todos tus datos serán borrados permanentemente.',
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
            child: const Text(
              'ELIMINAR DEFINITIVAMENTE',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
