import 'package:get/get.dart';
import 'package:lydera_app/app/core/network/dio_client.dart';
import 'package:lydera_app/app/data/providers/auth_provider.dart';
import 'package:lydera_app/app/data/providers/chatbot_provider.dart';
import 'package:lydera_app/app/data/providers/classroom_provider.dart';
import 'package:lydera_app/app/data/providers/local/record_note_local_provider.dart';
import 'package:lydera_app/app/data/providers/record_note_remote_provider.dart';
import 'package:lydera_app/app/data/providers/student_provider.dart';
import 'package:lydera_app/app/data/providers/teacher_provider.dart';
import 'package:lydera_app/app/data/repositories/auth_repository.dart';
import 'package:lydera_app/app/data/repositories/chatbot_repository.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/repositories/module_repository.dart';
import 'package:lydera_app/app/data/repositories/note_repository.dart';
import 'package:lydera_app/app/data/repositories/record_note_repository.dart';
import 'package:lydera_app/app/data/repositories/student_repository.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';
import 'package:lydera_app/app/data/services/connectivity_service.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/data/services/remote/module_service.dart';
import 'package:lydera_app/app/data/services/remote/module_teacher_service.dart';

import '../data/services/local/database_service.dart';

Future<void> initDepedencies() async {
  Get.put(DatabaseService(), permanent: true,);

  final storageService = StorageService();
  await storageService.init();
  Get.put(storageService, permanent: true);

  Get.put<ConnectivityService>(
    ConnectivityService(),
    permanent: true
  );

  // Network & Providers
  final dioClient = DioClient(storageService: storageService);
  Get.put(dioClient, permanent: true);

  final authProvider = AuthProvider(dioClient: dioClient);
  Get.put(authProvider, permanent: true);

  final classroomProvider = ClassroomProvider(dioClient: dioClient);
  Get.put(classroomProvider, permanent: true);

  final studentProvider = StudentProvider(dioClient: dioClient);
  Get.put(studentProvider, permanent: true);

  final teacherProvider = TeacherProvider(dioClient: dioClient);
  Get.put(teacherProvider, permanent: true);

  final chatbotProvider = ChatbotProvider(dioClient: dioClient);
  Get.put(chatbotProvider, permanent: true);

  Get.put(ModuleService(), permanent: true);
  Get.put(ModuleTeacherService(), permanent: true);

  Get.put<ModuleRepository>(
    ModuleRepository(
      Get.find<ModuleService>(),
    ),
    permanent: true,
  );

  Get.put<AuthRepository>(
    AuthRepository(
      authProvider: Get.find<AuthProvider>(),
      storageService: Get.find<StorageService>(),
    ),
    permanent: true,
  );

  Get.put<RecordNoteLocalProvider>(
    RecordNoteLocalProvider(
      service: Get.find<DatabaseService>(),
    ),
    permanent: true,
  );

  Get.put<RecordNoteRemoteProvider>(
    RecordNoteRemoteProvider(dioClient: Get.find<DioClient>()),
    permanent: true
  );

  Get.put<RecordNoteRepository>(
    RecordNoteRepository(
      recordNoteLocalProvider: Get.find<RecordNoteLocalProvider>(),
      recordNoteRemoteProvider: Get.find<RecordNoteRemoteProvider>(),
      connectivityService: Get.find<ConnectivityService>()
    ),
    permanent: true,
  );

  Get.put<ClassroomRepository>(
    ClassroomRepository(
      classroomProvider: Get.find<ClassroomProvider>(),
    ),
    permanent: true,
  );

  Get.put<ChatbotRepository>(
    ChatbotRepository(
      chatbotProvider: Get.find<ChatbotProvider>(),
    ),
    permanent: true,
  );

  Get.put<StudentRepository>(
    StudentRepository(
      studentProvider: Get.find<StudentProvider>(),
      storageService: Get.find<StorageService>(),
    ),
    permanent: true,
  );

  Get.put<TeacherRepository>(
    TeacherRepository(
      teacherProvider: Get.find<TeacherProvider>(),
      storageService: Get.find<StorageService>(),
    ),
    permanent: true,
  );

  Get.put<NoteRepository>(
    NoteRepository(
      studentProvider: Get.find<StudentProvider>(),
    ),
    permanent: true,
  );
}
