import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/common_card_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../../data/models/classroom_model.dart';

class ChangeClassWidget extends StatelessWidget {
  const ChangeClassWidget({
    super.key,
    required this.classrooms,
    required this.selectedClassroom,
    required this.onSelectedClassroom,
    required this.onDeleteClassroom,
  });

  final RxList<ClassroomResponseModel> classrooms;
  final Rxn<ClassroomResponseModel> selectedClassroom;
  final Function(ClassroomResponseModel) onSelectedClassroom;
  final Function(ClassroomResponseModel) onDeleteClassroom;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (classrooms.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          child: Center(
            child: Text(
              "Belum ada kelas tersedia",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConstant.textGreyColor,
              ),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimens.innerPadding),
        itemCount: classrooms.length,
        separatorBuilder: (context, index) =>
        const SizedBox(height: Dimens.spaceSmallPadding),
        itemBuilder: (context, index) {
          final classroom = classrooms[index];

          return Obx(() {
            final isSelected = selectedClassroom.value?.id == classroom.id;

            return _buildChangeClass(onSelectedClassroom, onDeleteClassroom, classroom, isSelected, context);
          });
        },
      );
    });
  }

  Widget _buildChangeClass(
      Function(ClassroomResponseModel) onSelectedClassroom,
      Function(ClassroomResponseModel) onDeleteClassroom,
      ClassroomResponseModel classroom,
      bool isSelected,
      BuildContext context
      ){
    return GestureDetector(
      onTap: () => onSelectedClassroom(classroom),
      child: CommonCardWidget(
        border: Border.all(
          color: isSelected
              ? ColorConstant.primary
              : ColorConstant.borderBlueGrey,
          width: isSelected ? 1.5 : 1.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          classroom.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? ColorConstant.primary
                                : null,
                          ),
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          classroom.code,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${classroom.classroomType.name} • Kelas ${classroom.grade}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: ColorConstant.textGreyColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected
                  ? ColorConstant.primary
                  : ColorConstant.textGreyColor,
              size: 22,
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () => onDeleteClassroom(classroom),
              icon: const Icon(Icons.delete),
              color: ColorConstant.redColor,
              tooltip: context.l10n.deleteClassroom,
            )
          ],
        ),
      ),
    );
  }
}
