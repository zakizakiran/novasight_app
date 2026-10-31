import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/record_note_controller.dart';

class RecordNoteView extends GetView<RecordNoteController> {
  const RecordNoteView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecordNoteView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RecordNoteView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
