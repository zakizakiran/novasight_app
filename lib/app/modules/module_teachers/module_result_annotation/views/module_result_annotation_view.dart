import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/module_result_annotation_controller.dart';

class ModuleResultAnnotationView
    extends GetView<ModuleResultAnnotationController> {
  const ModuleResultAnnotationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ModuleResultAnnotationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ModuleResultAnnotationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
