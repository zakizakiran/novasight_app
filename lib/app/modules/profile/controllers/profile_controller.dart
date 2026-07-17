import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthRepository _repository;
  final Rxn<UserRoles> role = Rxn<UserRoles>();

  ProfileController({required this._repository});

  void init() {
    role.value = _repository.storageService.getRole()!;
  }

  Future<void> onLogout() async{
    await _repository.storageService.clearAll();
    Get.offAllNamed(Routes.SPLASH);
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
