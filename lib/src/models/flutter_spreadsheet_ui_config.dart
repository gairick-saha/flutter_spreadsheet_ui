import 'package:flutter/material.dart';

class FlutterSpreadsheetUIConfig {
  const FlutterSpreadsheetUIConfig({
    this.cellWidth = 110,
    this.cellHeight = kMinInteractiveDimension,
    this.freezedColumnWidth,
    this.headerHeight,
    this.freezedColumnExtendedByWidth = 50,
    this.freezeFirstColumn = true,
    this.freezeFirstRow = true,
    this.enableColumnWidthDrag = false,
    this.enableRowHeightDrag = false,
    this.borderWidth = 1.5,
    this.borderColor,
    this.selectionColor,
  });

  final double cellWidth, cellHeight, freezedColumnExtendedByWidth, borderWidth;
  final double? freezedColumnWidth, headerHeight;
  final bool freezeFirstColumn,
      freezeFirstRow,
      enableColumnWidthDrag,
      enableRowHeightDrag;
  final Color? borderColor, selectionColor;
}
