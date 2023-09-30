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
part 'viewport_renderer.dart';
part 'viewport.dart';
part 'spreadsheet_ui.dart';

const EdgeInsetsGeometry kDefaultContentPadding =
    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

typedef SpreadsheetUIColumnBuilder = SpreadsheetUIColumn Function(
  int index,
);

typedef SpreadsheetUIRowBuilder = SpreadsheetUIRow Function(
  int index,
);

typedef SpreadsheetUICellBuilder = Widget Function(
  BuildContext context,
  CellIndex cellIndex,
);
