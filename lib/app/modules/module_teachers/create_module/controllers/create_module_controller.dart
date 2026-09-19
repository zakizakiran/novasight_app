import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/data/models/cp_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:novasight_app/app/core/args/main_bar_args.dart';
import 'package:novasight_app/app/core/args/module_result_args.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/data/model/class_model.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/data/model/selected_pdf_model.dart';
import 'package:novasight_app/app/data/models/chapter_create_response_model.dart';
import 'package:novasight_app/app/data/models/chapter_job_stream_model.dart';
import 'package:novasight_app/app/data/models/fase_model.dart';
import 'package:novasight_app/app/data/models/teacher_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/teacher_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/routes/app_pages.dart';
import 'package:novasight_app/app/modules/main_layout/controllers/main_layout_controller.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/controllers/module_teacher_controller.dart';

enum CreateModuleStep { infoModul, potongChapter }

class TrackedChapterJob {
  final int chapterId;
  final int jobId;
  final int chapterNumber;
  final String title;
  final int startPage;
  final int endPage;
  final Uint8List? chapterPdfBytes;
  final RxDouble progress; // 0.0 to 100.0
  final RxString status; // 'queued', 'running', 'done', 'failed'
  final RxString message;
  final RxnString annotationPath;
  final RxBool isReviewed;
  StreamSubscription<ChapterJobStreamEvent>? subscription;

  TrackedChapterJob({
    required this.chapterId,
    required this.jobId,
    required this.chapterNumber,
    required this.title,
    required this.startPage,
    required this.endPage,
    this.chapterPdfBytes,
    double initialProgress = 0.0,
    String initialStatus = 'running',
    String initialMessage = 'Menyiapkan pemrosesan...',
    String? annotationPath,
    bool isReviewed = false,
  }) : progress = initialProgress.obs,
       status = initialStatus.obs,
       message = initialMessage.obs,
       annotationPath = RxnString(annotationPath),
       isReviewed = isReviewed.obs;

  bool get isDone =>
      status.value.toLowerCase() == 'done' ||
      status.value.toLowerCase() == 'completed' ||
      progress.value >= 100.0;

  bool get isFailed =>
      status.value.toLowerCase() == 'failed' ||
      status.value.toLowerCase() == 'error';

  void dispose() {
    subscription?.cancel();
  }
}

class CreateModuleController extends GetxController {
  final TeacherRepository? teacherRepository;
  final ClassroomRepository? classroomRepository;
  final StorageService? storageService;

  CreateModuleController({
    TeacherRepository? teacherRepository,
    ClassroomRepository? classroomRepository,
    StorageService? storageService,
  }) : teacherRepository =
           teacherRepository ??
           (Get.isRegistered<TeacherRepository>()
               ? Get.find<TeacherRepository>()
               : null),
       classroomRepository =
           classroomRepository ??
           (Get.isRegistered<ClassroomRepository>()
               ? Get.find<ClassroomRepository>()
               : null),
       storageService =
           storageService ??
           (Get.isRegistered<StorageService>()
               ? Get.find<StorageService>()
               : null);

  final TextEditingController titleModuleController = TextEditingController();
  final TextEditingController descriptionModuleController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();
  final bool _isCancelled = false;

  final Rxn<SelectedPdfModel> selectedPdf = Rxn<SelectedPdfModel>();
  final RxInt totalPages = 0.obs;

  final Rx<CreateModuleStep> currentStep = CreateModuleStep.infoModul.obs;
  final Rx<bool> isLoading = false.obs;
  final Rx<bool> isSavingModule = false.obs;
  final Rx<bool> isValid = false.obs;

  // Saved module reference from POST /api/modules
  final Rxn<TeacherNewestModuleModel> savedModule =
      Rxn<TeacherNewestModuleModel>();

  // Chapter Creation Form Controllers
  final TextEditingController chapterNumberController = TextEditingController(
    text: '1',
  );
  final TextEditingController chapterTitleController = TextEditingController();
  final TextEditingController startPageController = TextEditingController(
    text: '1',
  );
  final TextEditingController endPageController = TextEditingController();

