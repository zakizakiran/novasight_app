import 'package:drift/drift.dart';
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

  Future<RecordNoteData> createOrUpdateNote(RecordNoteCompanion recordNote) async {
    await db.upsert(database.recordNote, recordNote, target: [database.recordNote.chapter]);
    return db.selectSingleNonNull(database.recordNote, predicate: (tbl) => tbl.chapter.equals(recordNote.chapter.value));
  }

  Future<void> markAsSynced(int id) async {
    await db.update(database.recordNote, data: const RecordNoteCompanion(
      isSynced: Value(true),
    ), predicate: (tbl) => tbl.id.equals(id));
  }

  Future<void> updateLastFetchedAt(int id) async {
    await (database.update(database.recordNote)
      ..where((tbl) => tbl.id.equals(id)))
        .write(
      RecordNoteCompanion(
        lastFetchedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteNote(int chapterId) {
    return db.delete(
      database.recordNote,
      predicate: (tbl) => tbl.chapter.equals(chapterId),
    );
  }
}