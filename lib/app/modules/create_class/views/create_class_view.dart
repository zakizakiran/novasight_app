import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/create_class_controller.dart';

class CreateClassView extends GetView<CreateClassController> {
  const CreateClassView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreateClassView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CreateClassView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
