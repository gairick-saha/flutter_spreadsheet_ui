import 'flutter_spreadsheet_ui_cell.dart';

class FlutterSpreadsheetUIRow {
  FlutterSpreadsheetUIRow({
    this.height,
    required this.cells,
  });

  final double? height;
  final List<FlutterSpreadsheetUICell> cells;

  late int _rowIndex;

  int get rowIndex => _rowIndex;

  void setRowIndex(int rowIndex) => _rowIndex = rowIndex;

  FlutterSpreadsheetUIRow copyWith({
    double? height,
    List<FlutterSpreadsheetUICell>? cells,
  }) =>
      FlutterSpreadsheetUIRow(
        height: height ?? this.height,
        cells: cells ?? this.cells,
      );
}
