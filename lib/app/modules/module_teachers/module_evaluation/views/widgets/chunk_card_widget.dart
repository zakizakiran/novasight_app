import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/views/widgets/select_widget.dart';

import '../../../../../core/styles/colors/color_constant.dart';
import '../../controllers/module_evaluation_controller.dart';
import '../../shimmer/chunk_text_shimmer.dart';
class ChunkCardWidget extends GetView<ModuleEvaluationController> {
  final ModuleChunk chunk;
  const ChunkCardWidget({super.key, required this.chunk});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimens.spacePadding),
      decoration: const BoxDecoration(
        color: ColorConstant.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectWidget(chunk: chunk),

          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimens.innerPadding),
                    child: switch(chunk) {
                      TextChunk textChunk => Text(
                        textChunk.text,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      ImageChunk imageChunk => Image.asset(
                        imageChunk.imagePath,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    },
                  ),

                  Obx(() {
                    final isThisChunkUpdating = controller.selectedChunks.contains(chunk) && controller.isLoading.value;

                    if (isThisChunkUpdating) {
                      return const Padding(
                        padding: EdgeInsets.all(Dimens.innerPadding),
                        child: ChunkTextShimmer(),
                      );
                    }


                    return Padding(
                      padding: const EdgeInsets.all(Dimens.innerPadding),
                      child: Text(
                        chunk.annotation ?? "-",
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  })
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}