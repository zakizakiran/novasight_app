
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

class CommonHtmlTableRenderer extends StatelessWidget {
  const CommonHtmlTableRenderer({
    super.key,
    required this.html,
    this.semanticLabel,
    this.borderColor,
    this.headerBackgroundColor,
    this.cellPadding = const EdgeInsets.all(8),
    this.minRowHeight = 40,
    this.textStyle,
    this.headerTextStyle,
  });

  final String html;
  final String? semanticLabel;
  final Color? borderColor, headerBackgroundColor;
  final EdgeInsets cellPadding;
  final double minRowHeight;
  final TextStyle? textStyle, headerTextStyle;

  @override
  Widget build(BuildContext context) {
    final table = html_parser.parse(html).querySelector('table');
    if (table == null) return const SizedBox.shrink();

    final rows = table.querySelectorAll('tr').where(
          (row) => _nearestTable(row) == table,
    ).toList();

    if (rows.isEmpty) return const SizedBox.shrink();

    final bodyStyle = textStyle ?? DefaultTextStyle.of(context).style;
    final theme = Theme.of(context);
    final config = _TableStyle(
      bodyText: bodyStyle,
      headerText: headerTextStyle ?? bodyStyle.copyWith(fontWeight: FontWeight.bold),
      borderColor: borderColor ?? theme.colorScheme.outline,
      headerBackground: headerBackgroundColor,
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          if (!width.isFinite || width <= 0) {
            return const SizedBox.shrink();
          }

          final grid = _buildGrid(rows);
          if (grid.columnCount == 0) {
            return const SizedBox.shrink();
          }

          return _buildTable(
            grid: grid,
            width: width,
            config: config,
            direction: Directionality.of(context),
            scaler: MediaQuery.textScalerOf(context),
          );
        },
      ),
    );
  }

  dom.Element? _nearestTable(dom.Element element) {
    dom.Element? current = element;

    while (current != null) {
      if (current.localName == 'table') return current;
      current = current.parent;
    }

    return null;
  }

  Widget _buildTable({
    required _HtmlTableGrid grid,
    required double width,
    required _TableStyle config,
    required TextDirection direction,
    required TextScaler scaler,
  }) {
    final columnWidth = width / grid.columnCount;
    final heights = _calculateRowHeights(
      grid, columnWidth, config, direction, scaler,
    );
    final offsets = _calculateRowOffsets(heights);

    return SizedBox(
      width: width,
      height: offsets.last,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          for (final cell in grid.cells)
            _buildCell(
              cell, grid, columnWidth, offsets, config, direction, scaler,
            ),
        ],
      ),
    );
  }

  Widget _buildCell(
      _HtmlTableCell cell,
      _HtmlTableGrid grid,
      double columnWidth,
      List<double> offsets,
      _TableStyle config,
      TextDirection direction,
      TextScaler scaler,
      ) {
    final endRow = math.min(grid.rowCount, cell.row + cell.rowSpan);

    return Positioned(
      left: columnWidth * cell.column,
      top: offsets[cell.row],
      width: columnWidth * cell.colSpan,
      height: offsets[endRow] - offsets[cell.row],
      child: Semantics(
        container: true,
        header: cell.isHeader,
        sortKey: OrdinalSortKey(
          (cell.row * grid.columnCount + cell.column).toDouble(),
        ),
        label: _cellLabel(cell, grid),
        child: ExcludeSemantics(
          child: Container(
            padding: cellPadding,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: cell.isHeader ? config.headerBackground : null,
              border: Border.all(color: config.borderColor, width: 0.5),
            ),
            child: RichText(
              text: TextSpan(
                style: _cellStyle(cell, config),
                children: cell.spans,
              ),
              softWrap: true,
              overflow: TextOverflow.clip,
              textScaler: scaler,
              textDirection: direction,
            ),
          ),
        ),
      ),
    );
  }

  List<double> _calculateRowHeights(
      _HtmlTableGrid grid,
      double columnWidth,
      _TableStyle config,
      TextDirection direction,
      TextScaler scaler,
      ) {
    final heights = List<double>.filled(grid.rowCount, minRowHeight);

    for (final cell in grid.cells.where((c) => c.rowSpan == 1)) {
      heights[cell.row] = math.max(
        heights[cell.row],
        _measureHeight(
          cell, columnWidth * cell.colSpan, config, direction, scaler,
        ),
      );
    }

    final spanningCells = grid.cells.where((c) => c.rowSpan > 1).toList();

    for (var pass = 0; pass < spanningCells.length; pass++) {
      var changed = false;

      for (final cell in spanningCells) {
        final endRow = math.min(grid.rowCount, cell.row + cell.rowSpan);
        final rowCount = endRow - cell.row;
        if (rowCount <= 0) continue;

        final required = _measureHeight(
          cell, columnWidth * cell.colSpan, config, direction, scaler,
        );

        final current = heights
            .sublist(cell.row, endRow)
            .fold<double>(0, (sum, height) => sum + height);

        if (required <= current) continue;

        final extra = (required - current) / rowCount;
        for (var row = cell.row; row < endRow; row++) {
          heights[row] += extra;
        }
        changed = true;
      }

      if (!changed) break;
    }

    return heights;
  }

  double _measureHeight(
      _HtmlTableCell cell,
      double width,
      _TableStyle config,
      TextDirection direction,
      TextScaler scaler,
      ) {
    final innerWidth = math.max(1.0, width - cellPadding.horizontal - 2);

    final painter = TextPainter(
      text: TextSpan(
        style: _cellStyle(cell, config),
        children: cell.spans,
      ),
      textDirection: direction,
      textScaler: scaler,
    )..layout(maxWidth: innerWidth);

    return math.max(
      minRowHeight,
      painter.height + cellPadding.vertical + 2,
    );
  }

  TextStyle _cellStyle(_HtmlTableCell cell, _TableStyle config) =>
      cell.isHeader ? config.headerText : config.bodyText;

  List<double> _calculateRowOffsets(List<double> heights) {
    final offsets = List<double>.filled(heights.length + 1, 0);

    for (var i = 0; i < heights.length; i++) {
      offsets[i + 1] = offsets[i] + heights[i];
    }

    return offsets;
  }

  _HtmlTableGrid _buildGrid(List<dom.Element> rows) {
    final occupied = <int, Set<int>>{};
    final cells = <_HtmlTableCell>[];
    var columnCount = 0;

    for (var row = 0; row < rows.length; row++) {
      var column = 0;

      final elements = rows[row].children.where(
            (element) =>
        element.localName == 'td' || element.localName == 'th',
      );

      for (final element in elements) {
        while (occupied[row]?.contains(column) ?? false) {
          column++;
        }

        final colSpan = _readSpan(
          element.attributes['colspan'],
          rows.length,
        );

        final rowSpan = _readRowSpan(element, rows, row);

        final cell = _HtmlTableCell(
          row: row,
          column: column,
          rowSpan: rowSpan,
          colSpan: colSpan,
          isHeader: element.localName == 'th' || row == 0,
          semanticText: _normalizeText(element.text),
          spans: _parseInlineNodes(element.nodes, const TextStyle()),
        );

        cells.add(cell);
        _markOccupied(
          occupied, row, column, rowSpan, colSpan, rows.length,
        );

        column += colSpan;
        columnCount = math.max(columnCount, column);
      }
    }

    return _HtmlTableGrid(
      cells: cells,
      rowCount: rows.length,
      columnCount: columnCount,
    );
  }

  int _readRowSpan(
      dom.Element cell,
      List<dom.Element> rows,
      int row,
      ) {
    final value = cell.attributes['rowspan'];
    final parsed = int.tryParse(value ?? '');

    if (parsed == 0) {
      final group = _rowGroup(cell);
      var remaining = 0;

      for (var i = row; i < rows.length; i++) {
        if (_rowGroup(rows[i]) != group) break;
        remaining++;
      }

      return math.max(1, remaining);
    }

    final group = _rowGroup(rows[row]);
    var remaining = 0;

    for (var i = row; i < rows.length; i++) {
      if (_rowGroup(rows[i]) != group) break;
      remaining++;
    }

    return _readSpan(value, remaining);
  }

  dom.Element _rowGroup(dom.Element element) {
    dom.Element? current = element;

    while (current != null) {
      final tag = current.localName;
      if (tag == 'thead' || tag == 'tbody' || tag == 'tfoot') {
        return current;
      }
      if (tag == 'table') return current;
      current = current.parent;
    }

    return element;
  }

  void _markOccupied(
      Map<int, Set<int>> occupied,
      int row,
      int column,
      int rowSpan,
      int colSpan,
      int rowCount,
      ) {
    final endRow = math.min(rowCount, row + rowSpan);

    for (var r = row; r < endRow; r++) {
      final columns = occupied.putIfAbsent(r, () => <int>{});

      for (var c = column; c < column + colSpan; c++) {
        columns.add(c);
      }
    }
  }

  int _readSpan(String? value, int maxValue) {
    final parsed = int.tryParse(value ?? '') ?? 1;
    return parsed.clamp(1, math.max(1, maxValue)).toInt();
  }

  String _normalizeText(String text) =>
      text.replaceAll(RegExp(r'\s+'), ' ').trim();

  String _cellLabel(_HtmlTableCell cell, _HtmlTableGrid grid) {
    final span = [
      if (cell.rowSpan > 1) 'mencakup ${cell.rowSpan} baris',
      if (cell.colSpan > 1) 'mencakup ${cell.colSpan} kolom',
    ].join(', ');

    return [
      'Baris ${cell.row + 1}',
      'kolom ${cell.column + 1}',
      if (cell.isHeader) 'header',
      if (!cell.isHeader) ..._columnHeaders(cell, grid),
      cell.semanticText.isEmpty ? 'sel kosong' : cell.semanticText,
      span,
    ].where((part) => part.isNotEmpty).join(', ');
  }

  List<String> _columnHeaders(
      _HtmlTableCell cell,
      _HtmlTableGrid grid,
      ) {
    return grid.cells
        .where((header) =>
    header.isHeader &&
        header.row < cell.row &&
        header.column <= cell.column &&
        header.column + header.colSpan > cell.column)
        .map((header) => header.semanticText)
        .where((text) => text.isNotEmpty)
        .map((text) => 'header kolom $text')
        .toList();
  }

  List<InlineSpan> _parseInlineNodes(
      List<dom.Node> nodes,
      TextStyle inheritedStyle,
      ) {
    final spans = <InlineSpan>[];

    for (final node in nodes) {
      if (node is dom.Text) {
        if (node.data.isNotEmpty) {
          spans.add(TextSpan(text: node.data, style: inheritedStyle));
        }
        continue;
      }

      if (node is! dom.Element) continue;
      final tag = node.localName?.toLowerCase();

      if (tag == 'br') {
        spans.add(const TextSpan(text: '\n'));
        continue;
      }

      final style = _inlineStyle(tag, inheritedStyle);
      final isBlock = tag == 'p' || tag == 'div' || tag == 'li';

      if (isBlock && spans.isNotEmpty) {
        spans.add(const TextSpan(text: '\n'));
      }

      spans.add(TextSpan(
        style: style,
        children: _parseInlineNodes(node.nodes, style),
      ));

      if (isBlock) spans.add(const TextSpan(text: '\n'));
    }

    return spans;
  }

  TextStyle _inlineStyle(String? tag, TextStyle style) {
    switch (tag) {
      case 'b':
      case 'strong':
        return style.copyWith(fontWeight: FontWeight.bold);
      case 'i':
      case 'em':
        return style.copyWith(fontStyle: FontStyle.italic);
      case 'u':
        return style.copyWith(decoration: TextDecoration.underline);
      case 's':
      case 'del':
        return style.copyWith(decoration: TextDecoration.lineThrough);
      case 'sup':
      case 'sub':
        return style.copyWith(fontSize: (style.fontSize ?? 14) * 0.75);
      default:
        return style;
    }
  }
}

class _TableStyle {
  const _TableStyle({
    required this.bodyText,
    required this.headerText,
    required this.borderColor,
    required this.headerBackground,
  });

  final TextStyle bodyText, headerText;
  final Color borderColor;
  final Color? headerBackground;
}

class _HtmlTableCell {
  const _HtmlTableCell({
    required this.row,
    required this.column,
    required this.rowSpan,
    required this.colSpan,
    required this.isHeader,
    required this.semanticText,
    required this.spans,
  });

  final int row, column, rowSpan, colSpan;
  final bool isHeader;
  final String semanticText;
  final List<InlineSpan> spans;
}

class _HtmlTableGrid {
  const _HtmlTableGrid({
    required this.cells,
    required this.rowCount,
    required this.columnCount,
  });

  final List<_HtmlTableCell> cells;
  final int rowCount, columnCount;
}
