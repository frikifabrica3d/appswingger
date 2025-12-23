import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Ticket Enviado',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Ticket #1234 creado exitosamente.\nNuestro equipo te contactará pronto.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Color(0xFFFF0040)),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Centro de Soporte',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFF0040),
          labelColor: const Color(0xFFFF0040),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Preguntas Frecuentes'),
            Tab(text: 'Contactar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFaqTab(), _buildContactTab()],
      ),
    );
  }

  Widget _buildFaqTab() {
    final faqs = [
      {
        'q': '¿Cómo cambio mi foto de perfil?',
        'a': 'Ve a tu perfil y toca el icono de cámara sobre tu foto actual.',
      },
      {
        'q': '¿Es gratis usar Swingo?',
        'a':
            'Sí, la mayoría de las funciones son gratuitas. Ofrecemos planes Premium para funciones extra.',
      },
      {
        'q': 'Problemas de conexión',
        'a':
            'Verifica tu conexión a internet y asegúrate de tener la última versión de la app.',
      },
      {
        'q': '¿Cómo reportar un usuario?',
        'a':
            'Ve al perfil del usuario, toca los 3 puntos y selecciona "Reportar".',
      },
      {
        'q': 'Privacidad y Seguridad',
        'a':
            'Nos tomamos muy en serio tu privacidad. Consulta nuestra política de privacidad en Ajustes.',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        return Card(
          color: const Color(0xFF1E1E1E),
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text(
              faqs[index]['q']!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconColor: const Color(0xFFFF0040),
            collapsedIconColor: Colors.grey,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  faqs[index]['a']!,
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿En qué podemos ayudarte?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Category Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Categoría'),
              items: [
                'Error',
                'Técnico',
                'Reporte',
                'Sugerencia',
                'Otros',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
              validator: (val) =>
                  val == null ? 'Selecciona una categoría' : null,
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Asunto'),
              validator: (val) => val!.isEmpty ? 'Ingresa un asunto' : null,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 5,
              decoration: _inputDecoration('Describe tu problema...'),
              validator: (val) => val!.isEmpty ? 'Describe el problema' : null,
            ),
            const SizedBox(height: 16),

            // Attach Button
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Simulando adjuntar imagen...')),
                );
              },
              icon: const Icon(Icons.attach_file),
              label: const Text('Adjuntar Captura'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey,
                side: const BorderSide(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),

            // Info Text
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Tiempo estimado de respuesta: 72 horas',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF0040),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'ENVIAR TICKET',
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF0040)),
      ),
    );
  }
}
