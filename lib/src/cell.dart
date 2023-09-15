part of 'ui.dart';

@immutable
class CellIndex extends ChildVicinity {
  const CellIndex({
    required int row,
    required int column,
  }) : super(xIndex: column, yIndex: row);

  int get row => yIndex;

  int get column => xIndex;

  @override
  String toString() => '(row: $row, column: $column)';
}

class FlutterSpreadsheetUIParentData extends TwoDimensionalViewportParentData {
  CellIndex get cellIndex => vicinity as CellIndex;
}
