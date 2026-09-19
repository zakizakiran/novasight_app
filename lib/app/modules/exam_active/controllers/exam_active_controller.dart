import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/main_bar_args.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/core/utils/dialog_helper.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/data/models/student_quiz_model.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

import '../../../common/common_button_widget.dart';
import '../../../core/Dimens.dart';
import '../../main_layout/controllers/main_layout_controller.dart';

class ExamOptionModel {
  final String id;
  final String letter;
  final String text;

  ExamOptionModel({required this.id, required this.letter, required this.text});
}

class ExamQuestionModel {
  final String id;
  final String questionText;
  final List<ExamOptionModel> options;
  String? selectedOptionId;

  ExamQuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    this.selectedOptionId,
  });
}

class ExamActiveController extends GetxController {
  final StudentRepository? studentRepository;

  ExamActiveController({
    StudentRepository? studentRepository,
  }) : studentRepository = studentRepository ??
            (Get.isRegistered<StudentRepository>()
                ? Get.find<StudentRepository>()
                : null);

  final RxInt quizId = 1.obs;
  final RxInt durationMinutes = 45.obs;
  final RxString examTitle = 'Soal Ujian'.obs;
  final RxString examDescription = 'UTS Kelas X'.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString timerText = '45:00'.obs;
  final RxBool isSubmitting = false.obs;

  final currentIndex = 0.obs;
  final questions = <ExamQuestionModel>[].obs;

  StreamSubscription<StudentQuizEvent>? _quizStreamSub;
  Timer? _countdownTimer;
  int _remainingSeconds = 45 * 60;

  bool get isAllAnswered => questions.every((q) => q.selectedOptionId != null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      if (args['quizId'] != null) {
        quizId.value = int.tryParse(args['quizId'].toString()) ?? 1;
      }
      if (args['durationMinutes'] != null) {
        final d = int.tryParse(args['durationMinutes'].toString()) ?? 45;
        if (d > 0) durationMinutes.value = d;
      }
      if (args['title'] != null) {
        examTitle.value = args['title'].toString();
      }
      if (args['moduleTitle'] != null) {
        examDescription.value = args['moduleTitle'].toString();
      }
    } else if (args is QuizRequestStudentResponse) {
      quizId.value = args.id;
      if (args.maxDurationMinutes > 0) {
        durationMinutes.value = args.maxDurationMinutes;
      }
      examTitle.value = args.title;
      examDescription.value = args.module.title;
    } else if (args is int) {
      quizId.value = args;
    } else if (args != null) {
      quizId.value = int.tryParse(args.toString()) ?? 1;
    }

