import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/chat_models.dart';
import 'chat_detail_page.dart';
import '../../../../core/utils/navigation_utils.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilterIndex =
      0; // 0: Todos, 1: Usuarios, 2: Grupos, 3: No Leídos
  UserStatus _myStatus = UserStatus.online;

  final List<String> _filters = ['Todos', 'Usuarios', 'Grupos', 'No Leídos'];

  // Mock Data
  final String _currentUserId = 'me';
  final List<Conversation> _conversations = [
    Conversation(
      id: 'chat_001',
      users: [
        const ChatUser(
          id: 'user_001', // LadySwingo
          name: 'LadySwingo',
          avatarUrl: 'https://picsum.photos/seed/lady/200',
          status: UserStatus.online,
        ),
        const ChatUser(id: 'me', name: 'Me', avatarUrl: ''),
      ],
      lastMessage: '¡Me encantó conoceros anoche! 🥂',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      isGroup: false,
    ),
    Conversation(
      id: 'chat_002',
      users: [
        const ChatUser(
          id: 'user_003', // Vanesa Free
          name: 'Vanesa Free',
          avatarUrl: 'https://picsum.photos/seed/vanesa/200',
          status: UserStatus.offline,
          customStatus: 'En el trabajo',
        ),
        const ChatUser(id: 'me', name: 'Me', avatarUrl: ''),
      ],
      lastMessage: '¿Os apetece tomar algo el finde?',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 0,
      isGroup: false,
    ),
    Conversation(
      id: 'chat_003',
      users: [
        const ChatUser(
          id: 'user_002', // Carlos y Ana
          name: 'Carlos y Ana',
          avatarUrl: 'https://picsum.photos/seed/couple1/200',
          status: UserStatus.away,
        ),
        const ChatUser(id: 'me', name: 'Me', avatarUrl: ''),
      ],
      lastMessage: 'Ya hemos llegado al hotel.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      isGroup: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Conversation> get _filteredConversations {
    return _conversations.where((c) {
      // 1. Search Filter
      final displayName = c.getDisplayName(_currentUserId).toLowerCase();
      if (_searchQuery.isNotEmpty &&
          !displayName.contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // 2. Category Filter
      switch (_selectedFilterIndex) {
        case 1: // Usuarios
          return !c.isGroup;
        case 2: // Grupos
          return c.isGroup;
        case 3: // No Leídos
          return c.unreadCount > 0;
        case 0: // Todos
        default:
          return true;
      }
    }).toList();
  }

  void _changeMyStatus() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Cambiar mi estado',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildStatusOption(
              UserStatus.online,
              'En línea',
              Colors.greenAccent,
            ),
            _buildStatusOption(UserStatus.away, 'Ausente', Colors.orangeAccent),
            _buildStatusOption(
              UserStatus.offline,
              'Ocupado / Offline',
              Colors.redAccent,
            ),
            _buildStatusOption(
              UserStatus.custom,
              'En una Cita 🍸',
              Colors.purpleAccent,
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildStatusOption(UserStatus status, String label, Color color) {
    return ListTile(
      leading: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {
        setState(() {
          _myStatus = status;
        });
        Navigator.pop(context);
      },
      trailing: _myStatus == status
          ? const Icon(Icons.check, color: Colors.white)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Mensajes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          // My Avatar with Status
          GestureDetector(
            onTap: _changeMyStatus,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade800,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  _StatusIndicator(status: _myStatus),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(_filters.length, (index) {
                final isSelected = _selectedFilterIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(_filters[index]),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    selectedColor: const Color(0xFFFF0040),
                    backgroundColor: Colors.grey.shade900,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade400,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                );
              }),
            ),
          ),

          // Conversation List
          Expanded(
            child: ListView.separated(
              itemCount: _filteredConversations.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade900, height: 1, indent: 80),
              itemBuilder: (context, index) {
                final conversation = _filteredConversations[index];
                return _ChatListTile(
                  conversation: conversation,
                  currentUserId: _currentUserId,
                  onTap: () {
                    final displayName = conversation.getDisplayName(
                      _currentUserId,
                    );
                    final displayAvatar = conversation.getDisplayAvatar(
                      _currentUserId,
                    );
                    final status = conversation.getDisplayStatus(
                      _currentUserId,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailPage(
                          userName: displayName,
                          userAvatar: displayAvatar,
                          isOnline: status == UserStatus.online,
                        ),
                      ),
                    );
                  },
                  onDelete: () {
                    setState(() {
                      _conversations.remove(conversation);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatListTile extends StatelessWidget {
  final Conversation conversation;
  final String currentUserId;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ChatListTile({
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = conversation.getDisplayName(currentUserId);
    final displayAvatar = conversation.getDisplayAvatar(currentUserId);
    final status = conversation.getDisplayStatus(currentUserId);

    return Dismissible(
      key: Key(conversation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade900,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onDelete(),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            GestureDetector(
              onTap: () {
                // Assuming conversation.users has the other user at index 0 or we find it
                // For simplicity, using a placeholder or logic to find 'other' user
                // In real app, we'd get the other user ID
                final otherUser = conversation.users.firstWhere(
                  (u) => u.id != currentUserId,
                  orElse: () => conversation.users.first,
                );
                NavigationUtils.navigateToProfile(context, otherUser.id);
              },
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade800,
                backgroundImage: CachedNetworkImageProvider(displayAvatar),
              ),
            ),
            if (!conversation.isGroup)
              Positioned(
                bottom: 0,
                right: 0,
                child: _StatusIndicator(status: status),
              ),
          ],
        ),
        title: Text(
          displayName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: conversation.isTyping
              ? const Text(
                  'Escribiendo...',
                  style: TextStyle(
                    color: Color(0xFFFF0040),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Text(
                  conversation.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: conversation.unreadCount > 0
                        ? Colors.white
                        : Colors.grey.shade500,
                    fontWeight: conversation.unreadCount > 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(conversation.timestamp),
              style: TextStyle(
                color: conversation.unreadCount > 0
                    ? const Color(0xFFFF0040)
                    : Colors.grey.shade600,
                fontSize: 12,
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            if (conversation.unreadCount > 0) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF0040),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x66FF0040),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  conversation.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays == 0) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Ayer';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}

class _StatusIndicator extends StatelessWidget {
  final UserStatus status;

  const _StatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case UserStatus.online:
        color = Colors.greenAccent;
        break;
      case UserStatus.away:
        color = Colors.orangeAccent;
        break;
      case UserStatus.custom:
        color = Colors.purpleAccent;
        break;
      case UserStatus.offline:
      default:
        color = Colors.grey;
        break;
    }

    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
    );
  }
}
