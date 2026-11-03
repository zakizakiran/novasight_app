import 'package:drift/drift.dart';
import 'package:lydera_app/app/data/models/local/chapter.dart';

@TableIndex(name: 'idx_chapter_id', columns: {#chapter})
class RecordNote extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 255)();
  TextColumn get content => text()();
  IntColumn get chapter => integer().references(Chapter, #id)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {chapter},
  ];
}