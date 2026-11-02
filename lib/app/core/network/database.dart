import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/local/chapter.dart';
import '../../data/models/local/record_note.dart';

part 'database.g.dart';

@DriftDatabase(tables: [RecordNote, Chapter])
class AppDatabase extends _$AppDatabase{
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'lydera_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}