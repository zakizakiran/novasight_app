import 'package:flutter/cupertino.dart';
import 'package:flutter/semantics.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/args/subject_args.dart';
import 'package:lydera_app/app/core/utils/table_mode.dart';
import 'package:lydera_app/app/data/model/subject_model.dart';
import 'package:lydera_app/app/data/repositories/module_repository.dart';
import 'package:lydera_app/app/data/repositories/student_repository.dart';
import 'package:lydera_app/app/modules/module/controllers/module_controller.dart';
import 'package:lydera_app/app/modules/module_detail/controllers/module_detail_controller.dart';
import 'package:lydera_app/app/modules/student-dashboard/controllers/student_dashboard_controller.dart';

class SubjectController extends GetxController {
  final ModuleRepository? moduleRepository;
  final StudentRepository? studentRepository;

  late final SubjectModel subject;
  late final int index;
  final Rx<int> currentPageNumber = 1.obs;
  final Rx<TableMode> selectedMode = TableMode.cell.obs;

  final TextEditingController searchController = TextEditingController();

  SubjectController({
    ModuleRepository? moduleRepository,
    ModuleRepository? repository,
    StudentRepository? studentRepository,
  })  : moduleRepository = moduleRepository ??
            repository ??
            (Get.isRegistered<ModuleRepository>()
                ? Get.find<ModuleRepository>()
                : null),
        studentRepository = studentRepository ??
            (Get.isRegistered<StudentRepository>()
                ? Get.find<StudentRepository>()
                : null);

  @override
  void onInit() {
    final args = Get.arguments as SubjectArgs;
    super.onInit();
    subject = args.subject;
    index = args.index;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onNext() {
    currentPageNumber.value += 1;
  }

  void onPage(int page) {
    if (page < 1){
      return;
    }
    if (page > subject.pages.length){
      return;
    }
    currentPageNumber.value = page;
    SemanticsService.announce("Pergi ke halaman $page", TextDirection.ltr);
    print('Current Number : ${currentPageNumber.value}');
  }

  void onPrevious() {
    currentPageNumber.value -= 1;
  }

  void onSentenceTapped(sentence){
    SemanticsService.announce(sentence, TextDirection.ltr);
  }

  void onDone() {
    Get.back();
    Get.back(result: true);
  }

  Future<void> onConfirmSubject() async {
    if (Get.isRegistered<ModuleDetailController>()) {
      Get.find<ModuleDetailController>().markChapterDoneLocally(subject.id);
    }

    // 1. Mark complete on backend via Student API
    if (studentRepository != null) {
      try {
        await studentRepository!.markChapterComplete(chapterId: subject.id);
      } catch (_) {
        // Continue even if network error so local state updates
      }
    }


    // 3. Trigger background sync for ModuleController & StudentDashboardController
    if (Get.isRegistered<ModuleController>()) {
      Get.find<ModuleController>().onLoad();
    }
    if (Get.isRegistered<StudentDashboardController>()) {
      Get.find<StudentDashboardController>().onRefresh();
    }
  }
}
