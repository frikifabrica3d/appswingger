import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'pages/create_event_page.dart';
import '../../chat/presentation/pages/global_chat_page.dart';
import 'pages/announcements_page.dart';
import 'pages/forum_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedFilterIndex = 0; // 0: Hoy, 1: Esta Semana, 2: Calendario

  void _onFilterChanged(int index) {
    if (index == 2) {
      _selectDate(context);
    } else {
      setState(() {
        _selectedFilterIndex = index;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF0040),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedFilterIndex = 2;
        // TODO: Filter events by picked date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateEventPage()),
          );
        },
        backgroundColor: const Color(0xFFFF0040),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Crear Evento',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Header with Filters
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Agenda de Comunidad',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FilterSegmentedControl(
                    selectedIndex: _selectedFilterIndex,
                    onChanged: _onFilterChanged,
                  ),
                ],
              ),
            ),
          ),

          // Quick Access Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickAccessCard(
                    icon: Icons.public,
                    label: 'Chat Global',
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GlobalChatPage(),
                        ),
                      );
                    },
                  ),
                  _QuickAccessCard(
                    icon: Icons.campaign,
                    label: 'Anuncios',
                    color: Colors.orangeAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AnnouncementsPage(),
                        ),
                      );
                    },
                  ),
                  _QuickAccessCard(
                    icon: Icons.forum,
                    label: 'Foros',
                    color: Colors.purpleAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForumPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Event List
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final event = _mockEvents[index % _mockEvents.length];
              return _EventCard(event: event);
            }, childCount: 10),
          ),

          // Bottom padding for FAB
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _FilterSegmentedControl extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _FilterSegmentedControl({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        children: [
          _buildSegment('Hoy', 0),
          _buildSegment('Esta Semana', 1),
          _buildSegment('Calendario', 2),
        ],
      ),
    );
  }

  Widget _buildSegment(String text, int index) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF0040) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade400,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final _EventModel event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: event.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey.shade900),
                  errorWidget: (context, url, error) =>
                      Container(color: Colors.grey.shade900),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: event.price == 'GRATIS'
                        ? Colors.green
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    event.price,
                    style: TextStyle(
                      color: event.price == 'GRATIS'
                          ? Colors.white
                          : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: event.tags
                      .map((tag) => _TagBadge(tag: tag))
                      .toList(),
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Date & Location
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.date,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  final String tag;

  const _TagBadge({required this.tag});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (tag) {
      case 'ART 🎨':
        color = Colors.pinkAccent;
        break;
      case 'MUSICA 🎵':
        color = Colors.blueAccent;
        break;
      case 'TECNO 🎛️':
        color = Colors.purpleAccent;
        break;
      case 'SEXO 🔥':
        color = Colors.redAccent;
        break;
      case 'SWINGER 🍍':
        color = Colors.orangeAccent;
        break;
      case 'LGBTQ+ 🏳️‍🌈':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _EventModel {
  final String title;
  final String imageUrl;
  final String date;
  final String location;
  final List<String> tags;
  final String price;
  final String status;

  const _EventModel({
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.tags,
    required this.price,
    required this.status,
  });
}

final List<_EventModel> _mockEvents = [
  const _EventModel(
    title: 'Noche de Máscaras & Techno',
    imageUrl: 'https://picsum.photos/seed/event1/800/400',
    date: 'Vie, 12 Dic • 23:00',
    location: 'Club Secret, Madrid',
    tags: ['TECNO 🎛️', 'SEXO 🔥'],
    price: '25€',
    status: 'Público',
  ),
  const _EventModel(
    title: 'Exposición: Cuerpos Libres',
    imageUrl: 'https://picsum.photos/seed/event2/800/400',
    date: 'Sab, 13 Dic • 18:00',
    location: 'Galería Alternativa',
    tags: ['ART 🎨', 'LGBTQ+ 🏳️‍🌈'],
    price: 'GRATIS',
    status: 'Público',
  ),
  const _EventModel(
    title: 'Cena Privada Swinger',
    imageUrl: 'https://picsum.photos/seed/event3/800/400',
    date: 'Dom, 14 Dic • 21:00',
    location: 'Ubicación Secreta',
    tags: ['SWINGER 🍍', 'OTRO'],
    price: '50€',
    status: 'Invitación',
  ),
  const _EventModel(
    title: 'Concierto Jazz & Wine',
    imageUrl: 'https://picsum.photos/seed/event4/800/400',
    date: 'Jue, 18 Dic • 20:00',
    location: 'Terraza Central',
    tags: ['MUSICA 🎵'],
    price: '15€',
    status: 'Público',
  ),
];
