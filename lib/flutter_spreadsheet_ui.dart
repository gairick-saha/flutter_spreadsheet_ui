library flutter_flutter_spreadsheet_ui;

import 'package:flutter/material.dart';

export 'src/flutter_spreadsheet_ui.dart';
export 'src/models/flutter_spreadsheet_ui_config.dart';
export 'src/models/flutter_spreadsheet_ui_column.dart';
export 'src/models/flutter_spreadsheet_ui_row.dart';
export 'src/models/flutter_spreadsheet_ui_cell.dart';

typedef FlutterSpreadsheetUICellBuilder = Widget? Function(
  BuildContext context,
  String cellId,
);

typedef FlutterSpreadsheetUIColumnWidthResizeCallback = void Function(
  int columnIndex,
  double updatedWidth,
);

typedef FlutterSpreadsheetUIRowHeightResizeCallback = void Function(
  int rowIndex,
  double updatedHeight,
);
