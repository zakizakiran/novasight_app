import 'package:flutter/widgets.dart';
import 'package:novasight_app/app/core/utils/l10n_extension.dart';

enum PublicStatus {

  all("Semua"),
  notDone("Belum Selesai"),
  done("Selesai");

  final String name;
  const PublicStatus(this.name);
}

extension PublicStatusL10n on PublicStatus {
  String localizedName(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case PublicStatus.all:
        return l10n.filterAll;
      case PublicStatus.notDone:
        return l10n.filterNotDone;
      case PublicStatus.done:
        return l10n.filterDone;
    }
  }
}
