

import '../../core/network/dio_client.dart';

class RecordNoteRemoteProvider {

  final DioClient dioClient;

  RecordNoteRemoteProvider({required this.dioClient});
  // Future<RecordNoteData?> getNotesByChapterId(int chapterId) {
  //   return db.selectSingle(database.recordNote, predicate: (tbl) => tbl.chapter.equals(chapterId));
  // }
  //
  // Future<int> createOrUpdateNote(RecordNoteCompanion  recordNote) {
  //   return db.upsert(database.recordNote, recordNote);
  // }
  //
  // Future<int> deleteNote(int chapterId) {
  //   return db.delete(
  //     database.recordNote,
  //     predicate: (tbl) => tbl.chapter.equals(chapterId),
  //   );
  // }
}