  final RxBool isCreatingChapter = false.obs;
  final RxList<ChapterCreateResponseModel> createdChapters =
      <ChapterCreateResponseModel>[].obs;
  final RxList<TrackedChapterJob> trackedJobs = <TrackedChapterJob>[].obs;
  final Rxn<TrackedChapterJob> activeInspectedJob = Rxn<TrackedChapterJob>();
  final RxBool isOpeningChapter = false.obs;
  final RxnInt openingJobId = RxnInt(null);

  // Fase states according to API documentation (/api/fases)
  final RxList<FaseModel> listFase = <FaseModel>[].obs;
  final Rxn<FaseModel> selectedFase = Rxn<FaseModel>();
  final RxBool isLoadingFase = false.obs;

  // Fase states according to API documentation (/api/cp)
  final RxList<CpModel> listCp = <CpModel>[].obs;
  final Rxn<CpModel> selectedCp = Rxn<CpModel>();
  final RxBool isLoadingCp = false.obs;


  // Deprecated/fallback grade states
  final List<ClassGradeType> listClass = ClassGradeType.values;
  final Rxn<ClassGradeType> selectedGrade = Rxn<ClassGradeType>();

  final Rx<double> progress = 0.0.obs;
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

  void onChange(String _) {
    final bool isValidTitle = titleModuleController.text.trim().isNotEmpty;
    final bool isValidFase = selectedFase.value != null;
    final bool isValidPdf = selectedPdf.value != null;
    isValid.value = isValidTitle && isValidFase && isValidPdf;
  }

  void onSelectFase(FaseModel fase) {
    selectedFase.value = fase;
    onChange(fase.displayName);
  }

  void onSelectCp(CpModel cp) {
    selectedCp.value = cp;
    onChange(cp.domain);
  }

  void onSelectGrade(ClassGradeType type) {
    selectedGrade.value = type;
    onChange(type.name);
  }

  Future<int?> _resolveClassroomId() async {
    if (classroomRepository == null) return null;
    try {
      final list = await classroomRepository!.getClassrooms();
      if (list.isEmpty) return null;
      final cachedCode = storageService?.getClassCode();
      final selected =
          list.firstWhereOrNull((c) => c.code == cachedCode) ?? list.first;
      return selected.id;
    } catch (e) {
      debugPrint('Error resolving classroom id: $e');
      return null;
    }
  }

  /// Step 1 Action: Simpan data modul via POST /api/modules
  Future<void> onSaveModule() async {
    if (!isValid.value) return;

    final String title = titleModuleController.text.trim();
    final String description = descriptionModuleController.text.trim();
    final int? faseId = selectedFase.value?.id;

    if (faseId == null) {
      SnackbarHelper.showError(
        title: "Pilih Fase",
        message: "Silakan pilih fase sebelum menyimpan modul.",
      );
      return;
    }

    isSavingModule.value = true;
    try {
      int classroomId = 1;
      final resolvedId = await _resolveClassroomId();
      if (resolvedId != null) {
        classroomId = resolvedId;
      }

      if (teacherRepository != null) {
        final result = await teacherRepository!.createModule(
          title: title,
          description: description,
          faseId: faseId,
          classroomId: classroomId,
          status: 'draft',
        );
        savedModule.value = result;
      } else {
        savedModule.value = TeacherNewestModuleModel(
          id: 1,
          title: title,
          faseId: faseId,
          createdAt: DateTime.now(),
        );
      }

      await fetchCp(selectedFase.value?.id ?? 1);

      // Pre-fill chapter title suggestion
      chapterTitleController.text = "BAB 1 : $title";
      chapterNumberController.text = "1";
      startPageController.text = "1";
      if (totalPages.value > 0) {
        endPageController.text = totalPages.value.toString();
      }

      currentStep.value = CreateModuleStep.potongChapter;

      SnackbarHelper.showSuccess(
        title: "Modul Berhasil Disimpan",
        message: "Silakan atur rentang halaman untuk membuat BAB (Chapter).",
      );
    } catch (e) {
      debugPrint('Error saving module: $e');
      SnackbarHelper.showError(
        title: "Gagal Menyimpan Modul",
        message: e.toString(),
      );
    } finally {
      isSavingModule.value = false;
    }
  }

