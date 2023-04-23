import 'package:flutter/material.dart';

import '../../flutter_spreadsheet_ui.dart';
import 'base_cell.dart';

class BaseRow extends StatelessWidget {
  const BaseRow({
    Key? key,
    this.row,
    required this.column,
    required this.cellHeight,
    required this.cellWidth,
    required this.columnIndex,
    required this.rowIndex,
    required this.borderDirection,
  }) : super(key: key);

  final FlutterSpreadsheetUIRow? row;
  final FlutterSpreadsheetUIColumn column;
  final double cellHeight;
  final double cellWidth;
  final int columnIndex;
  final int rowIndex;
  final BorderDirection borderDirection;

  @override
  Widget build(BuildContext context) {
    if (row != null) {
      final String cellId = 'C$columnIndex, R${rowIndex + 1}';
      return FlutterSpreadsheetUIBaseCell(
        onTap: row!.cells[columnIndex].onCellPressed,
        cellHeight: cellHeight,
        cellWidth: cellWidth,
        alignment: column.contentAlignment ?? Alignment.center,
        borderDirection: borderDirection,
        onFocusChanged: (bool hasFocus) {
          print("Focus changed for $cellId : $hasFocus");
        },
        child: row!.cells[columnIndex].toWidget(context, cellId),
      );
    } else {
      final String cellId = 'C$columnIndex, R$rowIndex';
      return FlutterSpreadsheetUIBaseCell(
        cellHeight: cellHeight,
        cellWidth: cellWidth,
        alignment: column.contentAlignment ?? Alignment.center,
        borderDirection: borderDirection,
        onTap: column.onCellPressed,
        onFocusChanged: (bool hasFocus) {
          print("Focus changed for $cellId : $hasFocus");
        },
        child: column.toWidget(context, cellId),
      );
    }
  }
}
