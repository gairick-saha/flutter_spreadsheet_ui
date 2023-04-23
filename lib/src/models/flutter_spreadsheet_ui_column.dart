import 'package:flutter/material.dart';

import '../../flutter_spreadsheet_ui.dart';

class FlutterSpreadsheetUIColumn {
  FlutterSpreadsheetUIColumn({
    String? id,
    required this.cellBuilder,
    this.width,
    this.contentAlignment,
    this.onCellPressed,
  }) : _id = id;

  final FlutterSpreadsheetUICellBuilder cellBuilder;
  final double? width;
  final Alignment? contentAlignment;
  final VoidCallback? onCellPressed;
  final String? _id;

  String? get id => _id;

  FlutterSpreadsheetUIColumn copyWith({
    double? width,
    Alignment? contentAlignment,
    FlutterSpreadsheetUICellBuilder? cellBuilder,
    VoidCallback? onCellPressed,
    String? id,
  }) =>
      FlutterSpreadsheetUIColumn(
        width: width ?? this.width,
        cellBuilder: cellBuilder ?? this.cellBuilder,
        contentAlignment: contentAlignment ?? this.contentAlignment,
        onCellPressed: onCellPressed ?? this.onCellPressed,
        id: id ?? this.id,
      );

  Widget? toWidget(
    BuildContext context,
    String columnId,
  ) =>
      cellBuilder(
        context,
        copyWith(id: id ?? columnId).id!,
      );
}