  /// Slices the selected PDF between [startPage] and [endPage] (inclusive, 1-indexed)
  List<int> slicePdfPages({
    required List<int> originalBytes,
    required int startPage,
    required int endPage,
  })
  {
    final PdfDocument inputDoc = PdfDocument(inputBytes: originalBytes);
    final PdfDocument outputDoc = PdfDocument();

    final int total = inputDoc.pages.count;
    final int safeStart = startPage.clamp(1, total);
    final int safeEnd = endPage.clamp(safeStart, total);

    for (int i = safeStart - 1; i < safeEnd; i++) {
      final PdfTemplate template = inputDoc.pages[i].createTemplate();
      final PdfPage page = outputDoc.pages.add();
      page.graphics.drawPdfTemplate(template, const Offset(0, 0));
    }

    final List<int> sliced = outputDoc.saveSync();
    inputDoc.dispose();
    outputDoc.dispose();
    return sliced;
  }

  /// Step 2 Action: Slices the PDF and calls POST /api/chapters
  Future<void> onCreateChapter() async {
    final moduleId = savedModule.value?.id;
    if (moduleId == null) {
      SnackbarHelper.showError(
        title: "Error",
        message: "Modul belum tersimpan. Silakan simpan modul terlebih dahulu.",
      );
      return;
    }

    if (selectedPdf.value?.bytes == null) {
      SnackbarHelper.showError(
        title: "File Tidak Ada",
        message: "File PDF modul belum dipilih.",
      );
      return;
    }

    if (selectedCp.value?.id == null) {
      SnackbarHelper.showError(
        title: "Capaian Pembelajaran Tidak Ada",
        message: "Capaian pembelajaran belum dipilih.",
      );
      return;
    }

    final String chapterTitle = chapterTitleController.text.trim();
    if (chapterTitle.isEmpty) {
      SnackbarHelper.showError(
        title: "Judul BAB Kosong",
        message: "Silakan masukkan judul BAB.",
      );
      return;
    }

    final int? startPage = int.tryParse(startPageController.text.trim());
    final int? endPage = int.tryParse(endPageController.text.trim());

    if (startPage == null || endPage == null) {
      SnackbarHelper.showError(
        title: "Rentang Halaman Tidak Valid",
        message: "Masukkan angka halaman awal dan akhir dengan benar.",
      );
      return;
    }

    final int total = totalPages.value > 0 ? totalPages.value : 10000;
    if (startPage < 1 || endPage < startPage || endPage > total) {
      SnackbarHelper.showError(
        title: "Rentang Halaman Salah",
        message: "Rentang halaman harus antara 1 sampai $total.",
      );
      return;
    }

    final int chapterNum =
        int.tryParse(chapterNumberController.text.trim()) ?? 1;

    isCreatingChapter.value = true;
    try {
      // 1. Slice the PDF
      final slicedBytes = slicePdfPages(
        originalBytes: selectedPdf.value!.bytes,
        startPage: startPage,
        endPage: endPage,
      );

      final fileName = 'bab_${chapterNum}_p${startPage}_$endPage.pdf';

      // 2. Call POST /api/chapters
      // Resolves cp_id matching the module's fase (Fase E -> cp_id 1)
      final int faseId =
          savedModule.value?.faseId ?? selectedFase.value?.id ?? 1;
      final int cpId = selectedCp.value?.id ?? 1;

      ChapterCreateResponseModel? response;
      if (teacherRepository != null) {
        response = await teacherRepository!.createChapter(
          fileBytes: slicedBytes,
          fileName: fileName,
          moduleId: moduleId,
          title: chapterTitle,
          cpId: cpId,
          number: chapterNum,
        );
      } else {
        response = ChapterCreateResponseModel(
          chapterId: 1,
          jobId: 1,
          status: "running",
        );
      }

      createdChapters.add(response);

      final trackedJob = TrackedChapterJob(
        chapterId: response.chapterId,
        jobId: response.jobId,
        chapterNumber: chapterNum,
        title: chapterTitle,
        startPage: startPage,
        endPage: endPage,
        chapterPdfBytes: Uint8List.fromList(slicedBytes),
        initialStatus: response.status,
      );
      trackedJobs.add(trackedJob);
      _listenToJobStream(trackedJob);

      SnackbarHelper.showSuccess(
        title: "Chapter Berhasil Dibuat",
        message:
            "BAB $chapterNum ($chapterTitle) halaman $startPage-$endPage berhasil diunggah.",
      );

      // Advance chapter suggestions for next potential chapter
      chapterNumberController.text = (chapterNum + 1).toString();
      chapterTitleController.text = "BAB ${(chapterNum + 1)} : ";
      if (endPage < total) {
        startPageController.text = (endPage + 1).toString();
        endPageController.text = total.toString();
      }
    } catch (e) {
      debugPrint('Error creating chapter: $e');
      SnackbarHelper.showError(
        title: "Gagal Membuat Chapter",
        message: e.toString(),
      );
    } finally {
      isCreatingChapter.value = false;
    }
  }