    _remainingSeconds = durationMinutes.value * 60;
    _updateTimerDisplay(_remainingSeconds);
    _startLocalCountdown();
    startQuiz();
  }

  void _updateTimerDisplay(int seconds) {
    if (seconds < 0) seconds = 0;
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    timerText.value = '$m:$s';
  }

  void _startLocalCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _updateTimerDisplay(_remainingSeconds);
      } else {
        timer.cancel();
        SnackbarHelper.showError(
          title: 'Waktu Habis!',
          message: 'Waktu pengerjaan telah habis',
        );
        submitExam(isAutoTimeout: true);
      }
    });
  }

  Future<void> startQuiz() async {
    if (studentRepository == null) {
      _loadDummyData();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      _quizStreamSub?.cancel();
      _quizStreamSub = studentRepository!
          .startQuizStream(quizId: quizId.value)
          .listen(
        (event) {
          if (event is StudentQuizInitEvent) {
            isLoading.value = false;
            if (event.targetEndTime != null) {
              final diff =
                  event.targetEndTime!.difference(DateTime.now()).inSeconds;
              if (diff > 0) {
                _remainingSeconds = diff;
                _updateTimerDisplay(_remainingSeconds);
              }
            }
            if (event.questions.isNotEmpty) {
              questions.value = event.questions.map((q) {
                return ExamQuestionModel(
                  id: q.id.toString(),
                  questionText: q.questionText,
                  options: q.options.map((opt) {
                    return ExamOptionModel(
                      id: opt.label,
                      letter: opt.label,
                      text: opt.opsiText,
                    );
                  }).toList(),
                );
              }).toList();
            }
          } else if (event is StudentQuizTickEvent) {
            timerText.value = event.time;
            final parts = event.time.split(':');
            if (parts.length == 2) {
              final m = int.tryParse(parts[0]) ?? 0;
              final s = int.tryParse(parts[1]) ?? 0;
              _remainingSeconds = (m * 60) + s;
            }
          } else if (event is StudentQuizTimeoutEvent) {
            SnackbarHelper.showError(
              title: 'Waktu Habis!',
              message: event.message,
            );
            submitExam(isAutoTimeout: true);
          } else if (event is StudentQuizErrorEvent) {
            errorMessage.value = event.error;
          }
        },
        onError: (err) {
          isLoading.value = false;
          errorMessage.value = err.toString();
          if (questions.isEmpty) {
            _loadDummyData();
          }
        },
      );
    } on ApiException catch (e) {
      isLoading.value = false;
      errorMessage.value = e.message;
      if (questions.isEmpty) {
        _loadDummyData();
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      if (questions.isEmpty) {
        _loadDummyData();
      }
    }
  }

  void _loadDummyData() {
    questions.value = [
      ExamQuestionModel(
        id: 'q_0',
        questionText: 'Nilai dari 2 pangkat 3 dikali 2 pangkat 4 adalah...',
        options: [
          ExamOptionModel(
            id: 'A',
            letter: 'A',
            text: '2 pangkat 7 sama dengan 128',
          ),
          ExamOptionModel(
            id: 'B',
            letter: 'B',
            text: '2 pangkat 12 sama dengan 4096',
          ),
          ExamOptionModel(
            id: 'C',
            letter: 'C',
            text: '4 pangkat 7 sama dengan 16384',
          ),
          ExamOptionModel(
            id: 'D',
            letter: 'D',
            text: '2 pangkat 6 sama dengan 64',
          ),
        ],
      ),
      ExamQuestionModel(
        id: 'q_1',
        questionText: 'Berapakah hasil dari operasi perhitungan 15 + 25 × 2 ?',
        options: [
          ExamOptionModel(id: 'A', letter: 'A', text: '65'),
          ExamOptionModel(id: 'B', letter: 'B', text: '80'),
          ExamOptionModel(id: 'C', letter: 'C', text: '50'),
          ExamOptionModel(id: 'D', letter: 'D', text: '40'),
        ],
      ),
      ExamQuestionModel(
        id: 'q_2',
        questionText:
            'Sebuah segitiga siku-siku memiliki panjang alas 6 cm dan tinggi 8 cm. Berapakah panjang sisi miringnya?',
        options: [
          ExamOptionModel(id: 'A', letter: 'A', text: '10 cm'),
          ExamOptionModel(id: 'B', letter: 'B', text: '12 cm'),
          ExamOptionModel(id: 'C', letter: 'C', text: '14 cm'),
          ExamOptionModel(id: 'D', letter: 'D', text: '16 cm'),
        ],
      ),
      ExamQuestionModel(
        id: 'q_3',
        questionText:
            'Berapakah nilai dari x jika diketahui persamaan linear 3x - 5 = 16 ?',
        options: [
          ExamOptionModel(id: 'A', letter: 'A', text: '7'),
          ExamOptionModel(id: 'B', letter: 'B', text: '6'),
          ExamOptionModel(id: 'C', letter: 'C', text: '8'),
          ExamOptionModel(id: 'D', letter: 'D', text: '5'),
        ],
      ),
      ExamQuestionModel(
        id: 'q_4',
        questionText:
            'Diketahui suatu barisan aritmatika dengan suku pertama 2 dan beda 3. Berapakah nilai suku ke-10?',
        options: [
          ExamOptionModel(id: 'A', letter: 'A', text: '29'),
          ExamOptionModel(id: 'B', letter: 'B', text: '32'),
          ExamOptionModel(id: 'C', letter: 'C', text: '27'),
          ExamOptionModel(id: 'D', letter: 'D', text: '25'),
        ],
      ),
    ];
  }

  Future<void> selectOption(String questionId, String optionId) async {
    final questionIndex = questions.indexWhere((q) => q.id == questionId);
    if (questionIndex != -1) {
      questions[questionIndex].selectedOptionId = optionId;
      questions.refresh();

      // Submit answer to backend via POST /api/students/soal/{soal_id}/submit
      final soalId = int.tryParse(questionId);
      if (soalId != null && studentRepository != null) {
        try {
          await studentRepository!.submitSoalAnswer(
            soalId: soalId,
            request: SoalSubmitRequest(selectedOption: optionId),
          );
        } catch (_) {
          // Gracefully continue
        }
      }
    }
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      currentIndex.value = index;
    }
  }

  Future<void> submitExam({bool isAutoTimeout = false}) async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;

    try {
      _quizStreamSub?.cancel();

      if (studentRepository != null) {
        try {
          await studentRepository!.finishQuiz(quizId: quizId.value);
        } catch (_) {}
      }

      if (!isAutoTimeout) {
        Get.back();
      }

      DialogHelper.show(
        icon: SvgPicture.asset(
          SvgConstant.iconInformation,
          height: Dimens.iconBigSize,
          width: Dimens.iconBigSize,
        ),
        title: isAutoTimeout ? "Waktu Habis!" : "Berhasil Dikirim!",
        description: isAutoTimeout
            ? "Waktu pengerjaan ujian telah habis. Jawaban Anda telah otomatis dikirimkan."
            : "Jawaban Anda telah berhasil disimpan. Silakan pilih untuk melihat hasil evaluasi atau kembali ke menu utama.",
        actions: Row(
          children: [
            Expanded(
              child: CommonButtonWidget(
                buttonName: "Kembali",
                boxShadows: const [],
                onPressed: () {
                  SnackbarHelper.showSuccess(
                    title: "Pengerjaan Selesai!",
                    message: "Silahkan review hasil pengerjaan",
                  );
                  Get.offAllNamed(
                    Routes.MAIN_LAYOUT,
                    arguments: MainBarArgs(
                      role: UserRoles.siswa,
                      index: MainBarStudent.exam.index,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: Dimens.innerPadding),
            Expanded(
              child: CommonButtonWidget(
                buttonName: "Evaluaizer",
                boxShadows: const [],
                onPressed: () {
                  SnackbarHelper.showSuccess(
                    title: "Pengerjaan Selesai!",
                    message: "Buka Evaluaizer untuk analisis hasil pengerjaan",
                  );
                  Get.offNamedUntil(
                    Routes.EXAM_REVIEW,
                    arguments: quizId.value,
                    (route) => route.settings.name == Routes.MAIN_LAYOUT,
                  );
                },
              ),
            ),
          ],
        ),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _quizStreamSub?.cancel();
    super.onClose();
  }
}
