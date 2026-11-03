import 'package:lydera_app/app/data/models/local/record_note.dart';

import '../../../core/network/database.dart';
import '../../../core/network/database_client.dart';
import '../../services/local/database_service.dart';

class RecordNoteLocalProvider {
  final DatabaseService _service;
  RecordNoteLocalProvider({required this._service});

  DatabaseClient get db => _service.client;
  AppDatabase get database => _service.database;

  Future<RecordNoteData?> getNotesByChapterId(int chapterId) {
    return db.selectSingle(database.recordNote, predicate: (tbl) => tbl.chapter.equals(chapterId));
  }

  Future<int> createOrUpdateNote(RecordNoteCompanion  recordNote) {
    return db.upsert(database.recordNote, recordNote);
  }

  Future<int> deleteNote(int chapterId) {
    return db.delete(
      database.recordNote,
      predicate: (tbl) => tbl.chapter.equals(chapterId),
    );
  }
}