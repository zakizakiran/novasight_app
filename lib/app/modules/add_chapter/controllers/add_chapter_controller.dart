import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/args/add_chapter_args.dart';
import 'package:lydera_app/app/data/models/job_response.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../core/utils/snackbar_helper.dart';
import '../../../data/model/selected_pdf_model.dart';
import '../../../data/models/chapter_create_response_model.dart';
import '../../../data/models/cp_model.dart';
import '../../../data/models/fase_model.dart';
import '../../../data/models/teacher_model.dart';
import '../../../data/repositories/teacher_repository.dart';
import '../../../routes/app_pages.dart';

class AddChapterController extends GetxController {
  final TeacherRepository? teacherRepository;
  final Rxn<SelectedPdfModel> selectedPdf = Rxn<SelectedPdfModel>();
  final TextEditingController chapterNumberController = TextEditingController();
  final TextEditingController startPageController = TextEditingController(
    text: '1',
  );
  final TextEditingController endPageController = TextEditingController();
  final TextEditingController chapterTitleController = TextEditingController();
  final RxBool isValid = false.obs;
  final RxInt totalPages = 0.obs;

  final RxBool isCreatingChapter = false.obs;
  final RxInt moduleId = 0.obs  ;

  final RxList<CpModel> listCp = <CpModel>[].obs;
  final Rxn<CpModel> selectedCp = Rxn<CpModel>();

  final RxList<FaseModel> listFase = <FaseModel>[].obs;
  final Rxn<FaseModel> selectedFase = Rxn<FaseModel>();

  final RxBool isLoadingCp = false.obs;
  final RxBool isLoadingFase = false.obs;
  final RxBool isSavingModule = false.obs;

  AddChapterController({
    TeacherRepository? teacherRepository
  }) : teacherRepository =
      teacherRepository ??
          (Get.isRegistered<TeacherRepository>()
              ? Get.find<TeacherRepository>()
              : null);

  @override
  void onInit() {
    super.onInit();
    fetchFases();
    final args = Get.arguments;
    if(args is AddChapterArgs){
      final module = args.module;
      final chapterNum = module.chapters.length + 1;
      moduleId.value = args.module.id;
      chapterTitleController.text = "BAB $chapterNum : ${module.title}";
      chapterNumberController.text = "$chapterNum";
    }
  }

  @override
  void onClose() {
    startPageController.dispose();
    endPageController.dispose();
    chapterNumberController.dispose();
    chapterTitleController.dispose();
    super.onClose();
  }

  void onSelectCp(CpModel cp) {
    selectedCp.value = cp;
    onChange(cp.domain);
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

  void onSelectFase(FaseModel fase) {
    selectedFase.value = fase;
    fetchCp(fase.id);
    onChange(fase.displayName);
  }

  void onChange(String _) {
    final bool isValidPdf = selectedPdf.value != null;
    final bool isValidTitle = chapterTitleController.text.isNotEmpty;
    final bool isValidChapterNumber = chapterNumberController.text.isNotEmpty;
    isValid.value = isValidPdf && isValidChapterNumber && isValidTitle;
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
        debugPrint('Cp : $cp');
        selectedCp.value = cp.first;
        listCp.assignAll(cp);
        return;
      }
    } catch (e) {
      debugPrint('Failed to load cp: $e');
    } finally {
      isLoadingCp.value = false;
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

  Future<void> onCreateChapter() async {
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

    final int chapterNum = int.tryParse(chapterNumberController.text.trim()) ?? -1;
    if (chapterNum == -1) {
      SnackbarHelper.showError(
        title: "Nomor BAB Kosong",
        message: "Silakan masukkan nomor BAB.",
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
      final int cpId = selectedCp.value?.id ?? 1;

      ChapterCreateResponseModel? response;
      if (teacherRepository != null) {
        response = await teacherRepository!.createChapter(
          fileBytes: slicedBytes,
          fileName: fileName,
          moduleId: moduleId.value,
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

      final args = Get.arguments;
      if(args is AddChapterArgs){
        args.onChapterAdded(TeacherChapterSummaryModel(
          id: response.chapterId,
          moduleId: moduleId.value,
          number: chapterNum,
          title: chapterTitle,
          cpId: cpId,
          job: JobResponse(
              id: response.jobId,
              chapterId: response.chapterId,
              pdfPath: ''.obs,
              status: Rx(JobStatus.queued)
          ),
          createdAt: DateTime.now()
        ));
      }

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
      Get.offNamed(Routes.ADD_LOADING_CHAPTER, arguments: response.jobId);
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
}
