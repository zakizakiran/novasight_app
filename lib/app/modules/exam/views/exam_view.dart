import 'package:flutter/material.dart';

class ExamView extends StatelessWidget {
  const ExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soal Ujian'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Halaman Soal Ujian (Placeholder)',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
