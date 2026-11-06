
import 'package:flutter/material.dart';

class AccessibleSentenceWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AccessibleSentenceWidget({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final sentences = text
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((sentence) => sentence.trim())
        .where((sentence) => sentence.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sentences.map((sentence) {
        return Semantics(
          container: true,
          label: sentence,
          excludeSemantics: true,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              sentence,
              style: style,
            ),
          ),
        );
      }).toList(),
    );
  }
}
