import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../flutter_spreadsheet_ui.dart';
import '../models/flutter_spreadsheet_ui_state.dart';
import '../scroll/scroll_behaviour.dart';

part 'base_cell.dart';
part 'freezed_column.dart';
part 'non_freezed_columns.dart';
part 'table_header.dart';
part 'table_body.dart';

typedef _CellIdCallback = void Function(String cellId);
typedef _CellIdAndDragupdateDetailsCallback = void Function(
  String cellId,
  DragUpdateDetails dragUpdateDetails,
);

typedef StartColumnWidthResizeCallback = _CellIdCallback;
typedef EndColumnWidthResizeCallback = _CellIdCallback;
typedef ColumnWidthResizeUpdateCallback = _CellIdAndDragupdateDetailsCallback;

typedef StartRowHeightResizeCallback = _CellIdCallback;
typedef EndRowHeightResizeCallback = _CellIdCallback;
typedef RowHeightResizeUpdateCallback = _CellIdAndDragupdateDetailsCallback;

typedef FlutterSpreadsheetUITableHeader = _TableHeader;
typedef FlutterSpreadsheetUITableBody = _TableBody;

enum BorderDirection {
  topBottomLeftRight,
  bottomLeftRight,
  topBottomRight,
  bottomRight,
}
