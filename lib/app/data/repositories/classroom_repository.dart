import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/providers/classroom_provider.dart';

class ClassroomRepository {
  final ClassroomProvider classroomProvider;

  ClassroomRepository({required this.classroomProvider});

  Future<List<ClassroomTypeModel>> getClassroomTypes() async {
    final response = await classroomProvider.getClassroomTypes();
    return response.data;
  }

  Future<List<CityResponseModel>> getCities() async {
    final response = await classroomProvider.getCities();
    return response.data;
  }

  Future<List<SchoolResponseModel>> getSchoolsByCity(int cityId) async {
    final response = await classroomProvider.getSchoolsByCity(cityId);
    return response.data;
  }

  Future<ClassroomResponseModel> createClassroom({
    required String name,
    required int classroomTypeId,
    required int schoolId,
    required int grade,
  }) async {
    final response = await classroomProvider.createClassroom(
      ClassroomCreateModel(
        name: name,
        classroomTypeId: classroomTypeId,
        schoolId: schoolId,
        grade: grade,
      ),
    );
    return response.data;
  }

  Future<void> joinClassroom({required String code}) async {
    await classroomProvider.joinClassroom(
      JoinClassroomRequestModel(code: code),
    );
  }

  Future<List<ClassroomResponseModel>> getClassrooms() async {
    final response = await classroomProvider.getClassrooms();
    return response.data;
  }
}
