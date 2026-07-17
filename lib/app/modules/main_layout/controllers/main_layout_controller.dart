import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/main_bar_args.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';

import '../../chatbot/views/chatbot_view.dart' show ChatbotView;
import '../../exam-teachers/views/exam_teachers_view.dart';
import '../../exam/views/exam_view.dart';
import '../../module/views/module_view.dart';
import '../../module_teachers/module_teacher/views/module_teacher_view.dart';
import '../../profile/views/profile_view.dart';
import '../../student-dashboard/views/student_dashboard_view.dart';
import '../../teacher-dashboard/views/teacher_dashboard_view.dart';
import '../model/bottom_nav_item.dart';

class MainLayoutController extends GetxController {
  final currentIndex = 0.obs;
  late final UserRoles currentRole;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as MainBarArgs;
    currentIndex.value = args.index;
    currentRole = args.role;
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  List<Widget> get pages => switch (currentRole) {
    UserRoles.siswa => _studentPages,
    UserRoles.guru => _teacherPages,
  };

  List<BottomNavItem> get bottomItems => switch (currentRole) {
    UserRoles.siswa => _studentItems,
    UserRoles.guru => _teacherItems,
  };

  static const _studentPages = [
    StudentDashboardView(),
    ModuleView(),
    ExamView(),
    ChatbotView(),
    ProfileView(),
  ];

  static const _teacherPages = [
    TeacherDashboardView(),
    ModuleTeacherView(),
    ExamTeachersView(),
    ProfileView(),
  ];

  static const _studentItems = [
    BottomNavItem(
      icon: Icons.grid_view,
      title: "Dashboard",
      semanticLabel: "Dashboard",
    ),
    BottomNavItem(
      icon: Icons.view_agenda_outlined,
      title: "Modul",
      semanticLabel: "Modul",
    ),
    BottomNavItem(
      icon: Icons.menu_book_outlined,
      title: "Soal Ujian",
      semanticLabel: "Soal Ujian",
    ),
    BottomNavItem(
      icon: Icons.chat_bubble_outline,
      title: "Chatbot",
      semanticLabel: "Chatbot",
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      title: "Profil",
      semanticLabel: "Profil",
    ),
  ];

  static const _teacherItems = [
    BottomNavItem(
      icon: Icons.grid_view,
      title: "Dashboard",
      semanticLabel: "Dashboard",
    ),
    BottomNavItem(
      icon: Icons.view_agenda_outlined,
      title: "Modul",
      semanticLabel: "Modul",
    ),
    BottomNavItem(
      icon: Icons.menu_book_outlined,
      title: "Soal Ujian",
      semanticLabel: "Soal Ujian",
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      title: "Profil",
      semanticLabel: "Profil",
    ),
  ];
}

enum MainBarStudent{
  home,
  module,
  exam,
  chatbot,
  profile;
}