  /// Listens to real-time SSE stream for a chapter job
  void _listenToJobStream(TrackedChapterJob job) {
    if (teacherRepository == null) return;

    job.subscription = teacherRepository!
        .streamChapterJob(job.jobId)
        .listen(
          (event) {
            job.progress.value = event.progress;
            job.status.value = event.status;
            if (event.message.isNotEmpty) {
              job.message.value = event.message;
            }
            if (event.annotationPath != null) {
              job.annotationPath.value = event.annotationPath;
            }

            // If this job is currently displayed in the loading screen
            if (activeInspectedJob.value?.jobId == job.jobId) {
              progress.value = (event.progress / 100.0).clamp(0.0, 1.0);
              updateLoadingSteps(event.progress);

              if (event.isDone) {
                openChapterPreview(job);
              }
            }
          },
          onError: (err) {
            debugPrint('Error in SSE job stream for job ${job.jobId}: $err');
          },
        );
  }

  /// Updates step checklist statuses based on progress percentage
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

  /// Action when user taps a chapter item in the list
  Future<void> onTapChapterItem(TrackedChapterJob job) async {
    if (isOpeningChapter.value) return;

    if (job.isDone) {
      isOpeningChapter.value = true;
      openingJobId.value = job.jobId;
      try {
        await openChapterPreview(job);
      } finally {
        isOpeningChapter.value = false;
        openingJobId.value = null;
      }
    } else {
      activeInspectedJob.value = job;
      progress.value = (job.progress.value / 100.0).clamp(0.0, 1.0);
      updateLoadingSteps(job.progress.value);
      Get.toNamed(Routes.CREATE_MODULE_LOADING, arguments: job);
    }
  }

