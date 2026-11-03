import 'package:lydera_app/app/core/network/database.dart';
import 'package:lydera_app/app/data/models/local/record_note.dart';
import 'package:lydera_app/app/data/models/student_model.dart';
import 'package:lydera_app/app/data/models/student_quiz_model.dart';
import 'package:lydera_app/app/data/providers/local/record_note_local_provider.dart';
import 'package:lydera_app/app/data/providers/student_provider.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';

class RecordNoteRepository {
  final RecordNoteLocalProvider recordNoteLocalProvider;

  RecordNoteRepository({
    required this.recordNoteLocalProvider,
  });

  Future<RecordNoteData?> getNoteByChapterId({
    required int chapterId,
  }) async {
    final response = await recordNoteLocalProvider.getNotesByChapterId(chapterId);
    return response;
  }

  Future<int> submitNote({
    required RecordNoteCompanion recordNote,
  }) async {
    final response = await recordNoteLocalProvider.createOrUpdateNote(recordNote);
    return response;
  }

  // Future<bool> deleteStepAnswer({
  //   required int stepId,
  // }) async {
  //   final response = await studentProvider.deleteStepAnswer(
  //       stepId: stepId
  //   );
  //   return response.data;
  // }
}
