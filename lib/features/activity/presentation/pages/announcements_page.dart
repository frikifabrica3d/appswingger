import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/activity_models.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final bool _isAdmin = true; // Admin role simulation

  final List<Announcement> _announcements = [
    Announcement(
      id: '1',
      title: '¡Nueva Funcionalidad: Chat Global!',
      content:
          'Ahora puedes hablar con toda la comunidad en tiempo real. Entra en la sección de Actividad y únete a la conversación.',
      mediaUrl: 'https://picsum.photos/seed/news1/800/400',
      mediaType: MediaType.image,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 124,
      isOfficial: true,
    ),
    Announcement(
      id: '2',
      title: 'Fiesta de Máscaras este Sábado',
      content:
          'No te pierdas el evento más exclusivo del mes. Recuerda traer tu máscara y tu mejor actitud. ¡Entradas limitadas!',
      mediaUrl: 'https://picsum.photos/seed/news2/800/400',
      mediaType: MediaType.image,
      date: DateTime.now().subtract(const Duration(days: 2)),
      likes: 89,
      isOfficial: false,
    ),
    Announcement(
      id: '3',
      title: 'Mantenimiento Programado',
      content:
          'La app estará en mantenimiento el próximo martes de 03:00 a 05:00 AM para mejorar nuestros servidores.',
      mediaType: MediaType.none,
      date: DateTime.now().subtract(const Duration(days: 5)),
      likes: 45,
      isOfficial: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '📢 Anuncios Oficiales',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAnnouncementPage(),
                  ),
                ).then((newAnnouncement) {
                  if (newAnnouncement != null &&
                      newAnnouncement is Announcement) {
                    setState(() {
                      _announcements.insert(0, newAnnouncement);
                    });
                  }
                });
              },
              backgroundColor: const Color(0xFFFF0040),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          return _AnnouncementCard(announcement: _announcements[index]);
        },
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: announcement.isOfficial
                        ? Colors.blueAccent
                        : Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    announcement.isOfficial ? 'COMUNICADO OFICIAL' : 'NOVEDAD',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _formatDate(announcement.date),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),

          // Media
          if (announcement.mediaType == MediaType.image &&
              announcement.mediaUrl != null)
            CachedNetworkImage(
              imageUrl: announcement.mediaUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          // Placeholder for Video
          if (announcement.mediaType == MediaType.video)
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.black,
              alignment: Alignment.center,
              child: const Icon(
                Icons.play_circle_outline,
                size: 64,
                color: Colors.white,
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  announcement.content,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Footer Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                _ActionButton(
                  icon: Icons.favorite_border,
                  label: '${announcement.likes}',
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _ActionButton(
                  icon: Icons.share,
                  label: 'Compartir',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}

class CreateAnnouncementPage extends StatefulWidget {
  const CreateAnnouncementPage({super.key});

  @override
  State<CreateAnnouncementPage> createState() => _CreateAnnouncementPageState();
}

class _CreateAnnouncementPageState extends State<CreateAnnouncementPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  // Simulation of media selection
  bool _hasMedia = false;
  MediaType _selectedMediaType = MediaType.none;
  String? _simulatedMediaUrl;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateState);
    _contentController.addListener(_updateState);
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateState);
    _contentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  bool get _isValid =>
      _titleController.text.isNotEmpty &&
      _contentController.text.isNotEmpty &&
      _hasMedia;

  void _handleMediaSelection(MediaType type) {
    Navigator.pop(context); // Close bottom sheet
    setState(() {
      _hasMedia = true;
      _selectedMediaType = type;
      // Simulate a URL based on type
      _simulatedMediaUrl = type == MediaType.video
          ? 'https://example.com/video.mp4' // Placeholder, won't actually play but indicates video
          : 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/800/400';
    });
  }

  void _removeMedia() {
    setState(() {
      _hasMedia = false;
      _selectedMediaType = MediaType.none;
      _simulatedMediaUrl = null;
    });
  }

  void _showMediaPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
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
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.cyanAccent),
                title: const Text(
                  'Cámara',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => _handleMediaSelection(MediaType.image),
              ),
              ListTile(
                leading: const Icon(Icons.image, color: Colors.purpleAccent),
                title: const Text(
                  'Galería',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => _handleMediaSelection(MediaType.image),
              ),
              ListTile(
                leading: const Icon(Icons.videocam, color: Colors.orangeAccent),
                title: const Text(
                  'Video',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => _handleMediaSelection(MediaType.video),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Crear Anuncio',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media Upload Area
            GestureDetector(
              onTap: _hasMedia ? null : _showMediaPicker,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  border: _hasMedia
                      ? null
                      : Border.all(
                          color: Colors.grey.shade800,
                          style: BorderStyle.solid,
                        ),
                ),
                child: _hasMedia
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _selectedMediaType == MediaType.video
                                ? Container(
                                    color: Colors.black,
                                    child: const Center(
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        size: 64,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: _simulatedMediaUrl!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _removeMedia,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            size: 48,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Añadir Foto o Video',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Title Input
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Título',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF0040)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Content Input
            TextField(
              controller: _contentController,
              style: const TextStyle(color: Colors.white),
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF0040)),
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF0040),
                  disabledBackgroundColor: Colors.grey.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isValid
                    ? () {
                        final newAnnouncement = Announcement(
                          id: DateTime.now().toString(),
                          title: _titleController.text,
                          content: _contentController.text,
                          mediaUrl: _simulatedMediaUrl,
                          mediaType: _selectedMediaType,
                          date: DateTime.now(),
                          isOfficial: true,
                        );
                        Navigator.pop(context, newAnnouncement);
                      }
                    : null,
                child: Text(
                  'PUBLICAR',
                  style: TextStyle(
                    color: _isValid ? Colors.white : Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
