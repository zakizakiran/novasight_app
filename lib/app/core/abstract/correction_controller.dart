import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/module_teacher_model.dart';

abstract class CorrectionAIController {
  RxBool get isLoadingRevision;
  RxBool get isValid;

  RxList<ModuleChunk> get selectedChunks;

  GlobalKey<FormState> get formKey;
  TextEditingController get adviceController;

  void onChangeAdviceController(String value);
  Future<void> onSendAdvice();
}

abstract class CorrectionNormalTextController {
  List<ModuleChunk> get selectedChunks;

  GlobalKey<FormState> get textFormKey;
  TextEditingController get textEditController;

  RxBool get isTextValid;

  void onTextChange(String value);
  Future<void> onSaveDirectText();
}

abstract class SelectChunkController{

  List<ModuleChunk> get selectedChunks;

  void onSelectChunk(ModuleChunk value);
}
