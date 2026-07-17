import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/main_bar_args.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

import '../../../data/model/user_profile_model.dart';
import '../../../data/repositories/auth_repository.dart';

class SplashController extends GetxController {
  final AuthRepository authRepository;

  SplashController({required this.authRepository});

  Future<void> checkRole() async {
    await Future.delayed(const Duration(milliseconds: 1300));
    final role = authRepository.storageService.getRole();
    final route = switch (role) {
      null => Routes.LOGIN,
      UserRoles.siswa => Routes.MAIN_LAYOUT,
      // Guru
      UserRoles.guru => Routes.MAIN_LAYOUT,
    };
    Get.offAllNamed(
        route,
      arguments: role != null ? MainBarArgs(role: role) : dynamic
    );
  }

  @override
  void onInit() {
    super.onInit();
    checkRole();
  }
}
