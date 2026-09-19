import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/data/models/user_model.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthRepository _repository;
  final Rxn<UserRoles> role = Rxn<UserRoles>();
  final RxString email = ''.obs;
  final RxString name = ''.obs;
  final RxBool isLoading = false.obs;
  final Rxn<ProfileResponseModel> profile = Rxn<ProfileResponseModel>();
  final RxString className = ''.obs;

  StorageService get storageService => _repository.storageService;

  ProfileController({required this._repository});

  void init() {
    role.value = _repository.storageService.getRole();
    final cachedEmail = _repository.storageService.getUserEmail();
    if (cachedEmail != null && cachedEmail.isNotEmpty) {
      email.value = cachedEmail;
    }
    final cachedName = _repository.storageService.getUserName();
    if (cachedName != null && cachedName.isNotEmpty) {
      name.value = cachedName;
    }
    final cachedClass = _repository.storageService.getClassName();
    if (cachedClass != null && cachedClass.isNotEmpty) {
      className.value = cachedClass;
    }
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final data = await _repository.getProfile();
      profile.value = data;
      email.value = data.email;
      if (name.value.isEmpty) {
        name.value = data.email.split('@').first;
      }
      await _repository.storageService.writeUserEmail(data.email);
    } catch (_) {
      // Keep cached values if fetch fails
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onLogout() async {
    await _repository.storageService.clearAll();
    Get.offAllNamed(Routes.SPLASH);
  }

  Future<void> onLeaveClass() async {}

  @override
  void onInit() {
    super.onInit();
    init();
    loadProfile();
  }
}
