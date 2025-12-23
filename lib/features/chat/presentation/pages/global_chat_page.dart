import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GlobalChatPage extends StatefulWidget {
  const GlobalChatPage({super.key});

  @override
  State<GlobalChatPage> createState() => _GlobalChatPageState();
}

class _GlobalChatPageState extends State<GlobalChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String _currentUserId = 'me';

  // Mock Data
  final List<_GlobalMessage> _messages = [
    _GlobalMessage(
      id: '1',
      userId: 'user1',
      userName: 'Carlos',
      userAvatar: 'https://picsum.photos/seed/user1/100',
      content: '¡Hola a todos! ¿Alguien va a la fiesta de esta noche?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    _GlobalMessage(
      id: '2',
      userId: 'user2',
      userName: 'Lucía',
      userAvatar: 'https://picsum.photos/seed/user2/100',
      content: 'Sí, nosotros iremos sobre las 23:00.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    _GlobalMessage(
      id: '3',
      userId: 'user3',
      userName: 'ParejaTraviesa',
      userAvatar: 'https://picsum.photos/seed/user3/100',
      content: 'Nosotros somos nuevos, ¿dónde es?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    _GlobalMessage(
      id: '4',
      userId: 'me',
      userName: 'Yo',
      userAvatar: 'https://picsum.photos/seed/me/100',
      content: 'Es en el Club Secret, en el centro.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        _GlobalMessage(
          id: DateTime.now().toString(),
          userId: _currentUserId,
          userName: 'Yo',
          userAvatar: 'https://picsum.photos/seed/me/100',
          content: _textController.text,
          timestamp: DateTime.now(),
        ),
      );
      _textController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🌍 Chat Global',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  '324 conectados',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.userId == _currentUserId;
                return _GlobalMessageBubble(message: msg, isMe: isMe);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF1E1E1E),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlobalMessage {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime timestamp;

  _GlobalMessage({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.timestamp,
  });
}

class _GlobalMessageBubble extends StatelessWidget {
  final _GlobalMessage message;
  final bool isMe;

  const _GlobalMessageBubble({required this.message, required this.isMe});

  Color _getNameColor(String userId) {
    final colors = [
      Colors.pinkAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.greenAccent,
      Colors.cyanAccent,
    ];
    return colors[userId.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(message.userAvatar),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                    child: Text(
                      message.userName,
                      style: TextStyle(
                        color: _getNameColor(message.userId),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.blueAccent.withOpacity(0.2)
                        : const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : Radius.zero,
                      bottomRight: isMe
                          ? Radius.zero
                          : const Radius.circular(16),
                    ),
                    border: isMe
                        ? Border.all(color: Colors.blueAccent.withOpacity(0.5))
                        : null,
                  ),
                  child: Text(
                    message.content,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 40), // Spacing for alignment
          if (!isMe) const SizedBox(width: 40),
        ],
      ),
    );
  }
}
