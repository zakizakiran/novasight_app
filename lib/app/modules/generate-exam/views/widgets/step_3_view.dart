import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../controllers/generate_exam_controller.dart';
import '../../models/generated_question.dart';

class Step3View extends GetView<GenerateExamController> {
  const Step3View({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // If AI is generating or there are no questions yet
      if (controller.isGenerating.value ||
          controller.generatedQuestions.isEmpty) {
        return _buildLoadingUI(context);
      }
      return _buildReviewUI(context);
    });
  }

  Widget _buildLoadingUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.innerPadding),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // AI Sparkle Circle
          Obx(() => PulseCircle(isGenerating: controller.isGenerating.value)),
          const SizedBox(height: 32),

          Obx(() {
            bool isDone = !controller.isGenerating.value;
            int total = controller.numberOfQuestions.value;
            int current = controller.generatedCount.value;

            return Column(
              children: [
                Text(
                  isDone ? 'Soal Berhasil Dibuat!' : 'AI Sedang Membuat Soal',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  isDone
                      ? '$total soal telah selesai dibuat.'
                      : 'Membuat $total soal pilihan ganda dari ${controller.selectedModuleName.value}...',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstant.textGreyColor,
                  ),
                ),
                const SizedBox(height: 24),

                if (!isDone) ...[
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: current / total),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    builder: (context, value, _) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: ColorConstant.grey.withValues(
                          alpha: 0.2,
                        ),
                        color: ColorConstant.primary,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$current / $total soal dibuat',
                    style: const TextStyle(
                      color: ColorConstant.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            );
          }),

          const SizedBox(height: 24),
          Expanded(
            child: Obx(() {
              int total = controller.numberOfQuestions.value;
              int current = controller.generatedCount.value;
              bool isDone = !controller.isGenerating.value && current == total;

              int groupIndex = ((current == 0 ? 0 : current - 1) ~/ 3);
              int startIndex = groupIndex * 3 + 1;

              int itemCount = 3;
              if (startIndex + 2 > total) {
                itemCount = total - startIndex + 1;
              }

              return ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  int itemNumber = startIndex + index;
                  bool isCompleted = isDone || itemNumber <= current;
                  bool isActive = !isDone && itemNumber == current + 1;

                  return AnimatedSkeletonRow(
                    itemNumber: itemNumber,
                    isActive: isActive,
                    isCompleted: isCompleted,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewUI(BuildContext context) {
    return Column(
      children: [
        // Header Info
        Padding(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorConstant.white,
              borderRadius: BorderRadius.circular(Dimens.radius),
              border: Border.all(
                color: ColorConstant.grey.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorConstant.shadowColor.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.titleController.text.isNotEmpty
                      ? controller.titleController.text
                      : 'UH 1 — Himpunan dan Operasinya',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.numberOfQuestions.value} soal · Pilihan Ganda (${controller.answerOptions.value}) · ${controller.difficulty.value}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorConstant.textGreyColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        // List of Questions
        Expanded(
          child: Obx(() {
            return ListView.builder(
              padding: const EdgeInsets.only(
                left: Dimens.innerPadding,
                right: Dimens.innerPadding,
                bottom: 100, // padding for bottom buttons
              ),
              itemCount: controller.generatedQuestions.length,
              itemBuilder: (context, index) {
                return _buildQuestionCard(context, index);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(BuildContext context, int index) {
    var question = controller.generatedQuestions[index];
    bool isExpanded = question.isExpanded;
    bool isEditing = question.isEditing;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorConstant.white,
        borderRadius: BorderRadius.circular(Dimens.radius),
        border: Border.all(
          color: isEditing
              ? ColorConstant.primary
              : ColorConstant.grey.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.shadowColor.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          InkWell(
            onTap: () => controller.toggleExpand(index),
            borderRadius: BorderRadius.circular(Dimens.radius),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: ColorConstant.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: ColorConstant.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Soal ${index + 1} dari ${controller.numberOfQuestions.value}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textDarkGreyColor,
                      ),
                    ),
                  ),
                  if (!isEditing && isExpanded)
                    GestureDetector(
                      onTap: () => controller.toggleEdit(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.yellowColor.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: ColorConstant.yellowColor),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit,
                              size: 14,
                              color: ColorConstant.yellowColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Edit',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: ColorConstant.yellowColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: ColorConstant.textGreyColor,
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: isEditing
                  ? _buildEditMode(context, index)
                  : _buildViewMode(context, index),
            ),
        ],
      ),
    );
  }

  Widget _buildViewMode(BuildContext context, int index) {
    var question = controller.generatedQuestions[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 12),
        Text(
          'Pertanyaan',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ColorConstant.textDarkGreyColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorConstant.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: ColorConstant.grey.withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            question.question,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        const SizedBox(height: 16),
        Text(
          'Pilihan Jawaban',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ColorConstant.textDarkGreyColor,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(question.options.length, (optIdx) {
          bool isCorrect = optIdx == question.correctOptionIndex;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCorrect
                  ? ColorConstant.green.withValues(alpha: 0.1)
                  : ColorConstant.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCorrect
                    ? ColorConstant.green
                    : ColorConstant.grey.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? ColorConstant.green
                        : ColorConstant.grey.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCode(65 + optIdx),
                    style: TextStyle(
                      color: isCorrect
                          ? ColorConstant.white
                          : ColorConstant.textDarkGreyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.options[optIdx],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isCorrect
                          ? ColorConstant.green
                          : ColorConstant.textDarkGreyColor,
                      fontWeight: isCorrect
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),
        Text(
          'Justifikasi & Langkah Penyelesaian',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ColorConstant.textDarkGreyColor,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(question.justificationSteps.length, (stepIdx) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: ColorConstant.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${stepIdx + 1}',
                    style: const TextStyle(
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.justificationSteps[stepIdx],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEditMode(BuildContext context, int index) {
    var question = controller.generatedQuestions[index];

    return QuestionEditForm(
      question: question,
      onCancel: () => controller.toggleEdit(index),
      onSave: (updatedQuestion) =>
          controller.saveChanges(index, updatedQuestion),
    );
  }
}

class PulseCircle extends StatefulWidget {
  final bool isGenerating;
  const PulseCircle({required this.isGenerating, super.key});

  @override
  PulseCircleState createState() => PulseCircleState();
}

class PulseCircleState extends State<PulseCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isGenerating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isGenerating && !oldWidget.isGenerating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isGenerating && oldWidget.isGenerating) {
      _controller.stop();
      _controller.animateTo(1.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: ColorConstant.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorConstant.primary.withValues(
                    alpha: 0.4 * _animation.value,
                  ),
                  blurRadius: 20 * _animation.value,
                  spreadRadius: 10 * _animation.value,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 48),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedSkeletonRow extends StatefulWidget {
  final bool isActive;
  final bool isCompleted;
  final int itemNumber;

  const AnimatedSkeletonRow({
    required this.itemNumber,
    required this.isActive,
    required this.isCompleted,
    super.key,
  });

  @override
  AnimatedSkeletonRowState createState() => AnimatedSkeletonRowState();
}

class AnimatedSkeletonRowState extends State<AnimatedSkeletonRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedSkeletonRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _controller.animateTo(1.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: BorderRadius.circular(Dimens.radius),
            boxShadow: [
              BoxShadow(
                color: ColorConstant.shadowColor.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.isCompleted
                      ? ColorConstant.green.withValues(alpha: 0.1)
                      : ColorConstant.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${widget.itemNumber}',
                  style: TextStyle(
                    color: widget.isCompleted
                        ? ColorConstant.green
                        : ColorConstant.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Opacity(
                  opacity: widget.isActive
                      ? _fadeAnimation.value
                      : (widget.isCompleted ? 1.0 : 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: ColorConstant.grey.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: ColorConstant.grey.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              if (widget.isCompleted)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ColorConstant.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: ColorConstant.green,
                    size: 16,
                  ),
                )
              else if (widget.isActive)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorConstant.primary.withValues(alpha: 0.5),
                  ),
                )
              else
                const SizedBox(width: 24), // Placeholder for alignment
            ],
          ),
        );
      },
    );
  }
}

class QuestionEditForm extends StatefulWidget {
  final GeneratedQuestion question;
  final VoidCallback onCancel;
  final Function(GeneratedQuestion) onSave;

  const QuestionEditForm({
    required this.question,
    required this.onCancel,
    required this.onSave,
    super.key,
  });

  @override
  QuestionEditFormState createState() => QuestionEditFormState();
}

class QuestionEditFormState extends State<QuestionEditForm> {
  late TextEditingController _questionController;
  late TextEditingController _conclusionController;
  late List<TextEditingController> _optionControllers;
  late List<TextEditingController> _stepControllers;
  late int _correctOptionIndex;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.question);
    _conclusionController = TextEditingController(
      text: widget.question.conclusion,
    );
    _optionControllers = widget.question.options
        .map((e) => TextEditingController(text: e))
        .toList();
    _stepControllers = widget.question.justificationSteps
        .map((e) => TextEditingController(text: e))
        .toList();
    _correctOptionIndex = widget.question.correctOptionIndex;
  }

  @override
  void dispose() {
    _questionController.dispose();
    _conclusionController.dispose();
    for (var c in _optionControllers) {
      c.dispose();
    }
    for (var c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    setState(() {
      _optionControllers[index].dispose();
      _optionControllers.removeAt(index);
      if (_correctOptionIndex == index) {
        _correctOptionIndex = 0;
      } else if (_correctOptionIndex > index) {
        _correctOptionIndex--;
      }
    });
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }

  void _save() {
    final updated = GeneratedQuestion(
      question: _questionController.text,
      options: _optionControllers.map((c) => c.text).toList(),
      correctOptionIndex: _correctOptionIndex,
      justificationSteps: _stepControllers.map((c) => c.text).toList(),
      conclusion: _conclusionController.text,
      isExpanded: true,
      isEditing: false,
    );
    widget.onSave(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 12),
        Text(
          'Pertanyaan',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ColorConstant.textDarkGreyColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _questionController,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: ColorConstant.primary.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ColorConstant.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),

        const SizedBox(height: 16),
        Text(
          'Pilihan Jawaban',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ColorConstant.textDarkGreyColor,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(_optionControllers.length, (index) {
          bool isCorrect = _correctOptionIndex == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ignore: deprecated_member_use
                Radio<int>(
                  value: index,
                  groupValue: _correctOptionIndex,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _correctOptionIndex = val);
                    }
                  },
                  activeColor: ColorConstant.primary,
                ),
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: ColorConstant.grey.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: const TextStyle(
                      color: ColorConstant.textDarkGreyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isCorrect
                              ? ColorConstant.green
                              : ColorConstant.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: isCorrect
                              ? ColorConstant.green
                              : ColorConstant.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                if (_optionControllers.length > 2)
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: ColorConstant.redColor,
                      size: 20,
                    ),
                    onPressed: () => _removeOption(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          );
        }),

        OutlinedButton.icon(
          onPressed: _addOption,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Tambah Pilihan'),
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorConstant.primary,
            side: BorderSide(
              color: ColorConstant.primary.withValues(alpha: 0.5),
            ),
            minimumSize: const Size.fromHeight(40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: ColorConstant.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ColorConstant.green),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kunci Jawaban: ${String.fromCharCode(65 + _correctOptionIndex)}',
                style: const TextStyle(
                  color: ColorConstant.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(Klik radio untuk ubah kunci)',
                style: TextStyle(
                  color: ColorConstant.green.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Text(
          'Justifikasi & Langkah Penyelesaian',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ColorConstant.textDarkGreyColor,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(_stepControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 12, right: 12),
                  decoration: const BoxDecoration(
                    color: ColorConstant.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _stepControllers[index],
                    maxLines: null,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: ColorConstant.primary.withValues(alpha: 0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: ColorConstant.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
                if (_stepControllers.length > 1)
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: ColorConstant.redColor,
                      size: 20,
                    ),
                    onPressed: () => _removeStep(index),
                  ),
              ],
            ),
          );
        }),

        OutlinedButton.icon(
          onPressed: _addStep,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Tambah Langkah'),
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorConstant.primary,
            side: BorderSide(
              color: ColorConstant.primary.withValues(alpha: 0.5),
            ),
            minimumSize: const Size.fromHeight(40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        const SizedBox(height: 16),
        Text(
          'Kesimpulan',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ColorConstant.textDarkGreyColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _conclusionController,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: ColorConstant.primary.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ColorConstant.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),

        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorConstant.textDarkGreyColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Batal'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.primary,
                  foregroundColor: ColorConstant.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
