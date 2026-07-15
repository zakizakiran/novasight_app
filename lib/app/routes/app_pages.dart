import 'package:get/get.dart';

import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register_account/bindings/register_account_binding.dart';
import '../modules/auth/register_account/views/register_account_view.dart';
import '../modules/auth/register_class/bindings/register_class_binding.dart';
import '../modules/auth/register_class/views/register_class_view.dart';
import '../modules/auth/success_join_class/bindings/success_join_class_binding.dart';
import '../modules/auth/success_join_class/views/success_join_class_view.dart';
import '../modules/create_class/bindings/create_class_binding.dart';
import '../modules/create_class/views/create_class_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/module/bindings/module_binding.dart';
import '../modules/module/views/module_view.dart';
import '../modules/module_detail/bindings/module_detail_binding.dart';
import '../modules/module_detail/views/module_detail_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/subject/bindings/subject_binding.dart';
import '../modules/subject/views/subject_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_CLASS,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SUCCESS_JOIN_CLASS,
      page: () => const SuccessJoinClassView(),
      binding: SuccessJoinClassBinding(),
    ),
    GetPage(
      name: _Paths.MODULE,
      page: () => const ModuleView(),
      binding: ModuleBinding(),
    ),
    GetPage(
      name: _Paths.MODULE_DETAIL,
      page: () => const ModuleDetailView(),
      binding: ModuleDetailBinding(),
    ),
    GetPage(
      name: _Paths.SUBJECT,
      page: () => const SubjectView(),
      binding: SubjectBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_ACCOUNT,
      page: () => const RegisterAccountView(),
      binding: RegisterAccountBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_CLASS,
      page: () => const CreateClassView(),
      binding: CreateClassBinding(),
    ),
  ];
}
