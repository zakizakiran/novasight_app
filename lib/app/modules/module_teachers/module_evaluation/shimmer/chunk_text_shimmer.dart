import 'package:flutter/material.dart';

import '../../../../common/common_shimmer_widget.dart';
import '../../../../core/Dimens.dart';
class ChunkTextShimmer extends StatelessWidget {
  const ChunkTextShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerWidget(
      height: 150,
      margin: EdgeInsets.only(bottom: Dimens.spacePadding),
      radius: Dimens.radius,
    );
  }
}
