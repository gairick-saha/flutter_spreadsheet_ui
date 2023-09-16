part of 'table.dart';

mixin SpreadsheetUICellDelegateMixin on TwoDimensionalChildDelegate {
  int get columnCount;

  int get rowCount;

  int get pinnedColumnCount => 0;

  int get pinnedRowCount => 0;

  SpreadsheetUIColumn buildColumn(int index);

  SpreadsheetUIRow buildRow(int index);
}

class SpreadsheetUICellBuilderDelegate
    extends TwoDimensionalChildBuilderDelegate
    with SpreadsheetUICellDelegateMixin {
  SpreadsheetUICellBuilderDelegate({
    required int columnCount,
    required int rowCount,
    int pinnedColumnCount = 0,
    int pinnedRowCount = 0,
    super.addRepaintBoundaries,
    required SpreadsheetUIColumnBuilder columnBuilder,
    required SpreadsheetUIRowBuilder rowBuilder,
    required SpreadsheetUICellBuilder cellBuilder,
  })  : assert(columnCount >= 0),
        assert(rowCount >= 0),
        assert(pinnedColumnCount >= 0),
        assert(pinnedRowCount >= 0),
        assert(pinnedColumnCount <= columnCount),
        assert(pinnedRowCount <= rowCount),
        _rowBuilder = rowBuilder,
        _columnBuilder = columnBuilder,
        _pinnedColumnCount = pinnedColumnCount,
        _pinnedRowCount = pinnedRowCount,
        super(
          builder: (BuildContext context, ChildVicinity vicinity) =>
              cellBuilder(context, vicinity as CellIndex),
          maxXIndex: columnCount - 1,
          maxYIndex: rowCount - 1,
        );

  @override
  int get columnCount => maxXIndex! + 1;
  set columnCount(int value) {
    assert(pinnedColumnCount <= value);
    assert(value >= -1);
    maxXIndex = value - 1;
  }

  final SpreadsheetUIColumnBuilder _columnBuilder;
  @override
  SpreadsheetUIColumn buildColumn(int index) => _columnBuilder(index);

  @override
  int get pinnedColumnCount => _pinnedColumnCount;
  int _pinnedColumnCount;
  set pinnedColumnCount(int value) {
    assert(value >= 0);
    assert(value <= columnCount);
    if (pinnedColumnCount == value) {
      return;
    }
    _pinnedColumnCount = value;
    notifyListeners();
  }

  @override
  int get rowCount => maxYIndex! + 1;
  set rowCount(int value) {
    assert(pinnedRowCount <= value);
    assert(value >= -1);
    maxYIndex = value - 1;
  }

  final SpreadsheetUIRowBuilder _rowBuilder;
  @override
  SpreadsheetUIRow buildRow(int index) => _rowBuilder(index);

  @override
  int get pinnedRowCount => _pinnedRowCount;
  int _pinnedRowCount;
  set pinnedRowCount(int value) {
    assert(value >= 0);
    assert(value <= rowCount);
    if (pinnedRowCount == value) {
      return;
    }
    _pinnedRowCount = value;
    notifyListeners();
  }
}
