import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:drift/drift.dart' as drift;
import 'package:lydera_app/app/core/args/subject_args.dart';
import 'package:lydera_app/app/core/network/database.dart';
import 'package:lydera_app/app/core/utils/table_mode.dart';
import 'package:lydera_app/app/data/model/subject_model.dart';
import 'package:lydera_app/app/data/repositories/module_repository.dart';
import 'package:lydera_app/app/data/repositories/record_note_repository.dart';
import 'package:lydera_app/app/data/repositories/student_repository.dart';
import 'package:lydera_app/app/modules/module/controllers/module_controller.dart';
import 'package:lydera_app/app/modules/module_detail/controllers/module_detail_controller.dart';
import 'package:lydera_app/app/modules/student-dashboard/controllers/student_dashboard_controller.dart';
import '../../../core/errors/api_exception.dart';
import '../../../core/utils/snackbar_helper.dart';

enum WordTyping {
  bold(Icons.format_bold),
  italic(Icons.format_italic),
  underline(Icons.format_underline),
  strikethrough(Icons.strikethrough_s);

  final IconData icon;
  const WordTyping(this.icon);
}

enum AlignParagraft {
  left(Icons.format_align_left),
  center(Icons.format_align_center),
  right(Icons.format_align_right);

  final IconData icon;
  const AlignParagraft(this.icon);
}

enum NoteMode {
  reader,
  editor,
}

class SubjectController extends GetxController {
  final ModuleRepository? moduleRepository;
  final StudentRepository? studentRepository;
  final RecordNoteRepository? recordNoteRepository;

  late final SubjectModel subject;
  late final int index;
  final Rx<int> currentPageNumber = 1.obs;
  final Rx<TableMode> selectedMode = TableMode.cell.obs;
  final formKey = GlobalKey<FormState>();
  final RxBool isValidNote = false.obs;
  final RxBool isTyping = false.obs;

  final Rx<NoteMode> noteMode = NoteMode.reader.obs;

  final Rx<AlignParagraft> selectedAlignment = AlignParagraft.left.obs;
  final RxBool isBold = false.obs;
  final RxBool isItalic = false.obs;
  final RxBool isUnderline = false.obs;
  final RxBool isStrikethrough = false.obs;

  final RxBool isNoteLoaded = false.obs;
  final RxString prevContent = ''.obs;
  final RxBool isSameContent = false.obs;

  RecordNoteData? existingNote;

  final TextEditingController searchController = TextEditingController();
  late QuillController noteController;

  bool get isReader => noteMode.value == NoteMode.reader;

  SubjectController({
    ModuleRepository? moduleRepository,
    ModuleRepository? repository,
    StudentRepository? studentRepository,
    RecordNoteRepository? recordNoteRepository,
  })  : moduleRepository = moduleRepository ??
      repository ??
      (Get.isRegistered<ModuleRepository>()
          ? Get.find<ModuleRepository>()
          : null),
        recordNoteRepository = recordNoteRepository ??
            (Get.isRegistered<RecordNoteRepository>()
                ? Get.find<RecordNoteRepository>()
                : null),
        studentRepository = studentRepository ??
            (Get.isRegistered<StudentRepository>()
                ? Get.find<StudentRepository>()
                : null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as SubjectArgs;
    subject = args.subject;
    index = args.index;
    noteController = QuillController.basic();
    noteController.readOnly = true;
    noteController.addListener(_onNoteChanged);
    _initializeNote();
  }

