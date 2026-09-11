import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/main_bar_args.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthRepository authRepository;

  SplashController({required this.authRepository});

  Future<void> checkRole() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final isLoggedIn = await authRepository.isLoggedIn();
    if (!isLoggedIn) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    try {
      // Validate session with backend
      final profile = await authRepository.getProfile();
      UserRoles? role = authRepository.storageService.getRole();

      // If role wasn't saved locally, detect from profile
      if (role == null) {
        if (profile.teacher != null) {
          role = UserRoles.guru;
        } else {
          role = UserRoles.siswa;
        }
        await authRepository.storageService.writeUserRole(role);
      }

      Get.offAllNamed(
        Routes.MAIN_LAYOUT,
        arguments: MainBarArgs(role: role),
      );
    } catch (_) {
      // If token expired or network failed to validate token, check if we have offline role or go to login
      final role = authRepository.storageService.getRole();
      if (role != null) {
        Get.offAllNamed(
          Routes.MAIN_LAYOUT,
          arguments: MainBarArgs(role: role),
        );
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkRole();
  }
}
