import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:novasight_app/app/modules/student-dashboard/views/student_dashboard_view.dart';

import '../../chatbot/views/chatbot_view.dart';
import '../../exam/views/exam_view.dart';
import '../../module/views/module_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_layout_controller.dart';

class MainLayoutView extends GetView<MainLayoutController> {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            StudentDashboardView(),
            ModuleView(),
            ExamView(),
            ChatbotView(),
            ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: Obx(
              () => GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.blue,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.blue.withOpacity(0.1),
                color: Colors.grey[600],
                tabs: const [
                  GButton(icon: Icons.grid_view, text: 'Dashboard'),
                  GButton(icon: Icons.view_agenda_outlined, text: 'Modul'),
                  GButton(icon: Icons.menu_book_outlined, text: 'Soal Ujian'),
                  GButton(icon: Icons.chat_bubble_outline, text: 'Chatbot'),
                  GButton(icon: Icons.person_outline, text: 'Profil'),
                ],
                selectedIndex: controller.currentIndex.value,
                onTabChange: controller.changePage,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
