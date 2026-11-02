import 'package:drift/drift.dart';

class Chapter extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
}