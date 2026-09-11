import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/data/models/auth_request_model.dart';
import 'package:novasight_app/app/data/models/user_model.dart';
import 'package:novasight_app/app/data/providers/auth_provider.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

class AuthRepository {
  final AuthProvider authProvider;
  final StorageService storageService;

  AuthRepository({
    required this.authProvider,
    required this.storageService,
  });

  /// Role mapping helper between Flutter UserRoles and backend AllowedRole
  static String mapRoleToBackend(UserRoles role) {
    switch (role) {
      case UserRoles.siswa:
        return 'student';
      case UserRoles.guru:
        return 'teacher';
    }
  }

  static UserRoles mapBackendToRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return UserRoles.siswa;
      case 'teacher':
      default:
        return UserRoles.guru;
    }
  }

  Future<String> login({
    required String email,
    required String password,
    required UserRoles role,
  }) async {
    final backendRole = mapRoleToBackend(role);
    final response = await authProvider.login(
      LoginRequestModel(
        email: email,
        password: password,
        role: backendRole,
      ),
    );

    final token = response.data;
    await storageService.writeAccessToken(token);
    await storageService.writeUserRole(role);
    await storageService.writePassword(password);
    await storageService.writeUserEmail(email);

    // Fetch and sync profile
    try {
      final profile = await getProfile();
      // If user profile has an email, ensure name fallback if none set
      if (storageService.getUserName() == null ||
          storageService.getUserName()!.isEmpty) {
        final emailPrefix = profile.email.split('@').first;
        await storageService.writeUserName(emailPrefix);
      }
    } catch (_) {
      // Ignore profile fetch failure during login so login itself succeeds
    }

    return token;
  }

  Future<StudentResponseModel> registerStudent({
    required String email,
    required String password,
    required String confirmPassword,
    String? fullName,
  }) async {
    final response = await authProvider.registerStudent(
      RegisterStudentRequestModel(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        role: 'student',
      ),
    );

    if (fullName != null && fullName.isNotEmpty) {
      await storageService.writeUserName(fullName);
    }
    await storageService.writeUserRole(UserRoles.siswa);
    await storageService.writePassword(password);
    await storageService.writeUserEmail(email);

    return response.data;
  }

  Future<TeacherResponseModel> registerTeacher({
    required String email,
    required String password,
    required String confirmPassword,
    String? fullName,
  }) async {
    final response = await authProvider.registerTeacher(
      RegisterTeacherRequestModel(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        role: 'teacher',
      ),
    );

    if (fullName != null && fullName.isNotEmpty) {
      await storageService.writeUserName(fullName);
    }
    await storageService.writeUserRole(UserRoles.guru);
    await storageService.writePassword(password);
    await storageService.writeUserEmail(email);

    return response.data;
  }

  Future<ProfileResponseModel> getProfile() async {
    final response = await authProvider.getProfile();
    final profile = response.data;
    if (profile.email.isNotEmpty) {
      await storageService.writeUserEmail(profile.email);
    }
    return profile;
  }

  Future<bool> isLoggedIn() async {
    final token = await storageService.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await storageService.clearAll();
  }
}