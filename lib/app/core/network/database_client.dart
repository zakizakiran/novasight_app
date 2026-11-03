import 'package:drift/drift.dart';
import 'database.dart';

class DatabaseClient {
  final AppDatabase _database;

  DatabaseClient(this._database);

  // SELECT ALL
  Future<List<D>> selectAll<T extends Table, D extends DataClass>(
      TableInfo<T, D> table, {
        int? limit,
        int? offset,
      }) {
    final query = _database.select(table);

    if (limit != null) {
      query.limit(limit, offset: offset ?? 0,);
    }

    return query.get();
  }

  // SELECT WITH WHERE
  Future<List<D>> selectWhere<T extends Table, D extends DataClass>(
      TableInfo<T, D> table, {
        required Expression<bool> Function(T tbl) predicate,
        int? limit,
        int? offset,
      }) {
    final query = _database.select(table)
      ..where(predicate);

    if (limit != null) {
      query.limit(limit, offset: offset ?? 0);
    }

    return query.get();
  }

  // SELECT SINGLE
  Future<D?> selectSingle<T extends Table, D extends DataClass>(
      TableInfo<T, D> table, {
        required Expression<bool> Function(T tbl) predicate,
      }) {
    return (_database.select(table)
      ..where(predicate))
        .getSingleOrNull();
  }

  // UPSERT
  Future<int> upsert<T extends Table, D extends DataClass>(
      TableInfo<T, D> table,
      Insertable<D> data,
      ) {
    return _database.into(table).insertOnConflictUpdate(data);
  }

  // INSERT
  Future<int> insert<T extends Table, D extends DataClass>(
      TableInfo<T, D> table,
      Insertable<D> data, {
        InsertMode mode = InsertMode.insert,
      }) {
    return _database.into(table).insert(data, mode: mode);
  }

  // INSERT MULTIPLE
  Future<void> insertAll<T extends Table, D extends DataClass>(
      TableInfo<T, D> table,
      List<Insertable<D>> data, {
        InsertMode mode = InsertMode.insert,
      }) {
    return _database.batch((batch) {
      batch.insertAll(table, data, mode: mode);
    });
  }

  // UPDATE
  Future<int> update<T extends Table, D extends DataClass>(
      TableInfo<T, D> table, {
        required Insertable<D> data,
        required Expression<bool> Function(T tbl) predicate,
      }) {
    return (_database.update(table)
      ..where(predicate))
        .write(data);
  }

  // UPDATE ALL
  Future<int> updateAll<T extends Table, D extends DataClass>(
      TableInfo<T, D> table,
      Insertable<D> data,
      ) {
    return _database.update(table).write(data);
  }

  // DELETE
  Future<int> delete<T extends Table, D extends DataClass>(
      TableInfo<T, D> table, {
        required Expression<bool> Function(T tbl) predicate,
      }) {
    return (_database.delete(table)
      ..where(predicate))
        .go();
  }

  // DELETE ALL
  Future<int> deleteAll<T extends Table, D extends DataClass>(
      TableInfo<T, D> table,
      ) {
    return _database.delete(table).go();
  }

  // COUNT
  Future<int> count<T extends Table, D extends DataClass>(
      TableInfo<T, D> table, {
        Expression<bool> Function(T tbl)? predicate,
      }) async {
    final countExpression = countAll();

    final query = _database.selectOnly(table)
      ..addColumns([countExpression]);

    if (predicate != null) {
      query.where(predicate(table.asDslTable));
    }

    final result = await query.getSingle();

    return result.read(countExpression) ?? 0;
  }

  // TRANSACTION
  Future<R> transaction<R>(Future<R> Function() action) {
    return _database.transaction(action);
  }

  // CLOSE
  Future<void> close() {
    return _database.close();
  }
}
