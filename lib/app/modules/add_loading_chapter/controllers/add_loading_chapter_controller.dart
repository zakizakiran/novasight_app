import 'dart:async';

import 'package:get/get.dart';

import '../../../data/models/chapter_job_stream_model.dart';
import '../../../data/repositories/teacher_repository.dart';
import '../../../routes/app_pages.dart';
import '../../module_teachers/create_module/controllers/create_module_controller.dart';

class AddLoadingChapterController extends GetxController {
  final TeacherRepository? teacherRepository;
  final Rx<double> progress = 0.0.obs;
  StreamSubscription<ChapterJobStreamEvent>? _jobSubscription;

  AddLoadingChapterController({
    TeacherRepository? teacherRepository,
  }) : teacherRepository =
      teacherRepository ??
          (Get.isRegistered<TeacherRepository>()
              ? Get.find<TeacherRepository>()
              : null);

  final List<LoadingStep> uploadSteps = [
    LoadingStep(
      title: "Membaca dokumen",
      initialStatus: LoadingStepStatus.pending,
    ),
    LoadingStep(
      title: "Menganalisis konten",
      initialStatus: LoadingStepStatus.pending,
    ),
    LoadingStep(
      title: "Membuat anotasi",
      initialStatus: LoadingStepStatus.pending,
    ),
  ];
  final Rx<bool> isLoading = false.obs;
  final RxInt jobId = 0.obs;

  @override
  void onInit() {
    final args = Get.arguments;
    if(args is int){
      jobId.value = args;
      startTrackingJob(args);
    }
    super.onInit();
  }

  @override
  void onClose() {
    _cancelJobStream();
    super.onClose();
  }

  void cancelLoadingProcess() {
    _cancelJobStream();
  }

  void startTrackingJob(int id) {
    jobId.value = id;
    _startTrackingChapterJobs();
  }

  void _startTrackingChapterJobs() {
    if (teacherRepository == null || jobId.value == 0) return;

    _jobSubscription?.cancel();

    _jobSubscription = teacherRepository!.streamChapterJob(jobId.value).listen(
          (event) {
        // Convert 0.0 - 100.0 event progress to 0.0 - 1.0 for LinearProgressIndicator
        progress.value = (event.progress / 100.0).clamp(0.0, 1.0);
        updateLoadingSteps(event.progress);

        // Stop listening once the job finishes or fails
        if (event.isDone || event.isFailed) {
          _cancelJobStream();
          Get.back();
          return;
        }
      },
      onError: (error) {
        _cancelJobStream();
      },
    );
  }

  void _cancelJobStream() {
    isLoading.value = false;
    _jobSubscription?.cancel();
    _jobSubscription = null;
  }

  void updateLoadingSteps(double prog) {
    if (prog < 35) {
      uploadSteps[0].status.value = LoadingStepStatus.processing;
      uploadSteps[1].status.value = LoadingStepStatus.pending;
      uploadSteps[2].status.value = LoadingStepStatus.pending;
    } else if (prog < 70) {
      uploadSteps[0].status.value = LoadingStepStatus.completed;
      uploadSteps[1].status.value = LoadingStepStatus.processing;
      uploadSteps[2].status.value = LoadingStepStatus.pending;
    } else if (prog < 100) {
      uploadSteps[0].status.value = LoadingStepStatus.completed;
      uploadSteps[1].status.value = LoadingStepStatus.completed;
      uploadSteps[2].status.value = LoadingStepStatus.processing;
    } else {
      uploadSteps[0].status.value = LoadingStepStatus.completed;
      uploadSteps[1].status.value = LoadingStepStatus.completed;
      uploadSteps[2].status.value = LoadingStepStatus.completed;
    }
  }
}
