import 'package:drift/drift.dart';
import 'package:lydera_app/app/data/models/local/chapter.dart';

@TableIndex(name: 'idx_chapter_id', columns: {#chapter})
class RecordNote extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().nullable().withLength(max: 255)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get content => text()();
  IntColumn get chapter => integer().references(Chapter, #id)();
  DateTimeColumn get lastFetchedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {chapter},
  ];
}