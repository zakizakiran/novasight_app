import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/l10n_extension.dart';

import '../controllers/note_controller.dart';
import 'note_display_widget.dart';

class NoteView extends GetView<NoteController> {
  const NoteView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
        onWillPop: () async {
          if (controller.isInputActive.value) {
            controller.deactivateInput();
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: ColorConstant.background,
          body: Column(
            children: [
              CommonAppBar(
                title: context.l10n.noteAppBarTitle,
                description: context.l10n.questionOf(controller.index, controller.total),
              ),
              Expanded(child: NoteDisplayWidget()),
            ],
          ),
        )
    );
  }
}