  /// Opens preview screen with real annotated blocks if available
  Future<void> openChapterPreview(TrackedChapterJob job) async {
    List<ModuleChunk> chunks = [];
    try {
      if (teacherRepository != null) {
        // 1. If annotationPath is present, confirm chapter first to ingest blocks into DB
        if (job.annotationPath.value != null &&
            job.annotationPath.value!.isNotEmpty) {
          try {
            await teacherRepository!.confirmChapter(
              chapterId: job.chapterId,
              annotationPath: job.annotationPath.value!,
            );
          } catch (e) {
            // Already confirmed or minor notice; proceed to fetch detail
            debugPrint('confirmChapter auto-confirm notice: $e');
          }
        }

        // 2. Fetch chapter detail from DB which has real database block IDs
        try {
          final detail = await teacherRepository!.getChapterDetail(
            chapterId: job.chapterId,
          );
          if (detail.blocks.isNotEmpty) {
            for (final b in detail.blocks) {
              final effectiveImageUrl =
                  (b.imageUrl != null && b.imageUrl!.isNotEmpty)
                      ? b.imageUrl!
                      : (b.imageFile ?? '');

              final typeLower = b.blockType.toLowerCase().trim();
              final isSpecial = typeLower != 'text' &&
                  typeLower != 'heading' &&
                  typeLower != 'title' &&
                  typeLower != 'paragraph' &&
                  typeLower != 'list';

              final isSpecialBlock = isSpecial || effectiveImageUrl.isNotEmpty;
              final blockDbId = b.id ?? b.readingOrder;

              if (isSpecialBlock) {
                chunks.add(
                  ImageChunk(
                    id: blockDbId,
                    imagePath: effectiveImageUrl,
                    page: null,
                    blockType: b.blockType,
                    sourceMarkup: b.sourceMarkup,
                    annotation: b.readableText.isNotEmpty
                        ? b.readableText
                        : (b.caption ?? ''),
                  ),
                );
              } else {
                chunks.add(
                  TextChunk(
                    id: blockDbId,
                    text: b.readableText,
                    annotation: b.readableText,
                  ),
                );
              }
            }
          }
        } catch (e) {
          debugPrint('getChapterDetail error: $e');
        }

        // 3. Fallback to previewChapter if chunks is still empty
        if (chunks.isEmpty &&
            job.annotationPath.value != null &&
            job.annotationPath.value!.isNotEmpty) {
          final previewBlocks = await teacherRepository!.previewChapter(
            job.annotationPath.value!,
          );
          for (final b in previewBlocks) {
            final effectiveImageUrl =
                (b.imageUrl != null && b.imageUrl!.isNotEmpty)
                    ? b.imageUrl!
                    : (b.imageFile ?? '');

            final typeLower = b.blockType.toLowerCase().trim();
            final isSpecial = typeLower != 'text' &&
                typeLower != 'heading' &&
                typeLower != 'title' &&
                typeLower != 'paragraph' &&
                typeLower != 'list';

            final isSpecialBlock = isSpecial || effectiveImageUrl.isNotEmpty;

            if (isSpecialBlock) {
              chunks.add(
                ImageChunk(
                  id: b.readingOrder,
                  imagePath: effectiveImageUrl,
                  page: b.page,
                  blockType: b.blockType,
                  sourceMarkup: b.sourceMarkup,
                  annotation: b.readableText.isNotEmpty
                      ? b.readableText
                      : (b.caption ?? ''),
                ),
              );
            } else {
              chunks.add(
                TextChunk(
                  id: b.readingOrder,
                  text: b.readableText,
                  annotation: b.readableText,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching preview for chapter: $e');
    }

    final moduleModel = ModuleTeacherModel(
      id: job.chapterId,
      name: job.title,
      type: ModuleTeacherType.pdf,
      status: ModuleTeacherStatus.draft,
      gradeType: ClassGradeType.classTen,
      listChunks: chunks.isNotEmpty
          ? chunks
          : [
              TextChunk(
                id: 1,
                text: 'Materi ${job.title}',
                annotation:
                    'Hasil anotasi untuk ${job.title} (Halaman ${job.startPage} - ${job.endPage}) siap ditinjau.',
              ),
            ],
    );

    final args = ModuleResultArgs(
      module: moduleModel,
      canPop: true,
      chapterId: job.chapterId,
      annotationPath: job.annotationPath.value,
    );

    if (Get.currentRoute == Routes.CREATE_MODULE_LOADING) {
      Get.offNamed(Routes.MODULE_RESULT_ANNOTATION, arguments: args);
    } else {
      Get.toNamed(Routes.MODULE_RESULT_ANNOTATION, arguments: args);
    }
  }

  void markChapterAsReviewed(int? chapterId) {
    if (chapterId == null) return;
    final job = trackedJobs.firstWhereOrNull((j) => j.chapterId == chapterId);
    if (job != null) {
      job.isReviewed.value = true;
      trackedJobs.refresh();
    }
  }

  bool get hasRunningJobs =>
      trackedJobs.any((j) => !j.isDone && !j.isFailed);

  bool get allDoneChaptersReviewed =>
      trackedJobs.isNotEmpty &&
      !hasRunningJobs &&
      trackedJobs.every((j) => j.isReviewed.value);

  bool get canFinishModule => allDoneChaptersReviewed;

  final RxBool isPublishingModule = false.obs;

  Future<void> onFinishAndPublishModule() async {
    final moduleId = savedModule.value?.id;
    if (moduleId == null) {
      if (Get.isRegistered<MainLayoutController>()) {
        Get.find<MainLayoutController>().changePage(1);
      }
      if (Get.isRegistered<ModuleTeacherController>()) {
        Get.find<ModuleTeacherController>().onLoad();
      }
      Get.offNamedUntil(
        Routes.MAIN_LAYOUT,
        arguments: const MainBarArgs(role: UserRoles.guru, index: 1),
        (route) => route.settings.name == Routes.MAIN_LAYOUT,
      );
      return;
    }

    isPublishingModule.value = true;
    try {
      if (teacherRepository != null) {
        await teacherRepository!.publishModule(moduleId);
      }
      SnackbarHelper.showSuccess(
        title: "Modul Berhasil Dipublikasikan!",
        message: "Modul dan semua bab telah selesai dan siap diakses.",
      );
      if (Get.isRegistered<MainLayoutController>()) {
        Get.find<MainLayoutController>().changePage(1);
      }
      if (Get.isRegistered<ModuleTeacherController>()) {
        Get.find<ModuleTeacherController>().onLoad();
      }
      Get.offNamedUntil(
        Routes.MAIN_LAYOUT,
        arguments: const MainBarArgs(role: UserRoles.guru, index: 1),
        (route) => route.settings.name == Routes.MAIN_LAYOUT,
      );
    } catch (e) {
      debugPrint('Error publishing module: $e');
      SnackbarHelper.showError(
        title: "Gagal Publikasi Modul",
        message: e.toString(),
      );
    } finally {
      isPublishingModule.value = false;
    }
  }

  void goToPreviousStep() {
    currentStep.value = CreateModuleStep.infoModul;
  }

  void cancelLoadingProcess() {
    activeInspectedJob.value = null;
    isLoading.value = false;
  }

  void finishAndGoToAnnotation() {
    onFinishAndPublishModule();
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
      final bytes = file.bytes!;

      int pagesCount = 1;
      try {
        final PdfDocument doc = PdfDocument(inputBytes: bytes);
        pagesCount = doc.pages.count;
        doc.dispose();
      } catch (e) {
        debugPrint('Error counting pages: $e');
      }

      totalPages.value = pagesCount;
      selectedPdf.value = SelectedPdfModel(
        name: file.name,
        bytes: bytes,
        size: file.size,
      );

      startPageController.text = '1';
      endPageController.text = pagesCount.toString();

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
    fetchFases();
  }

  Future<void> fetchFases() async {
    isLoadingFase.value = true;
    try {
      if (teacherRepository != null) {
        final fases = await teacherRepository!.getFases();
        if (fases.isNotEmpty) {
          listFase.assignAll(fases);
          return;
        }
      }
      listFase.assignAll(FaseModel.defaultFases);
    } catch (e) {
      debugPrint('Failed to load fases: $e');
      listFase.assignAll(FaseModel.defaultFases);
    } finally {
      isLoadingFase.value = false;
    }
  }

  Future<void> fetchCp(int faseId) async {
    isLoadingCp.value = true;
    try {
      if (teacherRepository != null) {
        final cp = await teacherRepository!.getCpByFaseId(faseId);
        print('Cp : $cp');
        listCp.assignAll(cp);
        return;
      }
    } catch (e) {
      debugPrint('Failed to load fases: $e');
    } finally {
      isLoadingCp.value = false;
    }
  }

  @override
  void onClose() {
    for (final job in trackedJobs) {
      job.dispose();
    }
    titleModuleController.dispose();
    descriptionModuleController.dispose();
    chapterNumberController.dispose();
    chapterTitleController.dispose();
    startPageController.dispose();
    endPageController.dispose();
    super.onClose();
  }
}

enum LoadingStepStatus { pending, processing, completed }

class LoadingStep {
  final String title;
  final Rx<LoadingStepStatus> status;

  LoadingStep({required this.title, required LoadingStepStatus initialStatus})
    : status = initialStatus.obs;
}
