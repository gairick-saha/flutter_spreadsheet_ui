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
    this.onCellWidthDragStart,
    this.onCellWidthDrag,
    this.onCellWidthDragEnd,
    required this.onCellHeightDrag,
    required this.onCellHeightDragEnd,
  }) : super(key: key);

  final FlutterSpreadsheetUIRow? row;
  final FlutterSpreadsheetUIColumn column;
  final double cellHeight;
  final double cellWidth;
  final int columnIndex;
  final int rowIndex;
  final BorderDirection borderDirection;
  final Function(String cellId)? onCellWidthDragStart;
  final Function(double updatedCellWidth, String cellId)? onCellWidthDrag;
  final Function(double updatedCellWidth, String cellId)? onCellWidthDragEnd;
  final Function(double updatedCellHeight, String cellId) onCellHeightDrag;
  final Function(double updatedCellHeight, String cellId) onCellHeightDragEnd;

  @override
  Widget build(BuildContext context) {
    late String cellId;
    if (row != null) {
      cellId = 'C$columnIndex, R${rowIndex + 1}';
    } else {
      cellId = 'C$columnIndex, R$rowIndex';
    }

    return FlutterSpreadsheetUIBaseCell(
      cellHeight: cellHeight,
      cellWidth: cellWidth,
      alignment: column.contentAlignment ?? Alignment.center,
      borderDirection: borderDirection,
      onTap: row?.cells[columnIndex].onCellPressed ?? column.onCellPressed,
      onCellWidthDragStart: onCellWidthDragStart == null
          ? null
          : () => onCellWidthDragStart!(cellId),
      onCellWidthDrag: onCellWidthDrag == null
          ? null
          : (updatedCellWidth) => onCellWidthDrag!(
                updatedCellWidth,
                cellId,
              ),
      onCellWidthDragEnd: onCellWidthDragEnd == null
          ? null
          : (updatedCellWidth) => onCellWidthDragEnd!(
                updatedCellWidth,
                cellId,
              ),
      onCellHeightDrag: (updatedCellHeight) => onCellHeightDrag(
        updatedCellHeight,
        cellId,
      ),
      onCellHeightDragEnd: (updatedCellHeight) => onCellHeightDragEnd(
        updatedCellHeight,
        cellId,
      ),
      onFocusChanged: (bool hasFocus) {
        // Todo : "Need to implement"
        // log("Focus changed for $cellId : $hasFocus");
      },
      child: row?.cells[columnIndex].toWidget(
            context,
            cellId,
          ) ??
          column.toWidget(
            context,
            cellId,
          ),
    );
  }
}
