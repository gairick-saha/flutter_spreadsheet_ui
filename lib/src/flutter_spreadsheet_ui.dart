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
      horizontalDetails:
          config?.horizontalDetails ?? const ScrollableDetails.horizontal(),
      verticalDetails:
          config?.verticalDetails ?? const ScrollableDetails.vertical(),
      columns: columns
          .map((e) => SpreadsheetUIColumn(
                width: e.width,
                isFreezed: e.isFreezed,
              ))
          .toList(),
      rows: rows
          .map((e) => SpreadsheetUIRow(
                isFreezed: config?.pinnedFirstRow ?? false,
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
        isFreezed: config?.pinnedFirstRow ?? false,
        decoration: SpreadsheetUIRowDecoration(
          color: config?.columnRowColor ?? config?.backgroundColor,
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
          color: rows[index].color ?? config?.backgroundColor,
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

        return row.toWidget(
          context,
          cellIndex,
          column.contentAlignment,
          column.contentPadding,
        );
      },
    );
  }
}
