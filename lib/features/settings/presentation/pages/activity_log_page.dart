import 'package:flutter/material.dart';

class ActivityLogPage extends StatelessWidget {
  const ActivityLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'icon': Icons.favorite,
        'text': 'Te gustó la foto de @LadySwingo',
        'time': 'Hace 2h',
        'color': Colors.red,
      },
      {
        'icon': Icons.comment,
        'text': 'Comentaste en el post de @ParejaTop',
        'time': 'Hace 5h',
        'color': Colors.blue,
      },
      {
        'icon': Icons.edit,
        'text': 'Actualizaste tu foto de perfil',
        'time': 'Ayer',
        'color': Colors.orange,
      },
      {
        'icon': Icons.person_add,
        'text': 'Comenzaste a seguir a @SwingMadrid',
        'time': 'Ayer',
        'color': Colors.green,
      },
      {
        'icon': Icons.share,
        'text': 'Compartiste un evento',
        'time': 'Hace 2 días',
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Registro de Actividad',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey.shade900),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (activity['color'] as Color).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                activity['icon'] as IconData,
                color: activity['color'] as Color,
                size: 20,
              ),
            ),
            title: Text(
              activity['text'] as String,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            trailing: Text(
              activity['time'] as String,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          );
        },
      ),
    );
  }
}
