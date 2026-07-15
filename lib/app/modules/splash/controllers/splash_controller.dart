import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';

class SplashController extends GetxController {
  final AuthRepository authRepository;

  SplashController({required this.authRepository});

  final count = 0.obs;



  void increment() => count.value++;
}
