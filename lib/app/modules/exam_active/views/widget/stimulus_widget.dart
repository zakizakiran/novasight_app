import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/math_semantic_serializer.dart';
import '../../../../core/utils/table_mode.dart';
import '../../../../data/models/student_quiz_model.dart';
import '../../../subject/views/widgets/table_mode_switch_widget.dart';
import 'accessible_sentence_widget.dart';

class StimulusWidget extends StatelessWidget {
  final QuestionStimulusResponse stimulus;
  final Rx<TableMode> selectedMode;

  const StimulusWidget({
    super.key,
    required this.stimulus,
    required this.selectedMode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: switch (stimulus.type) {
        StimulusType.text => _buildText(context),
        StimulusType.table => _buildTable(context),
        StimulusType.image => _buildImage(context),
      },
    );
  }

  Widget _buildText(BuildContext context) {
    return AccessibleSentenceWidget(
      text: stimulus.readableText,
      style: Theme.of(context).textTheme.bodyLarge  ?.copyWith(
        color: ColorConstant.textDarkGreyColor,
    ));
  }


  Widget _buildImage(BuildContext context) {
    final specification = stimulus.specification;

    if (specification is! ImageSpecification) {
      return const SizedBox.shrink();
    }

    return Semantics(
      image: true,
      container: true,
      label: MathSemanticSerializer.toAccessibleText(
        specification.description,
      ),
      excludeSemantics: true,
      child: Center(
        child: SvgPicture.string(
          specification.svg,
          excludeFromSemantics: true,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    final specification = stimulus.specification;

    if (specification is! TableSpecification) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final mode = selectedMode.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Table title
          Text(
            specification.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorConstant.textDarkGreyColor,
            ),
          ),

          const SizedBox(height: 12),

          // Mode selector
          TableModeSwitchWidget(
            selectedMode: mode,
            onChanged: (value) {
              selectedMode.value = value;
            },
          ),

          const SizedBox(height: 16),

          // Table content
          switch (mode) {
            TableMode.cell => _buildCellMode(
              context,
              specification: specification,
            ),
            TableMode.sentence => _buildSentenceMode(
              context,
              specification: specification,
            ),
          },
        ],
      );
    });
  }

  Widget _buildCellMode(
      BuildContext context, {
        required TableSpecification specification,
      }) {
    final semanticTable = stimulus.table;
    final semanticColumns =
        semanticTable?.columns ?? specification.columns;

    final semanticRows =
        semanticTable?.rows ?? specification.rows;

    return _buildDataTable(
      context,
      specification: specification,
      semanticColumns: semanticColumns,
      semanticRows: semanticRows,
      excludeTableSemantics: false,
    );
  }

  Widget _buildSentenceMode(
      BuildContext context, {
        required TableSpecification specification,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: _buildDataTable(
            context,
            specification: specification,
            semanticColumns: const [],
            semanticRows: const [],
            excludeTableSemantics: true,
          ),
        ),

        const SizedBox(height: 8),
        _buildSentenceSemantics(
          semantic: stimulus.readableText,
        ),
      ],
    );
  }

  Widget _buildDataTable(
      BuildContext context, {
        required TableSpecification specification,
        required List<String> semanticColumns,
        required List<List<String>> semanticRows,
        required bool excludeTableSemantics,
      }) {
    final theme = Theme.of(context);

    final columns = specification.columns;
    final rows = specification.rows;

    final dataTable = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.sizeOf(context).width - 66,
        ),
        child: DataTable(
          horizontalMargin: 12,
          columnSpacing: 20,
          headingRowHeight: 52,
          dataRowMinHeight: 48,
          dataRowMaxHeight: 100,
          border: TableBorder.all(
            color: theme.colorScheme.outline,
            borderRadius: BorderRadius.circular(Dimens.radius),
          ),
          headingRowColor: WidgetStatePropertyAll(
            theme.colorScheme.surfaceContainerHighest,
          ),
          columns: List.generate(
            columns.length,
                (columnIndex) {
              final column = columns[columnIndex];

              return DataColumn(
                label: Semantics(
                  container: true,
                  label: 'Kolom ${columnIndex + 1}: '
                      '${MathSemanticSerializer.toAccessibleText(
                    columnIndex < semanticColumns.length
                        ? semanticColumns[columnIndex]
                        : column,
                  )}',
                  child: ExcludeSemantics(
                    child: _buildLatexText(
                      column,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.textDarkGreyColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          rows: List.generate(
            rows.length,
                (rowIndex) {
              final row = rows[rowIndex];

              return DataRow(
                cells: List.generate(
                  columns.length,
                      (columnIndex) {
                    final value = columnIndex < row.length
                        ? row[columnIndex]
                        : '';

                    final semanticValue =
                    rowIndex < semanticRows.length &&
                        columnIndex <
                            semanticRows[rowIndex].length
                        ? semanticRows[rowIndex][columnIndex]
                        : value;

                    final columnName = columnIndex <
                        semanticColumns.length
                        ? semanticColumns[columnIndex]
                        : columns[columnIndex];

                    return DataCell(
                      Semantics(
                        container: true,
                        label: 'Baris ${rowIndex + 1}, '
                            'Kolom ${columnIndex + 1}. '
                            '${MathSemanticSerializer.toAccessibleText(columnName)}: '
                            '${MathSemanticSerializer.toAccessibleText(semanticValue)}',
                        excludeSemantics: true,
                        child: ExcludeSemantics(
                          child: _buildLatexText(
                            value,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: ColorConstant.textDarkGreyColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    if (excludeTableSemantics) {
      return ExcludeSemantics(
        child: dataTable,
      );
    }

    return dataTable;
  }

  Widget _buildSentenceSemantics({
    required String semantic,
  }) {
    final sentences = semantic
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((sentence) => sentence.trim())
        .where((sentence) => sentence.isNotEmpty)
        .toList();

    if (sentences.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: sentences.map((sentence) {
        return Semantics(
          container: true,
          label: MathSemanticSerializer.toAccessibleText(sentence),
          excludeSemantics: true,
          child: const SizedBox(
            width: 1,
            height: 1,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLatexText(
      String text, {
        TextStyle? style,
      }) {
    final pattern = RegExp(r'\$(.+?)\$');
    final matches = pattern.allMatches(text).toList();

    if (matches.isEmpty) {
      return Text(
        text,
        style: style,
      );
    }

    final spans = <InlineSpan>[];
    var lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
          ),
        );
      }
      final latex = match.group(1);
      if (latex != null && latex.isNotEmpty) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Math.tex(
              latex,
              mathStyle: MathStyle.text,
              textStyle: style,
            ),
          ),
        );
      }

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: style,
        children: spans,
      ),
    );
  }
}