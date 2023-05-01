import 'package:flutter/material.dart';

class FlutterSpreadsheetUIConfig {
  const FlutterSpreadsheetUIConfig({
    this.cellWidth = 100,
    this.cellHeight = kMinInteractiveDimension,
    this.freezedColumnWidth,
    this.headerHeight,
    this.freezedColumnExtendedByWidth = 50,
    this.freezeFirstColumn = true,
    this.freezeFirstRow = true,
  });

  final double cellWidth, cellHeight, freezedColumnExtendedByWidth;
  final double? freezedColumnWidth, headerHeight;
  final bool freezeFirstColumn, freezeFirstRow;
}
