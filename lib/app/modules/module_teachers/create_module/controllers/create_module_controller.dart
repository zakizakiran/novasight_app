import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/data/model/class_model.dart';
import 'package:novasight_app/app/data/model/selected_pdf_model.dart';
import 'package:file_picker/file_picker.dart';


class CreateModuleController extends GetxController {
  final TextEditingController titleModuleController = TextEditingController();
  final TextEditingController descriptionModuleController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final Rxn<SelectedPdfModel> selectedPdf = Rxn<SelectedPdfModel>();

  final Rx<bool> isLoading = false.obs;
  final Rx<bool> isValid = false.obs;
  final List<ClassGradeType> listClass = ClassGradeType.values;
  final Rxn<ClassGradeType> selectedGrade = Rxn<ClassGradeType>();

  void onChange(String _){
    final bool isValidTitle = titleModuleController.text.isNotEmpty;
    final bool isValidClass = selectedGrade.value != null;
    final bool isValidPdf = selectedPdf.value != null;
    isValid.value = isValidTitle && isValidClass && isValidPdf;
  }

  void onSelectGrade(ClassGradeType type){
    selectedGrade.value = type;
    onChange(type.name);
  }

  void onUploadModule(){

  }

  Future<void> onPickModule() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
        withData: true,
      );

      if (result == null) return;

      final file = result.files.single;

      selectedPdf.value = SelectedPdfModel(
        name: file.name,
        bytes: file.bytes!,
        size: file.size,
      );
      onChange(file.name);
    } on PlatformException catch (e) {
      Get.snackbar(
        "Gagal memilih file",
        "Jika mengambil dari gdrive silahkan cek koneksi internet anda.",
      );

      debugPrint(e.toString());
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    titleModuleController.dispose();
    descriptionModuleController.dispose();
    super.onClose();
  }
}
