import 'package:flutter/material.dart';

import '../../flutter_spreadsheet_ui.dart';

class FlutterSpreadsheetUICell {
  FlutterSpreadsheetUICell({
    String? id,
    required this.cellBuilder,
    this.onCellPressed,
  }) : _id = id;

  final VoidCallback? onCellPressed;
  final FlutterSpreadsheetUICellBuilder? cellBuilder;
  final String? _id;

  String? get id => _id;

  FlutterSpreadsheetUICell copyWith({
    VoidCallback? onCellPressed,
    FlutterSpreadsheetUICellBuilder? cellBuilder,
    String? id,
  }) =>
      FlutterSpreadsheetUICell(
        onCellPressed: onCellPressed ?? this.onCellPressed,
        cellBuilder: cellBuilder ?? this.cellBuilder,
        id: id ?? this.id,
      );

  Widget? toWidget<T>(
    BuildContext context,
    String cellId,
  ) {
    return cellBuilder == null
        ? null
        : cellBuilder!(context, copyWith(id: id ?? cellId).id!);
  }
}
