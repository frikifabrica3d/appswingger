import 'package:flutter/material.dart';
import 'dart:io';

class CreatePostPage extends StatefulWidget {
  final String? imagePath;

  const CreatePostPage({super.key, this.imagePath});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _captionController = TextEditingController();
  bool _isPublishEnabled = false;

  @override
  void initState() {
    super.initState();
    _captionController.addListener(_checkPublishability);
    // If we have an image, we can publish immediately
    if (widget.imagePath != null) {
      _isPublishEnabled = true;
    }
  }

  void _checkPublishability() {
    setState(() {
      _isPublishEnabled =
          _captionController.text.trim().isNotEmpty || widget.imagePath != null;
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Crear Publicación',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _isPublishEnabled
                ? () {
                    // TODO: Implement publish logic
                    Navigator.pop(context);
                  }
                : null,
            child: Text(
              'Publicar',
              style: TextStyle(
                color: _isPublishEnabled
                    ? const Color(0xFFFF0040)
                    : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Preview
            if (widget.imagePath != null)
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  image: DecorationImage(
                    image: FileImage(File(widget.imagePath!)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              // Placeholder if no image (e.g. text only mode)
              Container(
                width: double.infinity,
                height: 100,
                color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),

            // Caption Input
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[800],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _captionController,
                      style: TextStyle(color: textColor, fontSize: 16),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '¿Qué estás pensando?',
                        hintStyle: TextStyle(
                          color: isDarkMode
                              ? Colors.grey[600]
                              : Colors.grey[400],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Colors.grey),

            // Extra Options
            _buildOptionItem(
              icon: Icons.location_on_outlined,
              label: 'Agregar Ubicación',
              color: Colors.redAccent,
              textColor: textColor,
              onTap: () {},
            ),
            _buildOptionItem(
              icon: Icons.person_add_alt_1_outlined,
              label: 'Etiquetar Personas',
              color: Colors.blueAccent,
              textColor: textColor,
              onTap: () {},
            ),
            _buildOptionItem(
              icon: Icons.tag,
              label: 'Hashtags',
              color: Colors.greenAccent,
              textColor: textColor,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
