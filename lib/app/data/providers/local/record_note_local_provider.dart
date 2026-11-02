import '../../../core/network/database.dart';
import '../../../core/network/database_client.dart';
import '../../services/local/database_service.dart';

class RecordNoteLocalProvider {
  final DatabaseService _service;
  RecordNoteLocalProvider({required this._service});

  DatabaseClient get db => _service.client;
  AppDatabase get database => _service.database;

  Future<List<RecordNoteData>> getNotes() {
    return db.selectAll(database.recordNote);
  }
}