
import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/subject_args.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';
import '../../../data/model/subject_model.dart';

class SubjectController extends GetxController {
  final ModuleRepository _repository;
  late final SubjectModel subject;
  late final int index;
  final Rx<int> currentPageNumber = 1.obs;

  SubjectController({required this._repository});

  @override
  void onInit() {
    final args = Get.arguments as SubjectArgs;
    super.onInit();
    subject = args.subject;
    index = args.index;
  }

  void onNext(){
    currentPageNumber.value += 1;
  }

  void onPrevious(){
    currentPageNumber.value -= 1;
  }

  void onDone(){
    _repository.onDoneSubject(subject.id);
    Get.back();
    Get.back();
  }
}
