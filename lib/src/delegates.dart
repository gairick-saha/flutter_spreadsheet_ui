part of 'ui.dart';

mixin FlutterSpreadsheetUICellDelegateMixin on TwoDimensionalChildDelegate {
  int get columnCount;

  int get rowCount;

  int get pinnedColumnCount => 0;

  int get pinnedRowCount => 0;

  FlutterSpreadsheetUIColumn buildColumn(int index);

  FlutterSpreadsheetUIRow buildRow(int index);
}

class FlutterSpreadsheetUICellBuilderDelegate
    extends TwoDimensionalChildBuilderDelegate
    with FlutterSpreadsheetUICellDelegateMixin {
  FlutterSpreadsheetUICellBuilderDelegate({
    required int columnCount,
    required int rowCount,
    int pinnedColumnCount = 0,
    int pinnedRowCount = 0,
    super.addRepaintBoundaries,
    required FlutterSpreadsheetUIColumnBuilder columnBuilder,
    required FlutterSpreadsheetUIRowBuilder rowBuilder,
    required FlutterSpreadsheetUICellBuilder cellBuilder,
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

  final FlutterSpreadsheetUIColumnBuilder _columnBuilder;
  @override
  FlutterSpreadsheetUIColumn buildColumn(int index) => _columnBuilder(index);

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

  final FlutterSpreadsheetUIRowBuilder _rowBuilder;
  @override
  FlutterSpreadsheetUIRow buildRow(int index) => _rowBuilder(index);

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
