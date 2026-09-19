import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/views/widgets/select_widget.dart';

import 'dart:typed_data';
import 'package:novasight_app/app/core/constants/env_config.dart';
import '../../../../../core/styles/colors/color_constant.dart';
import '../../controllers/module_evaluation_controller.dart';
import '../../shimmer/chunk_text_shimmer.dart';

class ChunkCardWidget extends GetView<ModuleEvaluationController> {
  final ModuleChunk chunk;
  final int? blockNumber;
  const ChunkCardWidget({super.key, required this.chunk, this.blockNumber});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedChunks.contains(chunk);
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: Dimens.spacePadding),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(Dimens.radius),
          border: Border.all(
            color: isSelected
                ? ColorConstant.primary
                : ColorConstant.borderBlueGrey.withValues(alpha: 0.5),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ColorConstant.primary.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : const [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.radius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SelectWidget(chunk: chunk, blockNumber: blockNumber),

          Table(
            columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimens.innerPadding),
                    child: switch (chunk) {
                      TextChunk textChunk => Text(
                        textChunk.text,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      ImageChunk imageChunk => _buildImageChunk(
                        context,
                        imageChunk,
                      ),
                    },
                  ),

                  Obx(() {
                    final isThisChunkUpdating =
                        controller.selectedChunks.contains(chunk) &&
                        controller.isLoading.value;

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
                  }),
                ],
              ),
            ],
          ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildImageChunk(BuildContext context, ImageChunk imageChunk) {
    // 1. Direct memory image if pre-rendered / provided in test
    if (imageChunk.imageBytes != null && imageChunk.imageBytes!.isNotEmpty) {
      return _buildMemoryImage(imageChunk.imageBytes!, imageChunk);
    }

    // 2. Direct network or asset image from backend response
    return _buildNetworkOrAssetImage(context, imageChunk);
  }

  Widget _buildMemoryImage(Uint8List bytes, ImageChunk imageChunk) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.radius),
      child: Image.memory(
        bytes,
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
        errorBuilder: (context, error, stackTrace) =>
            _buildImageFallback(context, imageChunk),
      ),
    );
  }

  Widget _buildNetworkOrAssetImage(BuildContext context, ImageChunk imageChunk) {
    final path = imageChunk.imagePath.trim();
    if (path.isEmpty) {
      return _buildImageFallback(context, imageChunk);
    }

    if (path.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radius),
        child: Image.asset(
          path,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
          errorBuilder: (context, error, stackTrace) =>
              _buildImageFallback(context, imageChunk),
        ),
      );
    }

    final String imageUrl =
        (path.startsWith('http://') || path.startsWith('https://'))
            ? path
            : (path.startsWith('/')
                ? '${EnvConfig.baseUrl}$path'
                : '${EnvConfig.baseUrl}/$path');

    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.radius),
      child: Image.network(
        imageUrl,
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 100,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            _buildImageFallback(context, imageChunk),
      ),
    );
  }

  Widget _buildImageFallback(BuildContext context, ImageChunk imageChunk) {
    final fileName = imageChunk.imagePath.split('/').last;

    IconData icon = Icons.image_outlined;
    String title = "Gambar Modul";

    if (imageChunk.isTable) {
      icon = Icons.table_chart_outlined;
      title = "Tabel Modul";
    } else if (imageChunk.isFormula) {
      icon = Icons.functions;
      title = "Formula / Rumus";
    } else if (imageChunk.isDiagram) {
      icon = Icons.insert_chart_outlined;
      title = "Diagram / Grafik";
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacePadding,
        vertical: Dimens.spacePadding,
      ),
      decoration: BoxDecoration(
        color: ColorConstant.borderBlueGrey.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimens.radius),
        border: Border.all(
          color: ColorConstant.borderBlueGrey.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 36,
            color: ColorConstant.primary,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorConstant.darkGrey,
            ),
            textAlign: TextAlign.center,
          ),
          if (imageChunk.sourceMarkup != null &&
              imageChunk.sourceMarkup!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: ColorConstant.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: ColorConstant.borderBlueGrey),
              ),
              child: Text(
                imageChunk.sourceMarkup!.trim(),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: ColorConstant.darkGrey,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else if (fileName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              fileName.length > 24
                  ? '${fileName.substring(0, 20)}...'
                  : fileName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: ColorConstant.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
