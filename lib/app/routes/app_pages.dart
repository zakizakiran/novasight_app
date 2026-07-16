import 'package:get/get.dart';

import '../modules/auth/create_class/bindings/create_class_binding.dart';
import '../modules/auth/create_class/views/create_class_view.dart';
import '../modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/forgot_password_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register_account/bindings/register_account_binding.dart';
import '../modules/auth/register_account/views/register_account_view.dart';
import '../modules/auth/register_class/bindings/register_class_binding.dart';
import '../modules/auth/register_class/views/register_class_view.dart';
import '../modules/auth/success_create_class/bindings/success_create_class_binding.dart';
import '../modules/auth/success_create_class/views/success_create_class_view.dart';
import '../modules/auth/success_join_class/bindings/success_join_class_binding.dart';
import '../modules/auth/success_join_class/views/success_join_class_view.dart';
import '../modules/chatbot/views/chatbot_view.dart';
import '../modules/exam/bindings/exam_binding.dart';
import '../modules/exam/views/exam_view.dart';
import '../modules/exam_active/bindings/exam_active_binding.dart';
import '../modules/exam_active/views/exam_active_view.dart';
import '../modules/exam_detail/bindings/exam_detail_binding.dart';
import '../modules/exam_detail/views/exam_detail_view.dart';
import '../modules/main_layout/bindings/main_layout_binding.dart';
import '../modules/main_layout/views/main_layout_view.dart';
import '../modules/module/bindings/module_binding.dart';
import '../modules/module/views/module_view.dart';
import '../modules/module_detail/bindings/module_detail_binding.dart';
import '../modules/module_detail/views/module_detail_view.dart';
import '../modules/module_teachers/module_evaluation/bindings/module_evaluation_binding.dart';
import '../modules/module_teachers/module_evaluation/views/module_evaluation_view.dart';
import '../modules/module_teachers/create_module/bindings/create_module_binding.dart';
import '../modules/module_teachers/create_module/controllers/create_module_controller.dart';
import '../modules/module_teachers/create_module/views/create_module_loading_view.dart';
import '../modules/module_teachers/create_module/views/create_module_view.dart';
import '../modules/module_teachers/module_result_annotation/bindings/module_result_annotation_binding.dart';
import '../modules/module_teachers/module_result_annotation/views/module_result_annotation_view.dart';
import '../modules/module_teachers/module_teacher/bindings/module_teacher_binding.dart';
import '../modules/module_teachers/module_teacher/views/module_teacher_view.dart';
import '../modules/note/bindings/note_binding.dart';
import '../modules/note/views/note_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/student-dashboard/bindings/student_dashboard_binding.dart';
import '../modules/student-dashboard/views/student_dashboard_view.dart';
import '../modules/subject/bindings/subject_binding.dart';
import '../modules/subject/views/subject_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MODULE_TEACHER;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const StudentDashboardView(),
      binding: StudentDashboardBinding(),
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
    GetPage(
      name: _Paths.MAIN_LAYOUT,
      page: () => const MainLayoutView(),
      binding: MainLayoutBinding(),
      children: [
        GetPage(
          name: _Paths.EXAM,
          page: () => const ExamView(),
          binding: ExamBinding(),
        ),
      ],
    ),
    GetPage(name: _Paths.CHATBOT, page: () => const ChatbotView()),
    GetPage(name: _Paths.PROFILE, page: () => const ProfileView()),
    GetPage(
      name: _Paths.STUDENT_DASHBOARD,
      page: () => const StudentDashboardView(),
      binding: StudentDashboardBinding(),
    ),
    GetPage(
      name: _Paths.EXAM_DETAIL,
      page: () => const ExamDetailView(),
      binding: ExamDetailBinding(),
    ),
    GetPage(
      name: _Paths.EXAM_ACTIVE,
      page: () => const ExamActiveView(),
      binding: ExamActiveBinding(),
    ),
    GetPage(
      name: _Paths.NOTE,
      page: () => const NoteView(),
      binding: NoteBinding(),
    ),
    GetPage(
      name: _Paths.SUCCESS_CREATE_CLASS,
      page: () => const SuccessCreateClassView(),
      binding: SuccessCreateClassBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.MODULE_TEACHER,
      page: () => const ModuleTeacherView(),
      binding: ModuleTeacherBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_MODULE,
      page: () => const CreateModuleView(),
      binding: CreateModuleBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_MODULE_LOADING,
      page: () => const CreateModuleLoadingView(),
      binding:
          BindingsBuilder(() => Get.lazyPut(() => CreateModuleController())),
    ),
    GetPage(
      name: _Paths.MODULE_RESULT_ANNOTATION,
      page: () => const ModuleResultAnnotationView(),
      binding: ModuleResultAnnotationBinding(),
    ),
    GetPage(
      name: _Paths.MODULE_EVALUATION,
      page: () => const ModuleEvaluationView(),
      binding: ModuleEvaluationBinding(),
    ),
  ];
}
