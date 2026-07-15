import 'package:flutter/material.dart';

class ChatbotView extends StatelessWidget {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Halaman Chatbot (Placeholder)',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
