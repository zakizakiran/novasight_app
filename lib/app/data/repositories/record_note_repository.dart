import 'package:drift/drift.dart';
import 'package:lydera_app/app/core/network/database.dart';
import 'package:lydera_app/app/data/providers/local/record_note_local_provider.dart';
import 'package:lydera_app/app/data/providers/record_note_remote_provider.dart';

import '../services/connectivity_service.dart';

class RecordNoteRepository {
  final RecordNoteLocalProvider recordNoteLocalProvider;
  final RecordNoteRemoteProvider recordNoteRemoteProvider;
  final ConnectivityService connectivityService;

  RecordNoteRepository({
    required this.recordNoteLocalProvider,
    required this.recordNoteRemoteProvider,
    required this.connectivityService,
  });

  static const cacheDuration = Duration(minutes: 5);

  Future<RecordNoteData?> getNoteByChapterId({
    required int chapterId,
  }) async {
    final localNote = await recordNoteLocalProvider.getNotesByChapterId(chapterId);

    final hasInternet = await connectivityService.hasInternetAccess;

    if (!hasInternet) return localNote;

    if (localNote != null && !localNote.isSynced) {
      return localNote;
    }

    if (localNote?.lastFetchedAt != null) {
      final age = DateTime.now().difference(
        localNote!.lastFetchedAt!,
      );

      if (age < cacheDuration) {
        return localNote;
      }
    }

    try {
      final response = await recordNoteRemoteProvider.getNotesByChapterId(chapterId);

      final remoteNote = response.data;

      if (remoteNote == null) return localNote;

      return await recordNoteLocalProvider.createOrUpdateNote(remoteNote.copyWith(lastFetchedAt: Value(DateTime.now())).toCompanion(true));
    } catch (_) {
      return localNote;
    }
  }

  Future<RecordNoteData> submitNote({
    required RecordNoteCompanion recordNote,
  }) async {
    final localNote = await recordNoteLocalProvider.createOrUpdateNote(recordNote);
    final hasInternet = await connectivityService.hasInternetAccess;

    if (!hasInternet) return localNote;

    try {
      final response = await recordNoteRemoteProvider.createOrUpdateNote(localNote);
      await recordNoteLocalProvider.markAsSynced(localNote.id);

      return response.data;
    } catch (_) {
      return localNote;
    }
  }
}
