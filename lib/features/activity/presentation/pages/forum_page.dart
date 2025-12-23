import 'package:flutter/material.dart';
import '../../domain/models/activity_models.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'General',
    'Experiencias',
    'Consejos',
    'Locales',
  ];

  // Mock Data
  final List<ForumTopic> _topics = [
    ForumTopic(
      id: '1',
      title: '¿Mejores clubs en Barcelona?',
      content:
          'Hola a todos, vamos a visitar BCN pronto y queremos recomendaciones...',
      authorId: 'u1',
      authorName: 'ParejaViajera',
      category: 'Locales',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      votes: 15,
      replyCount: 8,
    ),
    ForumTopic(
      id: '2',
      title: 'Nuestra primera experiencia swinger',
      content: 'Fue algo increíble, al principio estábamos nerviosos pero...',
      authorId: 'u2',
      authorName: 'NovatosCuriosos',
      category: 'Experiencias',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      votes: 42,
      replyCount: 23,
    ),
    ForumTopic(
      id: '3',
      title: 'Normas de etiqueta básicas',
      content: 'Recordatorio para los nuevos: El NO es NO, siempre...',
      authorId: 'u3',
      authorName: 'Admin',
      category: 'Consejos',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      votes: 120,
      replyCount: 15,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Foros',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFFFF0040),
          labelColor: const Color(0xFFFF0040),
          unselectedLabelColor: Colors.grey,
          tabs: _categories.map((c) => Tab(text: c)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateForumTopicPage(),
            ),
          ).then((newTopic) {
            if (newTopic != null && newTopic is ForumTopic) {
              setState(() {
                _topics.insert(0, newTopic);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Tema publicado con éxito!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          });
        },
        backgroundColor: const Color(0xFFFF0040),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          final categoryTopics = _topics
              .where((t) => t.category == category || category == 'General')
              .toList();
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: categoryTopics.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              return _TopicTile(topic: categoryTopics[index]);
            },
          );
        }).toList(),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  final ForumTopic topic;

  const _TopicTile({required this.topic});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForumTopicDetailPage(topic: topic),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topic.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'por ${topic.authorName}',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text(
                  '• ${_formatTime(topic.timestamp)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _StatBadge(icon: Icons.comment, count: topic.replyCount),
                const SizedBox(width: 16),
                _StatBadge(icon: Icons.thumb_up, count: topic.votes),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inHours < 24) {
      return 'hace ${diff.inHours}h';
    } else {
      return 'hace ${diff.inDays}d';
    }
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final int count;

  const _StatBadge({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

class ForumTopicDetailPage extends StatelessWidget {
  final ForumTopic topic;

  const ForumTopicDetailPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Original Post
                Text(
                  topic.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      topic.authorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'hace 5h',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  topic.content,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Respuestas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Mock Replies
                _ReplyTile(
                  author: 'UsuarioX',
                  content: 'Totalmente de acuerdo, el club X es genial.',
                  votes: 5,
                ),
                _ReplyTile(
                  author: 'SwingerPro',
                  content: 'Ojo con los horarios, mejor ir tarde.',
                  votes: 2,
                ),
              ],
            ),
          ),
          // Reply Input
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E1E),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Escribe una respuesta...',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2C2C2C),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  backgroundColor: Color(0xFFFF0040),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreateForumTopicPage extends StatefulWidget {
  const CreateForumTopicPage({super.key});

  @override
  State<CreateForumTopicPage> createState() => _CreateForumTopicPageState();
}

class _CreateForumTopicPageState extends State<CreateForumTopicPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = [
    'General',
    'Experiencias',
    'Consejos',
    'Locales',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Nuevo Debate',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Categoría',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              items: _categories.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Título del Tema',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              style: const TextStyle(color: Colors.white),
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Cuerpo del Mensaje',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF0040),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_titleController.text.isNotEmpty &&
                      _contentController.text.isNotEmpty &&
                      _selectedCategory != null) {
                    final newTopic = ForumTopic(
                      id: DateTime.now().toString(),
                      title: _titleController.text,
                      content: _contentController.text,
                      authorId: 'me',
                      authorName: 'Yo',
                      category: _selectedCategory!,
                      timestamp: DateTime.now(),
                    );
                    Navigator.pop(context, newTopic);
                  }
                },
                child: const Text(
                  'INICIAR DEBATE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReplyTile extends StatelessWidget {
  final String author;
  final String content;
  final int votes;

  const _ReplyTile({
    required this.author,
    required this.content,
    required this.votes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                author,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(Icons.thumb_up, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '$votes',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
