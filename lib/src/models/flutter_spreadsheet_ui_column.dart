import 'package:flutter/material.dart';

import '../../../flutter_spreadsheet_ui.dart';

class FlutterSpreadsheetUIColumn {
  FlutterSpreadsheetUIColumn({
    required this.cellBuilder,
    this.width,
    this.contentAlignment,
    this.onCellPressed,
    this.padding,
    this.margin,
  });

  final FlutterSpreadsheetUICellBuilder cellBuilder;
  final double? width;
  final Alignment? contentAlignment;
  final VoidCallback? onCellPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  late int _columnIndex;

  int get columnIndex => _columnIndex;

  void setColumnIndex(int columnIndex) => _columnIndex = columnIndex;

  FlutterSpreadsheetUIColumn copyWith({
    double? width,
    Alignment? contentAlignment,
    FlutterSpreadsheetUICellBuilder? cellBuilder,
    VoidCallback? onCellPressed,
  }) =>
      FlutterSpreadsheetUIColumn(
        width: width ?? this.width,
        cellBuilder: cellBuilder ?? this.cellBuilder,
        contentAlignment: contentAlignment ?? this.contentAlignment,
        onCellPressed: onCellPressed ?? this.onCellPressed,
      );

  Widget? toWidget(
    BuildContext context,
    String cellId,
  ) =>
      cellBuilder(
        context,
        cellId,
      );
}
