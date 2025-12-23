import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui'; // For ImageFilter
import 'dart:async'; // For Timer

enum MessageType { text, image, audio, ephemeral }

class ChatMessage {
  final String id;
  final String senderId;
  final String content; // Text or Image URL
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final Duration? audioDuration;
  final int? selfDestructSeconds; // Null if disabled

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.audioDuration,
    this.selfDestructSeconds,
  });
}

class ChatDetailPage extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final bool isOnline;

  const ChatDetailPage({
    super.key,
    required this.userName,
    required this.userAvatar,
    this.isOnline = false,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isEphemeralMode = false;
  int? _selfDestructSeconds; // State for the timer setting
  final String _currentUserId = 'me';

  // Mock Messages
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      senderId: 'other',
      content: '¡Hola! ¿Qué tal la noche?',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    ChatMessage(
      id: '2',
      senderId: 'me',
      content: 'Increíble, el ambiente estaba genial 🔥',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
      isRead: true,
    ),
    ChatMessage(
      id: '3',
      senderId: 'other',
      content: 'https://picsum.photos/seed/chat_img1/400/300',
      type: MessageType.image,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
      isRead: true,
    ),
    ChatMessage(
      id: '4',
      senderId: 'me',
      content: 'Mira esto...',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: true,
    ),
    ChatMessage(
      id: '5',
      senderId: 'me',
      content: 'https://picsum.photos/seed/chat_fire/400/600',
      type: MessageType.ephemeral,
      timestamp: DateTime.now().subtract(const Duration(minutes: 29)),
      isRead: true,
    ),
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().toString(),
          senderId: _currentUserId,
          content: _textController.text,
          type: MessageType.text,
          timestamp: DateTime.now(),
          selfDestructSeconds: _selfDestructSeconds,
        ),
      );
      _textController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _AttachmentOption(
                    icon: Icons.camera_alt,
                    label: 'Cámara',
                    color: Colors.cyanAccent,
                    onTap: () {},
                  ),
                  _AttachmentOption(
                    icon: Icons.image,
                    label: 'Galería',
                    color: Colors.purpleAccent,
                    onTap: () {},
                  ),
                  _AttachmentOption(
                    icon: Icons.location_on,
                    label: 'Ubicación',
                    color: Colors.greenAccent,
                    onTap: () {},
                  ),
                  _AttachmentOption(
                    icon: Icons.timer,
                    label: 'Timer',
                    color: Colors.orangeAccent,
                    onTap: _showSelfDestructPicker,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSelfDestructPicker() {
    Navigator.pop(context); // Close attachment menu
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Autodestrucción',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                [5, 10, 30, 60].map((seconds) {
                  return ListTile(
                    title: Text(
                      '$seconds segundos',
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: const Icon(
                      Icons.timer,
                      color: Colors.orangeAccent,
                    ),
                    onTap: () {
                      setState(() {
                        _selfDestructSeconds = seconds;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList()..add(
                  ListTile(
                    title: const Text(
                      'Desactivado',
                      style: TextStyle(color: Colors.grey),
                    ),
                    leading: const Icon(Icons.timer_off, color: Colors.grey),
                    onTap: () {
                      setState(() {
                        _selfDestructSeconds = null;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 1,
        leadingWidth: 40,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(widget.userAvatar),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.isOnline ? 'En línea' : 'En el club 🍸',
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isOnline ? Colors.greenAccent : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'block', child: Text('Bloquear')),
              const PopupMenuItem(value: 'clear', child: Text('Vaciar chat')),
            ],
          ),
        ],
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
                final isMe = msg.senderId == _currentUserId;
                return _MessageBubble(message: msg, isMe: isMe);
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: const Color(0xFF1E1E1E),
      child: SafeArea(
        child: Column(
          children: [
            if (_selfDestructSeconds != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.timer,
                      color: Colors.orangeAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Autodestrucción: ${_selfDestructSeconds}s',
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _selfDestructSeconds = null),
                      child: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.grey),
                  onPressed: _showAttachmentMenu,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(24),
                      border: _isEphemeralMode
                          ? Border.all(color: Colors.orange, width: 1.5)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: _isEphemeralMode
                                  ? 'Mensaje efímero...'
                                  : 'Escribe un mensaje...',
                              hintStyle: TextStyle(
                                color: _isEphemeralMode
                                    ? Colors.orange.withOpacity(0.7)
                                    : Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                            minLines: 1,
                            maxLines: 4,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.local_fire_department,
                            color: _isEphemeralMode
                                ? Colors.orange
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isEphemeralMode = !_isEphemeralMode;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onLongPress: () {
                    // TODO: Record Audio
                  },
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFFFF0040),
                    radius: 24,
                    child: IconButton(
                      icon: Icon(
                        _textController.text.isEmpty ? Icons.mic : Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? (message.type == MessageType.ephemeral
                        ? Colors.orange.withOpacity(0.2)
                        : const Color(0xFFFF0040))
                  : const Color(0xFF2C2C2C),
              gradient: isMe && message.type != MessageType.ephemeral
                  ? const LinearGradient(
                      colors: [Color(0xFFFF0040), Color(0xFFFF5500)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                bottomRight: isMe ? Radius.zero : const Radius.circular(16),
              ),
              border: message.type == MessageType.ephemeral
                  ? Border.all(color: Colors.orange, width: 1)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: _buildContent(context),
            ),
          ),
          if (message.selfDestructSeconds != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 4, left: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, size: 10, color: Colors.orangeAccent),
                  const SizedBox(width: 2),
                  Text(
                    '${message.selfDestructSeconds}s',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (message.type) {
      case MessageType.text:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.content,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 4),
              _buildFooter(),
            ],
          ),
        );
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: message.content,
                placeholder: (context, url) => Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey[900],
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 4),
              child: _buildFooter(onImage: true),
            ),
          ],
        );
      case MessageType.ephemeral:
        return _EphemeralImage(
          imageUrl: message.content,
          timestamp: message.timestamp,
          isRead: message.isRead,
        );
      case MessageType.audio:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 8),
              // Simulated Waveform
              SizedBox(
                height: 24,
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(15, (index) {
                    return Container(
                      width: 3,
                      height: (index % 2 == 0 ? 12 : 24).toDouble(),
                      color: Colors.white70,
                    );
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '0:${message.audioDuration?.inSeconds}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildFooter({bool onImage = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
          style: TextStyle(
            color: onImage ? Colors.white : Colors.white70,
            fontSize: 10,
          ),
        ),
        if (isMe) ...[
          const SizedBox(width: 4),
          Icon(
            Icons.done_all,
            size: 14,
            color: message.isRead ? Colors.cyanAccent : Colors.white70,
          ),
        ],
      ],
    );
  }
}

class _EphemeralImage extends StatefulWidget {
  final String imageUrl;
  final DateTime timestamp;
  final bool isRead;

  const _EphemeralImage({
    required this.imageUrl,
    required this.timestamp,
    required this.isRead,
  });

  @override
  State<_EphemeralImage> createState() => _EphemeralImageState();
}

class _EphemeralImageState extends State<_EphemeralImage> {
  bool _isRevealed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        setState(() {
          _isRevealed = true;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          _isRevealed = false;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: _isRevealed ? 0 : 20,
                sigmaY: _isRevealed ? 0 : 20,
              ),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                height: 250,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay Icon if not revealed
          if (!_isRevealed)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 32,
              ),
            ),

          // Instruction Text
          if (!_isRevealed)
            const Positioned(
              bottom: 16,
              child: Text(
                'Mantén para ver 🔥',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
