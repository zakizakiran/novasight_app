import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/data/model/class_model.dart';
import 'package:novasight_app/app/data/model/selected_pdf_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:novasight_app/app/routes/app_pages.dart';


class CreateModuleController extends GetxController {
  final TextEditingController titleModuleController = TextEditingController();
  final TextEditingController descriptionModuleController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final Rxn<SelectedPdfModel> selectedPdf = Rxn<SelectedPdfModel>();

  final Rx<bool> isLoading = false.obs;
  final Rx<bool> isValid = false.obs;
  final List<ClassGradeType> listClass = ClassGradeType.values;
  final Rxn<ClassGradeType> selectedGrade = Rxn<ClassGradeType>();

  final Rx<double> progress = 0.0.obs;
  final List<LoadingStep> uploadSteps = [
    LoadingStep(title: "Membaca dokumen", initialStatus: LoadingStepStatus.pending),
    LoadingStep(title: "Menganalisis konten", initialStatus: LoadingStepStatus.pending),
    LoadingStep(title: "Membuat anotasi", initialStatus: LoadingStepStatus.pending),
  ];

  void onChange(String _){
    final bool isValidTitle = titleModuleController.text.isNotEmpty;
    final bool isValidClass = selectedGrade.value != null;
    final bool isValidPdf = selectedPdf.value != null;
    isValid.value = isValidTitle && isValidClass && isValidPdf;
  }

  void onSelectGrade(ClassGradeType type){
    selectedGrade.value = type;
    onChange(type.name);
  }

  Future<void> onUploadModule() async {
    isLoading.value = true;
    progress.value = 0.0;
    for (var step in uploadSteps) {
      step.status.value = LoadingStepStatus.pending;
    }

    Get.toNamed(Routes.CREATE_MODULE_LOADING);
    try {
      // --- STEP 1: Membaca Dokumen ---
      uploadSteps[0].status.value = LoadingStepStatus.processing;
      await _simulateProgress(start: 0.0, end: 0.3, durationMs: 1500);
      uploadSteps[0].status.value = LoadingStepStatus.completed;

      // --- STEP 2: Menganalisis Konten ---
      uploadSteps[1].status.value = LoadingStepStatus.processing;
      await _simulateProgress(start: 0.3, end: 0.6, durationMs: 2000);
      uploadSteps[1].status.value = LoadingStepStatus.completed;

      // --- STEP 3: Membuat Anotasi ---
      uploadSteps[2].status.value = LoadingStepStatus.processing;
      await _simulateProgress(start: 0.6, end: 1.0, durationMs: 1500);
      uploadSteps[2].status.value = LoadingStepStatus.completed;

      await Future.delayed(const Duration(milliseconds: 500));
      // Get.offToNamed(); // Close dialog
      SnackbarHelper.showSuccess(title: "Modul Berhasil diproses", message: "Anotasi AI sudah siap digunakan.");


    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Gagal memproses modul.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _simulateProgress({required double start, required double end, required int durationMs}) async {
    const steps = 10;
    final stepDuration = durationMs ~/ steps;
    final increment = (end - start) / steps;

    for (int i = 0; i <= steps; i++) {
      progress.value = start + (increment * i);
      await Future.delayed(Duration(milliseconds: stepDuration));
    }
  }

  Future<void> onPickModule() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
        withData: true,
      );

      if (result == null) return;

      final file = result.files.single;

      selectedPdf.value = SelectedPdfModel(
        name: file.name,
        bytes: file.bytes!,
        size: file.size,
      );
      onChange(file.name);
    } on PlatformException catch (e) {
      Get.snackbar(
        "Gagal memilih file",
        "Jika mengambil dari gdrive silahkan cek koneksi internet anda.",
      );

      debugPrint(e.toString());
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    titleModuleController.dispose();
    descriptionModuleController.dispose();
    super.onClose();
  }
}

enum LoadingStepStatus { pending, processing, completed }

class LoadingStep {
  final String title;
  final Rx<LoadingStepStatus> status;

  LoadingStep({
    required this.title,
    required LoadingStepStatus initialStatus,
  }) : status = initialStatus.obs;
}