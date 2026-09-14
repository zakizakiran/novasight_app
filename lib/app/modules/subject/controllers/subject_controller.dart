import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/subject_args.dart';
import 'package:novasight_app/app/data/model/subject_model.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';

class SubjectController extends GetxController {
  final ModuleRepository? moduleRepository;
  final StudentRepository? studentRepository;

  late final SubjectModel subject;
  late final int index;
  final Rx<int> currentPageNumber = 1.obs;

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

  void onNext() {
    currentPageNumber.value += 1;
  }

  void onPrevious() {
    currentPageNumber.value -= 1;
  }

  void onDone() {
    Get.back();
    Get.back();
  }

  Future<void> onConfirmSubject() async {
    // 1. Mark complete on backend via Student API
    if (studentRepository != null) {
      try {
        await studentRepository!.markChapterComplete(chapterId: subject.id);
      } catch (_) {
        // Continue even if network error so local state updates
      }
    }

    // 2. Mark complete on local mock repository if present
    moduleRepository?.onDoneSubject(subject.id);
  }
}
