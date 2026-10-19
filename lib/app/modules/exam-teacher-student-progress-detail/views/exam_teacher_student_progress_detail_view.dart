import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/exam_teacher_student_progress_detail_controller.dart';

class ExamTeacherStudentProgressDetailView
    extends GetView<ExamTeacherStudentProgressDetailController> {
  const ExamTeacherStudentProgressDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExamTeacherStudentProgressDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ExamTeacherStudentProgressDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
