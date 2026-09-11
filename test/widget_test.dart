import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/modules/auth/login/controllers/login_controller.dart';
import 'package:novasight_app/app/modules/auth/login/views/login_view.dart';
import 'package:novasight_app/app/modules/auth/widgets/role_switch_widget.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockRepository;
  late MockStorageService mockStorageService;
  late LoginController controller;

  setUpAll(() {
    registerFallbackValue(UserRoles.guru);
  });

  setUp(() {
    Get.testMode = true;
    mockRepository = MockAuthRepository();
    mockStorageService = MockStorageService();
    when(() => mockRepository.storageService).thenReturn(mockStorageService);
    when(() => mockStorageService.getUserName()).thenReturn('Guru Demo');

    controller = LoginController(repository: mockRepository);
    Get.put<LoginController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('LoginView renders all critical elements and accessibility labels', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginView(),
      ),
    );

    // Verify Title and subtitle
    expect(find.text('Selamat Datang'), findsOneWidget);
    expect(find.text('Masuk untuk lanjutkan'), findsOneWidget);

    // Verify RoleSwitchWidget exists
    expect(find.byType(RoleSwitchWidget), findsOneWidget);

    // Verify Email and Password input fields exist
    expect(find.byType(CommonTextFormFieldWidget), findsNWidgets(2));

    // Verify Submit button exists
    expect(find.byType(CommonButtonWidget), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Lupa kata sandi?'), findsOneWidget);
  });
}
