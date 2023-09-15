import 'dart:collection';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'decoration.dart';
part 'cell.dart';
part 'column.dart';
part 'row.dart';
part 'delegates.dart';
part 'viewport.dart';
part 'flutter_spreadsheet_ui.dart';

typedef FlutterSpreadsheetUIColumnBuilder = FlutterSpreadsheetUIColumn Function(
  int index,
);

typedef FlutterSpreadsheetUIRowBuilder = FlutterSpreadsheetUIRow Function(
  int index,
);

typedef FlutterSpreadsheetUICellBuilder = Function(
  BuildContext context,
  CellIndex cellIndex,
);
