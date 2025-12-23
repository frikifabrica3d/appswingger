import 'package:flutter/material.dart';

class LegalDocsPage extends StatelessWidget {
  final String title;
  final String content;

  const LegalDocsPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
