import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/main_bar_args.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/core/utils/dialog_helper.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

import '../../../common/common_button_widget.dart';
import '../../../core/Dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../main_layout/controllers/main_layout_controller.dart';

class ExamOptionModel {
  final String id;
  final String letter;
  final String text;

  ExamOptionModel({
    required this.id,
    required this.letter,
    required this.text,
  });
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
  final currentIndex = 0.obs;

  final questions = <ExamQuestionModel>[].obs;

  bool get isAllAnswered => questions.every((q) => q.selectedOptionId != null);

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    questions.value = [
      ExamQuestionModel(
        id: 'q_0',
        questionText: 'Nilai dari 2 pangkat 3 dikali 2 pangkat 4 adalah...',
        options: [
          ExamOptionModel(id: 'a', letter: 'A', text: '2 pangkat 7 sama dengan 128'),
          ExamOptionModel(id: 'b', letter: 'B', text: '2 pangkat 12 sama dengan 4096'),
          ExamOptionModel(id: 'c', letter: 'C', text: '4 pangkat 7 sama dengan 16384'),
          ExamOptionModel(id: 'd', letter: 'D', text: '2 pangkat 6 sama dengan 64'),
        ],
      ),
      ExamQuestionModel(
        id: 'q_1',
        questionText: 'Berapakah hasil dari operasi perhitungan 15 + 25 × 2 ?',
        options: [
          ExamOptionModel(id: 'a', letter: 'A', text: '65'),
          ExamOptionModel(id: 'b', letter: 'B', text: '80'),
          ExamOptionModel(id: 'c', letter: 'C', text: '50'),
          ExamOptionModel(id: 'd', letter: 'D', text: '40'),
        ],
      ),
      ExamQuestionModel(
        id: 'q_2',
        questionText: 'Sebuah segitiga siku-siku memiliki panjang alas 6 cm dan tinggi 8 cm. Berapakah panjang sisi miringnya?',
        options: [
          ExamOptionModel(id: 'a', letter: 'A', text: '10 cm'),
          ExamOptionModel(id: 'b', letter: 'B', text: '12 cm'),
          ExamOptionModel(id: 'c', letter: 'C', text: '14 cm'),
          ExamOptionModel(id: 'd', letter: 'D', text: '16 cm'),
        ],
      ),
      ExamQuestionModel(
        id: 'q_3',
        questionText: 'Berapakah nilai dari x jika diketahui persamaan linear 3x - 5 = 16 ?',
        options: [
          ExamOptionModel(id: 'a', letter: 'A', text: '7'),
          ExamOptionModel(id: 'b', letter: 'B', text: '6'),
          ExamOptionModel(id: 'c', letter: 'C', text: '8'),
          ExamOptionModel(id: 'd', letter: 'D', text: '5'),
        ],
      ),
      ExamQuestionModel(
        id: 'q_4',
        questionText: 'Diketahui suatu barisan aritmatika dengan suku pertama 2 dan beda 3. Berapakah nilai suku ke-10?',
        options: [
          ExamOptionModel(id: 'a', letter: 'A', text: '29'),
          ExamOptionModel(id: 'b', letter: 'B', text: '32'),
          ExamOptionModel(id: 'c', letter: 'C', text: '27'),
          ExamOptionModel(id: 'd', letter: 'D', text: '25'),
        ],
      ),
    ];
  }

  void selectOption(String questionId, String optionId) {
    final questionIndex = questions.indexWhere((q) => q.id == questionId);
    if (questionIndex != -1) {
      questions[questionIndex].selectedOptionId = optionId;
      questions.refresh();
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

  void submitExam() {
    // Nanti ganti woi kalau asli
    const String examId = "1";
    Get.back();
    DialogHelper.show(
        icon: SvgPicture.asset(
            SvgConstant.iconInformation,
          height: Dimens.iconBigSize,
          width: Dimens.iconBigSize,
        ),
        title: "Berhasil Dikirim!",
        description: "Jawaban Anda telah berhasil disimpan. Silakan pilih untuk melihat hasil evaluasi atau kembali ke menu utama.",
        actions: Row(
          children: [
            Expanded(
                child:
                CommonButtonWidget(
                    buttonName: "Kembali",
                    boxShadows: const [],
                    onPressed: (){
                      SnackbarHelper.showSuccess(title: "Pengerjaan Selesai!", message: "Silahkan review hasil pengerjaan");
                      Get.offAllNamed(
                          Routes.MAIN_LAYOUT,
                        arguments: MainBarArgs(
                            role: UserRoles.siswa,
                            index: MainBarStudent.exam.index
                        )
                      );
                    }
                )),
            const SizedBox(width: Dimens.innerPadding,),
            Expanded(
                child:
                CommonButtonWidget(
                    buttonName: "Review",
                    boxShadows: const [],
                    onPressed: (){
                      SnackbarHelper.showSuccess(title: "Pengerjaan Selesai!", message: "Silahkan review hasil pengerjaan");
                      Get.offNamedUntil(
                        Routes.EXAM_REVIEW,
                            arguments: examId,
                            (route) => route.settings.name == Routes.MAIN_LAYOUT,
                      );
                    }
                )),
          ],
        )
    );
  }
}
