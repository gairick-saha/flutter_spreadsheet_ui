import 'package:flutter/material.dart';

class FlutterSpreadsheetUIConfig {
  const FlutterSpreadsheetUIConfig({
    this.cellWidth = 100,
    this.cellHeight = kMinInteractiveDimension,
    this.freezedCellWidth,
    this.headerHeight,
    this.onResizeColumnWidth,
    this.onResizeRowHeight,
  });

  final double cellWidth;
  final double cellHeight;
  final double? freezedCellWidth;
  final double? headerHeight;
  final ValueChanged? onResizeColumnWidth;
  final ValueChanged? onResizeRowHeight;
}