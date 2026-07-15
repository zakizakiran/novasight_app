import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Halaman Profil (Placeholder)',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