  @override
  void onClose() {
    noteController.removeListener(_onNoteChanged);
    noteController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void onNext() {
    currentPageNumber.value += 1;
  }

  void changeNoteMode(NoteMode mode) {
    noteMode.value = mode;
    final reader = mode == NoteMode.reader;
    noteController.readOnly = reader;

    if (reader) {
      FocusManager.instance.primaryFocus?.unfocus();
      noteController.updateSelection(
        const TextSelection.collapsed(offset: 0),
        ChangeSource.local,
      );
    }

    SemanticsService.announce(
      reader ? 'Mode baca' : 'Mode edit',
      TextDirection.ltr,
    );
  }

  void onChangeTextMode(WordTyping typing) {
    if (isReader) return;

    final attribute = switch (typing) {
      WordTyping.bold => Attribute.bold,
      WordTyping.italic => Attribute.italic,
      WordTyping.underline => Attribute.underline,
      WordTyping.strikethrough => Attribute.strikeThrough,
    };

    final isActive =
    noteController.getSelectionStyle().containsKey(attribute.key);

    noteController.formatSelection(
      isActive
          ? Attribute(attribute.key, AttributeScope.inline, null)
          : attribute,
    );

    _updateToolbar();
  }

  void onChangeAlignment(AlignParagraft alignment, {bool wholeDocument = false}) {
    if (isReader) return;

    final attribute = switch (alignment) {
      AlignParagraft.left => Attribute.leftAlignment,
      AlignParagraft.center => Attribute.centerAlignment,
      AlignParagraft.right => Attribute.rightAlignment,
    };

    final previousSelection = noteController.selection;
    selectedAlignment.value = alignment;

    if (wholeDocument) {
      noteController.updateSelection(
        TextSelection(
          baseOffset: 0,
          extentOffset: noteController.document.length - 1,
        ),
        ChangeSource.local,
      );
    }

    noteController.formatSelection(attribute);

    if (wholeDocument) {
      noteController.updateSelection(
        previousSelection,
        ChangeSource.local,
      );
    }
  }

  Future<void> _initializeNote() async {
    try {
      existingNote = await recordNoteRepository?.getNoteByChapterId(chapterId: subject.id);
      Document document;

      if (existingNote != null) {
        final deltaJson = jsonDecode(existingNote!.content);

        document = Document.fromJson(
          List.castFrom(deltaJson),
        );
        prevContent.value = existingNote!.content;
      } else {
        document = Document();
        prevContent.value = jsonEncode(document.toDelta().toJson());
      }

      noteController.document = document;

      noteController.updateSelection(
        const TextSelection.collapsed(offset: 0),
        ChangeSource.local,
      );
    } catch (e) {
      debugPrint('Failed to initialize note: $e');
    } finally {
      isNoteLoaded.value = true;
      checkContentChanged();
    }
  }

  void checkContentChanged() {
    final currentContent = jsonEncode(
      noteController.document.toDelta().toJson(),
    );
    isSameContent.value = currentContent == prevContent.value;
  }

  void _onNoteChanged() {
    _updateToolbar();
    checkContentChanged();
  }

  Future<void> onSaveNote(String title) async {
    if (!isNoteLoaded.value) return;

    try {
      final delta = noteController.document.toDelta();

      final content = jsonEncode(delta.toJson());

      final now = DateTime.now();
      SnackbarHelper.showSuccess(title: 'Berhasil', message: 'Menyimpan catatan');
      prevContent.value = content;
      isSameContent.value = true;
      await recordNoteRepository?.submitNote(
        recordNote: RecordNoteCompanion(
          title: drift.Value<String>(existingNote?.title ?? title),
          content: drift.Value<String>(content),
          chapter: drift.Value<int>(subject.id),
          updatedAt: drift.Value<DateTime?>(now),
        ),
      );
    } on ApiException catch (e) {
      SnackbarHelper.showError(
        title: 'Error Failed to Save Note',
        message: e.message,
      );
    } catch (e, stackTrace) {
      debugPrint('Error General: $e');
      debugPrintStack(stackTrace: stackTrace);

      SnackbarHelper.showError(
        title: 'Error Failed to Save Note',
        message: e.toString(),
      );
    }
  }

  void _updateToolbar() {
    final style = noteController.getSelectionStyle();

    isBold.value = style.containsKey(Attribute.bold.key);
    isItalic.value = style.containsKey(Attribute.italic.key);
    isUnderline.value = style.containsKey(Attribute.underline.key);
    isStrikethrough.value = style.containsKey(Attribute.strikeThrough.key);
    final alignment = style.attributes[Attribute.align.key]?.value;
    switch (alignment) {
      case 'center':
        selectedAlignment.value = AlignParagraft.center;
        break;
      case 'right':
        selectedAlignment.value = AlignParagraft.right;
        break;
      default:
        selectedAlignment.value = AlignParagraft.left;
    }
  }

  void onPage(int page) {
    if (page < 1) {
      return;
    }
    if (page > subject.pages.length) {
      return;
    }
    currentPageNumber.value = page;
    SemanticsService.announce("Pergi ke halaman $page", TextDirection.ltr);
  }

  void onPrevious() {
    currentPageNumber.value -= 1;
  }

  void onSentenceTapped(sentence) {
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
    if (studentRepository != null) {
      try {
        await studentRepository!.markChapterComplete(chapterId: subject.id);
      } catch (_) {
      }
    }
    if (Get.isRegistered<ModuleController>()) {
      Get.find<ModuleController>().onLoad();
    }
    if (Get.isRegistered<StudentDashboardController>()) {
      Get.find<StudentDashboardController>().onRefresh();
    }
  }

}