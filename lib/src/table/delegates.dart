part of 'table.dart';

mixin SpreadsheetUICellDelegateMixin on TwoDimensionalChildDelegate {
  List<SpreadsheetUIColumn> get columns;
  List<SpreadsheetUIRow> get rows;

  int get columnCount;

  int get rowCount;

  int get pinnedColumnCount => 0;

  int get pinnedRowCount => 0;

  SpreadsheetUIColumn buildColumn(int index);

  SpreadsheetUIRow buildRow(int index);

  SpreadsheetUIRowBuilder? get emptyRowBuilder;

  bool isEmptyRow = false;
}

class SpreadsheetUICellBuilderDelegate
    extends TwoDimensionalChildBuilderDelegate
    with SpreadsheetUICellDelegateMixin {
  SpreadsheetUICellBuilderDelegate({
    required List<SpreadsheetUIColumn> columns,
    required List<SpreadsheetUIRow> rows,
    bool addRepaintBoundaries = true,
    SpreadsheetUIColumnBuilder? columnBuilder,
    SpreadsheetUIRowBuilder? rowBuilder,
    SpreadsheetUIRowBuilder? columnRowBuilder,
    SpreadsheetUIRowBuilder? emptyRowBuilder,
    required SpreadsheetUICellBuilder cellBuilder,
    required SpreadsheetUICellBuilder columnCellsBuilder,
    required SpreadsheetUICellBuilder emptyRowCellsBuilder,
    required bool isEmptyRow,
  })  : assert(columns.isNotEmpty),
        assert(rows.isNotEmpty),
        _columns = columns,
        _rows = rows,
        _columnBuilder = (columnBuilder ??
            (int index) => SpreadsheetUIColumn(
                  width: kDefaultColumnWidth,
                )),
        _isEmptyRow = isEmptyRow,
        _rowBuilder = ((int index) {
          if (index == 0) {
            return columnRowBuilder?.call(index) ??
                SpreadsheetUIRow(
                  height: kDefaultRowHeight,
                );
          }

          if (isEmptyRow) {
            return emptyRowBuilder?.call(index) ??
                SpreadsheetUIRow(
                  height: kDefaultRowHeight,
                );
          }

          return rowBuilder?.call(index - 1) ??
              SpreadsheetUIRow(
                height: kDefaultRowHeight,
              );
        }),
        _pinnedColumnCount =
            columns.where((element) => element.isFreezed).length,
        _pinnedRowCount = rows.where((element) => element.isFreezed).length,
        _emptyRowBuilder = emptyRowBuilder,
        super(
          builder: (BuildContext context, ChildVicinity vicinity) {
            final CellIndex cellIndex = vicinity as CellIndex;
            final columnIndex = cellIndex.column;
            final rowIndex = cellIndex.row;

            if (rowIndex == 0) {
              return columnCellsBuilder(context, cellIndex);
            }

            if (isEmptyRow) {
              return emptyRowCellsBuilder(context, cellIndex);
            }

            final CellIndex rowCellIndex =
                CellIndex(row: rowIndex - 1, column: columnIndex);
            return cellBuilder(context, rowCellIndex);
          },
          maxXIndex: columns.length - 1,
          maxYIndex: rows.length - 1,
          addRepaintBoundaries: addRepaintBoundaries,
        );

  @override
  bool get isEmptyRow => _isEmptyRow;
  bool _isEmptyRow;
  set isEmptyRow(bool isEmptyRow) {
    _isEmptyRow = isEmptyRow;
    notifyListeners();
  }

  @override
  List<SpreadsheetUIColumn> get columns => _columns;
  List<SpreadsheetUIColumn> _columns;
  set columns(List<SpreadsheetUIColumn> columns) {
    _columns = columns;
    notifyListeners();
  }

  @override
  List<SpreadsheetUIRow> get rows => _rows;
  List<SpreadsheetUIRow> _rows;
  set rows(List<SpreadsheetUIRow> rows) {
    _rows = rows;
    notifyListeners();
  }

  @override
  SpreadsheetUIRowBuilder? get emptyRowBuilder => _emptyRowBuilder;
  SpreadsheetUIRowBuilder? _emptyRowBuilder;
  set emptyRowBuilder(SpreadsheetUIRowBuilder? widgetBuilder) {
    _emptyRowBuilder = widgetBuilder;
    notifyListeners();
  }

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
