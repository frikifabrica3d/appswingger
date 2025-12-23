import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  // Mock Data
  final List<Map<String, String>> _blockedUsers = [
    {
      'name': 'Usuario Molesto',
      'image': 'https://picsum.photos/seed/blocked1/100',
    },
    {
      'name': 'Spammer 3000',
      'image': 'https://picsum.photos/seed/blocked2/100',
    },
    {'name': 'Ex Pareja', 'image': 'https://picsum.photos/seed/blocked3/100'},
  ];

  void _unblockUser(int index) {
    setState(() {
      _blockedUsers.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Usuario desbloqueado')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Usuarios Bloqueados',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _blockedUsers.isEmpty
          ? Center(
              child: Text(
                'No tienes usuarios bloqueados',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            )
          : ListView.builder(
              itemCount: _blockedUsers.length,
              itemBuilder: (context, index) {
                final user = _blockedUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user['image']!),
                  ),
                  title: Text(
                    user['name']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: TextButton(
                    onPressed: () => _unblockUser(index),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFFF0040),
                      side: const BorderSide(color: Color(0xFFFF0040)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Desbloquear'),
                  ),
                );
              },
            ),
    );
  }
}
