import 'package:flutter/material.dart';
import 'package:flutter_spreadsheet_ui/flutter_spreadsheet_ui.dart';

part 'config.dart';
part 'flutter_spreadsheet_ui_column.dart';
part 'flutter_spreadsheet_ui_row.dart';

class FlutterSpreadsheetUI extends StatelessWidget {
  const FlutterSpreadsheetUI({
    Key? key,
    this.config,
    required this.columns,
    required this.rows,
  }) : super(key: key);

  final FlutterSpreadsheetUIConfig? config;
  final List<FlutterSpreadsheetUIColumn> columns;
  final List<FlutterSpreadsheetUIRow> rows;

  @override
  Widget build(BuildContext context) {
    return SpreadsheetUI(
      columns: columns.map((e) => SpreadsheetUIColumn(width: 200)).toList(),
      rows: rows
          .map((e) => SpreadsheetUIRow(
                isFreezed: false,
                height: e.height,
              ))
          .toList(),
      freezeColumnRow: config?.pinnedFirstRow ?? false,
      diagonalDragBehavior: DiagonalDragBehavior.none,
      columnBuilder: (int index) => SpreadsheetUIColumn(
        width: columns[index].width,
        decoration: SpreadsheetUIColumnDecoration(
          color: columns[index].color,
          border: SpreadsheetUIColumnBorder(
            left: index == 0
                ? (columns[index].borderSide ??
                    config?.borderSide ??
                    BorderSide(
                      color: config?.borderColor ??
                          Theme.of(context).disabledColor,
                    ))
                : BorderSide.none,
            right: columns[index].borderSide ??
                config?.borderSide ??
                BorderSide(
                  color: config?.borderColor ?? Theme.of(context).disabledColor,
                ),
          ),
        ),
      ),
      columnRowBuilder: (int index) => SpreadsheetUIRow(
        height: config?.columnRowHeight ?? kDefaultRowHeight,
        isFreezed: true,
        decoration: SpreadsheetUIRowDecoration(
          color: config?.columnRowColor,
          border: SpreadsheetUIRowBorder(
            top: config?.borderSide ??
                BorderSide(
                  color: config?.borderColor ?? Theme.of(context).disabledColor,
                ),
            bottom: config?.borderSide ??
                BorderSide(
                  color: config?.borderColor ?? Theme.of(context).disabledColor,
                ),
          ),
        ),
      ),
      columnCellsBuilder: (context, cellIndex) {
        final int columnIndex = cellIndex.column;
        final column = columns[columnIndex];
        return column.toWidget(context, cellIndex);
      },
      rowBuilder: (int index) => SpreadsheetUIRow(
        height: rows[index].height,
        decoration: SpreadsheetUIRowDecoration(
          border: SpreadsheetUIRowBorder(
            bottom: rows[index].borderSide ??
                config?.borderSide ??
                BorderSide(
                  color: config?.borderColor ?? Theme.of(context).disabledColor,
                ),
          ),
        ),
      ),
      cellBuilder: (BuildContext context, CellIndex cellIndex) {
        final int rowIndex = cellIndex.row;
        final row = rows[rowIndex];

        final int columnIndex = cellIndex.column;
        final column = columns[columnIndex];

        return Align(
          alignment: column.contentAlignment,
          child: row.toWidget(context, cellIndex),
        );
      },
      emptyRowBuilder: (int index) => SpreadsheetUIRow(
        height: config?.emptyRowBuilder?.height ?? kDefaultRowHeight,
        isFreezed: false,
        decoration: SpreadsheetUIRowDecoration(
          color: config?.emptyRowBuilder?.color,
          border: SpreadsheetUIRowBorder(
            bottom: config?.emptyRowBuilder?.borderSide ??
                BorderSide(
                  color: config?.borderColor ?? Theme.of(context).disabledColor,
                ),
          ),
        ),
      ),
      emptyRowCellsBuilder: (context, cellIndex) {
        return Align(
          alignment: Alignment.center,
          child: config?.emptyRowBuilder?.builder?.call(context) ??
              const Text('No data'),
        );
      },
    );
  }
}
