import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/styles/img/img_constant.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/modules/splash/controllers/splash_controller.dart';
import 'package:novasight_app/app/modules/splash/views/splash_view.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepo;

  setUp(() {
    Get.reset();
    mockAuthRepo = MockAuthRepository();
    when(() => mockAuthRepo.isLoggedIn()).thenAnswer((_) async => false);
    Get.put<SplashController>(SplashController(authRepository: mockAuthRepo));
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('SplashView renders Image widget with ImgConstant.mobileApp', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: SplashView(),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    final imageWidget = tester.widget<Image>(find.byType(Image));
    final imageProvider = imageWidget.image;
    final AssetImage assetImage;
    if (imageProvider is ResizeImage) {
      assetImage = imageProvider.imageProvider as AssetImage;
    } else {
      assetImage = imageProvider as AssetImage;
    }
    expect(assetImage.assetName, equals(ImgConstant.mobileApp));
  });
}
