import 'package:lydera_app/app/data/models/student_model.dart';
import 'package:lydera_app/app/data/models/student_quiz_model.dart';
import 'package:lydera_app/app/data/providers/student_provider.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';

class NoteRepository {
  final StudentProvider studentProvider;

  NoteRepository({
    required this.studentProvider,
  });

  Future<StudentStep> submitStepAnswer({
    required int soalId,
    required SoalStepRequest request,
  }) async {
    final response = await studentProvider.submitStepAnswer(
      soalId: soalId,
      request: request,
    );
    return response.data;
  }

  Future<bool> deleteStepAnswer({
    required int stepId,
  }) async {
    final response = await studentProvider.deleteStepAnswer(
        stepId: stepId
    );
    return response.data;
  }
}
