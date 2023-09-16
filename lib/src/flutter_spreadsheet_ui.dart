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
                isFreezed:
                    rows.first == e ? config?.pinnedFirstRow ?? false : false,
                height: kDefaultRowHeight,
              ))
          .toList(),
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
            right: (columns[index].borderSide ??
                config?.borderSide ??
                BorderSide(
                  color: config?.borderColor ?? Theme.of(context).disabledColor,
                )),
          ),
        ),
      ),
      rowBuilder: (int index) => SpreadsheetUIRow(
        height: rows[index].height,
        decoration: SpreadsheetUIRowDecoration(
          border: SpreadsheetUIRowBorder(
            left: index == 0
                ? (rows[index].borderSide ??
                    config?.borderSide ??
                    BorderSide(
                      color: config?.borderColor ??
                          Theme.of(context).disabledColor,
                    ))
                : BorderSide.none,
            right: (rows[index].borderSide ??
                config?.borderSide ??
                BorderSide(
                  color: config?.borderColor ?? Theme.of(context).disabledColor,
                )),
          ),
        ),
      ),
      cellBuilder: (BuildContext context, CellIndex cellIndex) {
        final int rowIndex = cellIndex.row;
        final row = rows[rowIndex];

        final int columnIndex = cellIndex.column;
        final column = columns[columnIndex];

        if (rowIndex == 0) {
          return column.toWidget(context, cellIndex);
        }

        return row.toWidget(context, cellIndex);
      },
    );
  }
}
