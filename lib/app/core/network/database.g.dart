// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ChapterTable extends Chapter with TableInfo<$ChapterTable, ChapterData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChapterTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapter';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChapterData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChapterData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  $ChapterTable createAlias(String alias) {
    return $ChapterTable(attachedDatabase, alias);
  }
}

class ChapterData extends DataClass implements Insertable<ChapterData> {
  final int id;
  final String title;
  const ChapterData({required this.id, required this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    return map;
  }

  ChapterCompanion toCompanion(bool nullToAbsent) {
    return ChapterCompanion(id: Value(id), title: Value(title));
  }

  factory ChapterData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
    };
  }

  ChapterData copyWith({int? id, String? title}) =>
      ChapterData(id: id ?? this.id, title: title ?? this.title);
  ChapterData copyWithCompanion(ChapterCompanion data) {
    return ChapterData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterData(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterData &&
          other.id == this.id &&
          other.title == this.title);
}

class ChapterCompanion extends UpdateCompanion<ChapterData> {
  final Value<int> id;
  final Value<String> title;
  const ChapterCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
  });
  ChapterCompanion.insert({
    this.id = const Value.absent(),
    required String title,
  }) : title = Value(title);
  static Insertable<ChapterData> custom({
    Expression<int>? id,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
    });
  }

  ChapterCompanion copyWith({Value<int>? id, Value<String>? title}) {
    return ChapterCompanion(id: id ?? this.id, title: title ?? this.title);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChapterCompanion(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $RecordNoteTable extends RecordNote
    with TableInfo<$RecordNoteTable, RecordNoteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordNoteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chapter (id)',
    ),
  );
  static const VerificationMeta _lastFetchedAtMeta = const VerificationMeta(
    'lastFetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastFetchedAt =
      GeneratedColumn<DateTime>(
        'last_fetched_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    isSynced,
    content,
    chapter,
    lastFetchedAt,
    updatedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'record_note';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecordNoteData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('last_fetched_at')) {
      context.handle(
        _lastFetchedAtMeta,
        lastFetchedAt.isAcceptableOrUnknown(
          data['last_fetched_at']!,
          _lastFetchedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {chapter},
  ];
  @override
  RecordNoteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordNoteData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      lastFetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_fetched_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $RecordNoteTable createAlias(String alias) {
    return $RecordNoteTable(attachedDatabase, alias);
  }
}

class RecordNoteData extends DataClass implements Insertable<RecordNoteData> {
  final int id;
  final String? title;
  final bool isSynced;
  final String content;
  final int chapter;
  final DateTime? lastFetchedAt;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  const RecordNoteData({
    required this.id,
    this.title,
    required this.isSynced,
    required this.content,
    required this.chapter,
    this.lastFetchedAt,
    this.updatedAt,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['content'] = Variable<String>(content);
    map['chapter'] = Variable<int>(chapter);
    if (!nullToAbsent || lastFetchedAt != null) {
      map['last_fetched_at'] = Variable<DateTime>(lastFetchedAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  RecordNoteCompanion toCompanion(bool nullToAbsent) {
    return RecordNoteCompanion(
      id: Value(id),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      isSynced: Value(isSynced),
      content: Value(content),
      chapter: Value(chapter),
      lastFetchedAt: lastFetchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFetchedAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory RecordNoteData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordNoteData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      content: serializer.fromJson<String>(json['content']),
      chapter: serializer.fromJson<int>(json['chapter']),
      lastFetchedAt: serializer.fromJson<DateTime?>(json['lastFetchedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String?>(title),
      'isSynced': serializer.toJson<bool>(isSynced),
      'content': serializer.toJson<String>(content),
      'chapter': serializer.toJson<int>(chapter),
      'lastFetchedAt': serializer.toJson<DateTime?>(lastFetchedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  RecordNoteData copyWith({
    int? id,
    Value<String?> title = const Value.absent(),
    bool? isSynced,
    String? content,
    int? chapter,
    Value<DateTime?> lastFetchedAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
  }) => RecordNoteData(
    id: id ?? this.id,
    title: title.present ? title.value : this.title,
    isSynced: isSynced ?? this.isSynced,
    content: content ?? this.content,
    chapter: chapter ?? this.chapter,
    lastFetchedAt: lastFetchedAt.present
        ? lastFetchedAt.value
        : this.lastFetchedAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  RecordNoteData copyWithCompanion(RecordNoteCompanion data) {
    return RecordNoteData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      content: data.content.present ? data.content.value : this.content,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      lastFetchedAt: data.lastFetchedAt.present
          ? data.lastFetchedAt.value
          : this.lastFetchedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordNoteData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isSynced: $isSynced, ')
          ..write('content: $content, ')
          ..write('chapter: $chapter, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    isSynced,
    content,
    chapter,
    lastFetchedAt,
    updatedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordNoteData &&
          other.id == this.id &&
          other.title == this.title &&
          other.isSynced == this.isSynced &&
          other.content == this.content &&
          other.chapter == this.chapter &&
          other.lastFetchedAt == this.lastFetchedAt &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class RecordNoteCompanion extends UpdateCompanion<RecordNoteData> {
  final Value<int> id;
  final Value<String?> title;
  final Value<bool> isSynced;
  final Value<String> content;
  final Value<int> chapter;
  final Value<DateTime?> lastFetchedAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> createdAt;
  const RecordNoteCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.content = const Value.absent(),
    this.chapter = const Value.absent(),
    this.lastFetchedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RecordNoteCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.isSynced = const Value.absent(),
    required String content,
    required int chapter,
    this.lastFetchedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : content = Value(content),
       chapter = Value(chapter);
  static Insertable<RecordNoteData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<bool>? isSynced,
    Expression<String>? content,
    Expression<int>? chapter,
    Expression<DateTime>? lastFetchedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (isSynced != null) 'is_synced': isSynced,
      if (content != null) 'content': content,
      if (chapter != null) 'chapter': chapter,
      if (lastFetchedAt != null) 'last_fetched_at': lastFetchedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RecordNoteCompanion copyWith({
    Value<int>? id,
    Value<String?>? title,
    Value<bool>? isSynced,
    Value<String>? content,
    Value<int>? chapter,
    Value<DateTime?>? lastFetchedAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? createdAt,
  }) {
    return RecordNoteCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      isSynced: isSynced ?? this.isSynced,
      content: content ?? this.content,
      chapter: chapter ?? this.chapter,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (lastFetchedAt.present) {
      map['last_fetched_at'] = Variable<DateTime>(lastFetchedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordNoteCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isSynced: $isSynced, ')
          ..write('content: $content, ')
          ..write('chapter: $chapter, ')
          ..write('lastFetchedAt: $lastFetchedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChapterTable chapter = $ChapterTable(this);
  late final $RecordNoteTable recordNote = $RecordNoteTable(this);
  late final Index idxChapterId = Index(
    'idx_chapter_id',
    'CREATE INDEX idx_chapter_id ON record_note (chapter)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    chapter,
    recordNote,
    idxChapterId,
  ];
}

typedef $$ChapterTableCreateCompanionBuilder =
    ChapterCompanion Function({Value<int> id, required String title});
typedef $$ChapterTableUpdateCompanionBuilder =
    ChapterCompanion Function({Value<int> id, Value<String> title});

final class $$ChapterTableReferences
    extends BaseReferences<_$AppDatabase, $ChapterTable, ChapterData> {
  $$ChapterTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecordNoteTable, List<RecordNoteData>>
  _recordNoteRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recordNote,
    aliasName: 'chapter__id__record_note__chapter',
  );

  $$RecordNoteTableProcessedTableManager get recordNoteRefs {
    final manager = $$RecordNoteTableTableManager(
      $_db,
      $_db.recordNote,
    ).filter((f) => f.chapter.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordNoteRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChapterTableFilterComposer
    extends Composer<_$AppDatabase, $ChapterTable> {
  $$ChapterTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recordNoteRefs(
    Expression<bool> Function($$RecordNoteTableFilterComposer f) f,
  ) {
    final $$RecordNoteTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordNote,
      getReferencedColumn: (t) => t.chapter,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordNoteTableFilterComposer(
            $db: $db,
            $table: $db.recordNote,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChapterTableOrderingComposer
    extends Composer<_$AppDatabase, $ChapterTable> {
  $$ChapterTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChapterTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChapterTable> {
  $$ChapterTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  Expression<T> recordNoteRefs<T extends Object>(
    Expression<T> Function($$RecordNoteTableAnnotationComposer a) f,
  ) {
    final $$RecordNoteTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordNote,
      getReferencedColumn: (t) => t.chapter,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordNoteTableAnnotationComposer(
            $db: $db,
            $table: $db.recordNote,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChapterTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChapterTable,
          ChapterData,
          $$ChapterTableFilterComposer,
          $$ChapterTableOrderingComposer,
          $$ChapterTableAnnotationComposer,
          $$ChapterTableCreateCompanionBuilder,
          $$ChapterTableUpdateCompanionBuilder,
          (ChapterData, $$ChapterTableReferences),
          ChapterData,
          PrefetchHooks Function({bool recordNoteRefs})
        > {
  $$ChapterTableTableManager(_$AppDatabase db, $ChapterTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChapterTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChapterTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChapterTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
              }) => ChapterCompanion(id: id, title: title),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String title}) =>
                  ChapterCompanion.insert(id: id, title: title),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChapterTable, ChapterData>(table),
                  $$ChapterTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recordNoteRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (recordNoteRefs) db.recordNote],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recordNoteRefs)
                    await $_getPrefetchedDataByColumns<
                      ChapterData,
                      $ChapterTable,
                      RecordNoteData,
                      $RecordNoteTable
                    >(
                      currentTable: table,
                      referencedTable: $$ChapterTableReferences
                          ._recordNoteRefsTable(db),
                      managerFromTypedResult: (p0) => $$ChapterTableReferences(
                        db,
                        table,
                        p0,
                      ).recordNoteRefs,
                      currentColumn: 'id',
                      referencedColumn: 'chapter',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ChapterTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChapterTable,
      ChapterData,
      $$ChapterTableFilterComposer,
      $$ChapterTableOrderingComposer,
      $$ChapterTableAnnotationComposer,
      $$ChapterTableCreateCompanionBuilder,
      $$ChapterTableUpdateCompanionBuilder,
      (ChapterData, $$ChapterTableReferences),
      ChapterData,
      PrefetchHooks Function({bool recordNoteRefs})
    >;
typedef $$RecordNoteTableCreateCompanionBuilder =
    RecordNoteCompanion Function({
      Value<int> id,
      Value<String?> title,
      Value<bool> isSynced,
      required String content,
      required int chapter,
      Value<DateTime?> lastFetchedAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> createdAt,
    });
typedef $$RecordNoteTableUpdateCompanionBuilder =
    RecordNoteCompanion Function({
      Value<int> id,
      Value<String?> title,
      Value<bool> isSynced,
      Value<String> content,
      Value<int> chapter,
      Value<DateTime?> lastFetchedAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> createdAt,
    });

final class $$RecordNoteTableReferences
    extends BaseReferences<_$AppDatabase, $RecordNoteTable, RecordNoteData> {
  $$RecordNoteTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChapterTable _chapterTable(_$AppDatabase db) =>
      db.chapter.createAlias('record_note__chapter__chapter__id');

  $$ChapterTableProcessedTableManager get chapter {
    final $_column = $_itemColumn<int>('chapter')!;

    final manager = $$ChapterTableTableManager(
      $_db,
      $_db.chapter,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecordNoteTableFilterComposer
    extends Composer<_$AppDatabase, $RecordNoteTable> {
  $$RecordNoteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFetchedAt => $composableBuilder(
    column: $table.lastFetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ChapterTableFilterComposer get chapter {
    final $$ChapterTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapter,
      referencedTable: $db.chapter,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChapterTableFilterComposer(
            $db: $db,
            $table: $db.chapter,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordNoteTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordNoteTable> {
  $$RecordNoteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFetchedAt => $composableBuilder(
    column: $table.lastFetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChapterTableOrderingComposer get chapter {
    final $$ChapterTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapter,
      referencedTable: $db.chapter,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChapterTableOrderingComposer(
            $db: $db,
            $table: $db.chapter,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordNoteTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordNoteTable> {
  $$RecordNoteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get lastFetchedAt => $composableBuilder(
    column: $table.lastFetchedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ChapterTableAnnotationComposer get chapter {
    final $$ChapterTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapter,
      referencedTable: $db.chapter,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChapterTableAnnotationComposer(
            $db: $db,
            $table: $db.chapter,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordNoteTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordNoteTable,
          RecordNoteData,
          $$RecordNoteTableFilterComposer,
          $$RecordNoteTableOrderingComposer,
          $$RecordNoteTableAnnotationComposer,
          $$RecordNoteTableCreateCompanionBuilder,
          $$RecordNoteTableUpdateCompanionBuilder,
          (RecordNoteData, $$RecordNoteTableReferences),
          RecordNoteData,
          PrefetchHooks Function({bool chapter})
        > {
  $$RecordNoteTableTableManager(_$AppDatabase db, $RecordNoteTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordNoteTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordNoteTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordNoteTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<DateTime?> lastFetchedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => RecordNoteCompanion(
                id: id,
                title: title,
                isSynced: isSynced,
                content: content,
                chapter: chapter,
                lastFetchedAt: lastFetchedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                required String content,
                required int chapter,
                Value<DateTime?> lastFetchedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => RecordNoteCompanion.insert(
                id: id,
                title: title,
                isSynced: isSynced,
                content: content,
                chapter: chapter,
                lastFetchedAt: lastFetchedAt,
                updatedAt: updatedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecordNoteTable, RecordNoteData>(table),
                  $$RecordNoteTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chapter = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (chapter) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapter,
                                referencedTable: $$RecordNoteTableReferences
                                    ._chapterTable(db),
                                referencedColumn: $$RecordNoteTableReferences
                                    ._chapterTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecordNoteTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordNoteTable,
      RecordNoteData,
      $$RecordNoteTableFilterComposer,
      $$RecordNoteTableOrderingComposer,
      $$RecordNoteTableAnnotationComposer,
      $$RecordNoteTableCreateCompanionBuilder,
      $$RecordNoteTableUpdateCompanionBuilder,
      (RecordNoteData, $$RecordNoteTableReferences),
      RecordNoteData,
      PrefetchHooks Function({bool chapter})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChapterTableTableManager get chapter =>
      $$ChapterTableTableManager(_db, _db.chapter);
  $$RecordNoteTableTableManager get recordNote =>
      $$RecordNoteTableTableManager(_db, _db.recordNote);
}
