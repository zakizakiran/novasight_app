import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/AuthRepository.dart';
import 'package:novasight_app/app/data/services/local/StorageService.dart';

Future<void> initDepedencies() async {
  Get.put(StorageService(), permanent: true);

  Get.lazyPut<AuthRepository>(
      () => AuthRepository(
        storageService: Get.find<StorageService>()
      )
  );
}