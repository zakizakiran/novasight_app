import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

Future<void> announceSemantics(
  String message, [
  TextDirection textDirection = TextDirection.ltr,
  Assertiveness assertiveness = Assertiveness.polite,
]) async {
  final view = WidgetsBinding.instance.platformDispatcher.implicitView;
  if (view == null) return;
  await SemanticsService.sendAnnouncement(
    view,
    message,
    textDirection,
    assertiveness: assertiveness,
  );
}
