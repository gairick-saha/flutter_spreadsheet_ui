import 'package:flutter/material.dart';

import '../../flutter_spreadsheet_ui.dart';

class FlutterSpreadsheetUICell {
  FlutterSpreadsheetUICell({
    required this.cellBuilder,
    this.onCellPressed,
  });

  final VoidCallback? onCellPressed;
  final FlutterSpreadsheetUICellBuilder? cellBuilder;

  String? _id;

  String? get cellId => _id;

  void setId(String? value) {
    _id = value;
  }

  FlutterSpreadsheetUICell copyWith({
    VoidCallback? onCellPressed,
    FlutterSpreadsheetUICellBuilder? cellBuilder,
  }) =>
      FlutterSpreadsheetUICell(
        onCellPressed: onCellPressed ?? this.onCellPressed,
        cellBuilder: cellBuilder ?? this.cellBuilder,
      );

  Widget? toWidget<T>(
    BuildContext context,
    String cellId,
  ) {
    setId(cellId);
    return cellBuilder == null ? null : cellBuilder!(context, cellId);
  }
}
