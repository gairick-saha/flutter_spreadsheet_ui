import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../flutter_spreadsheet_ui.dart';
import '../models/flutter_spreadsheet_ui_state.dart';
import 'callbacks.dart';

FlutterSpreadsheetUIState useFlutterSpreadsheetUIState({
  required List<FlutterSpreadsheetUIColumn> columns,
  required List<FlutterSpreadsheetUIRow> rows,
  required FlutterSpreadsheetUIConfig config,
}) =>
    use<FlutterSpreadsheetUIState>(
      _FlutterSpreadsheetUIHook(
        columns: columns,
        rows: rows,
        config: config,
      ),
    );

class _FlutterSpreadsheetUIHook extends Hook<FlutterSpreadsheetUIState> {
  const _FlutterSpreadsheetUIHook({
    required this.columns,
    required this.rows,
    required this.config,
  });

  final List<FlutterSpreadsheetUIColumn> columns;
  final List<FlutterSpreadsheetUIRow> rows;
  final FlutterSpreadsheetUIConfig config;

  @override
  HookState<FlutterSpreadsheetUIState, Hook<FlutterSpreadsheetUIState>>
      createState() => _FlutterSpreadsheetUIHookState();
}

class _FlutterSpreadsheetUIHookState
    extends HookState<FlutterSpreadsheetUIState, _FlutterSpreadsheetUIHook>
    with FlutterSpreadsheetUICellDragCallbacks {
  late LinkedScrollControllerGroup _horizontalControllers;
  late FlutterSpreadsheetUIState spreadsheetUIState;

  List<FlutterSpreadsheetUIColumn> _allColumns = [];
  final List<FlutterSpreadsheetUIColumn> _selectedColumns = [];
  List<FlutterSpreadsheetUIRow> _allRows = [];
  final List<FlutterSpreadsheetUIRow> _selectedRows = [];

  FlutterSpreadsheetUIColumn? _selectedColumnForResizing;
  FlutterSpreadsheetUIRow? _selectedRowForResizing;

  late double _headerHeight, _freezedColumnWidth;
  double? _tempHeaderHeight,
      _tempFreezedColumnWidth,
      _selectedTempColumnWidth,
      _selectedTempRowHeight;

  int? _selectedColumnIndexForResizing, _selectedRowIndexForResizing;

  bool _showFreezedColumnElevation = false;

  List<FlutterSpreadsheetUIColumn> _getColumns() => hook.columns.map((column) {
        column.setColumnIndex(hook.columns.indexOf(column));
        return column;
      }).toList();

  List<FlutterSpreadsheetUIRow> _getRows() => hook.rows.map((row) {
        row.setRowIndex(hook.rows.indexOf(row) + 1);
        return row;
      }).toList();

  @override
  void initHook() {
    _allColumns = _getColumns();
    _allRows = _getRows();

    _headerHeight = hook.config.headerHeight ?? hook.config.cellHeight;
    _freezedColumnWidth = hook.config.freezedColumnWidth ??
        _allColumns.first.width ??
        hook.config.cellWidth;

    _horizontalControllers = LinkedScrollControllerGroup();
    spreadsheetUIState = FlutterSpreadsheetUIState(
      tableHeaderController: _horizontalControllers.addAndGet(),
      tableBodyController: _horizontalControllers.addAndGet(),
      verticalScrollController: ScrollController(),
      columns: _allColumns,
      selectedColumns: _selectedColumns,
      selectedRows: _selectedRows,
      rows: _allRows,
      headerHeight: _headerHeight,
      tempHeaderHeight: _tempHeaderHeight,
      freezedColumnWidth: _freezedColumnWidth,
      tempFreezedColumnWidth: _tempFreezedColumnWidth,
      selectedTempRowHeight: _selectedTempRowHeight,
      selectedTempColumnWidth: _selectedTempColumnWidth,
      defaultColumnWidth: hook.config.cellWidth,
      defaultRowHeight: hook.config.cellHeight,
      freezedColumnExtendedByWidth: hook.config.freezedColumnExtendedByWidth,
      freezeFirstColumn: hook.config.freezeFirstColumn,
      freezeFirstRow: hook.config.freezeFirstRow,
      selectedColumnIndexForResizing: _selectedColumnIndexForResizing,
      selectedRowIndexForResizing: _selectedRowIndexForResizing,
      showFreezedColumnElevation: _showFreezedColumnElevation,
      startColumnWidthResizeCallback: startColumnWidthResizeCallback,
      endColumnWidthResizeCallback: endColumnWidthResizeCallback,
      columnWidthResizeUpdateCallback: columnWidthResizeUpdateCallback,
      startRowHeightResizeCallback: startRowHeightResizeCallback,
      endRowHeightResizeCallback: endRowHeightResizeCallback,
      rowHeightResizeUpdateCallback: rowHeightResizeUpdateCallback,
    );

    _horizontalControllers
        .addOffsetChangedListener(listenHorizontalScrollOffsetChange);
    super.initHook();
  }

  @override
  void listenHorizontalScrollOffsetChange() {
    if (_horizontalControllers.offset >=
        spreadsheetUIState.freezedColumnExtendedByWidth) {
      _showFreezedColumnElevation = true;
    } else {
      _showFreezedColumnElevation = false;
    }

    spreadsheetUIState = spreadsheetUIState.copyWith(
      showFreezedColumnElevation: _showFreezedColumnElevation,
    );
    setState(() {});
  }

  @override
  void startColumnWidthResizeCallback(String cellId) {
    int columnIndex = FlutterSpreadsheetUI.getColumnIndexFromCellId(cellId);
    _selectedColumnIndexForResizing = columnIndex;
    _selectedColumnForResizing = _allColumns[_selectedColumnIndexForResizing!];
    spreadsheetUIState = spreadsheetUIState.copyWith(
      selectedColumnIndexForResizing: _selectedColumnIndexForResizing,
      selectedTempColumnWidth: _selectedColumnForResizing?.width ??
          spreadsheetUIState.defaultColumnWidth,
      forceUpdate: true,
    );
    setState(() {});
  }

  @override
  void endColumnWidthResizeCallback(String cellId) {
    _selectedColumnForResizing = null;
    _selectedColumnIndexForResizing = null;
    _tempFreezedColumnWidth = null;
    _selectedTempColumnWidth = null;
    spreadsheetUIState = spreadsheetUIState.copyWith(
      selectedColumnIndexForResizing: _selectedColumnIndexForResizing,
      tempFreezedColumnWidth: _tempFreezedColumnWidth,
      selectedTempColumnWidth: _selectedTempColumnWidth,
      forceUpdate: true,
    );

    setState(() {});
  }

  @override
  void columnWidthResizeUpdateCallback(
    String cellId,
    DragUpdateDetails dragUpdateDetails,
  ) {
    if (_selectedColumnIndexForResizing == 0) {
      _tempFreezedColumnWidth =
          _freezedColumnWidth + dragUpdateDetails.localPosition.dx;
    } else {
      _selectedTempColumnWidth = (_selectedColumnForResizing?.width ??
              spreadsheetUIState.defaultColumnWidth) +
          dragUpdateDetails.localPosition.dx;
    }

    spreadsheetUIState = spreadsheetUIState.copyWith(
      tempFreezedColumnWidth: _tempFreezedColumnWidth,
      selectedTempColumnWidth: _selectedTempColumnWidth,
    );
    setState(() {});
  }

  @override
  void startRowHeightResizeCallback(String cellId) {
    int rowIndex = FlutterSpreadsheetUI.getRowIndexFromCellId(cellId);
    _selectedRowIndexForResizing = rowIndex;
    if (_selectedRowIndexForResizing == 0) {
      _tempHeaderHeight = _headerHeight;
    } else {
      _selectedRowForResizing = _allRows[_selectedRowIndexForResizing! - 1];
      _selectedTempRowHeight = _selectedRowForResizing?.height ??
          spreadsheetUIState.defaultRowHeight;
    }
    spreadsheetUIState = spreadsheetUIState.copyWith(
      selectedRowIndexForResizing: _selectedRowIndexForResizing,
      selectedTempRowHeight: _selectedTempRowHeight,
      tempHeaderHeight: _tempHeaderHeight,
      forceUpdate: true,
    );
  }

  @override
  void endRowHeightResizeCallback(String cellId) {
    _selectedRowForResizing = null;
    _selectedRowIndexForResizing = null;
    _selectedTempRowHeight = null;
    _tempHeaderHeight = null;
    spreadsheetUIState = spreadsheetUIState.copyWith(
      selectedRowIndexForResizing: _selectedRowIndexForResizing,
      selectedTempRowHeight: _selectedTempRowHeight,
      tempHeaderHeight: _tempHeaderHeight,
      forceUpdate: true,
    );
    setState(() {});
  }

  @override
  void rowHeightResizeUpdateCallback(
    String cellId,
    DragUpdateDetails dragUpdateDetails,
  ) {
    if (_selectedRowIndexForResizing == 0) {
      _tempHeaderHeight = _headerHeight + dragUpdateDetails.localPosition.dy;
    } else {
      _selectedTempRowHeight = (_selectedRowForResizing?.height ??
              spreadsheetUIState.defaultRowHeight) +
          dragUpdateDetails.localPosition.dy;
    }

    spreadsheetUIState = spreadsheetUIState.copyWith(
      selectedRowIndexForResizing: _selectedRowIndexForResizing,
      selectedTempRowHeight: _selectedTempRowHeight,
      tempHeaderHeight: _tempHeaderHeight,
    );
    setState(() {});
  }

  @override
  void didUpdateHook(_FlutterSpreadsheetUIHook oldHook) {
    if (oldHook.columns != hook.columns ||
        oldHook.rows != hook.rows ||
        oldHook.config.freezedColumnWidth != hook.config.freezedColumnWidth ||
        oldHook.config.headerHeight != hook.config.headerHeight ||
        oldHook.config.cellWidth != hook.config.cellWidth ||
        oldHook.config.cellHeight != hook.config.cellHeight ||
        oldHook.config.freezedColumnExtendedByWidth !=
            hook.config.freezedColumnExtendedByWidth ||
        oldHook.config.freezeFirstColumn != hook.config.freezeFirstColumn ||
        oldHook.config.freezeFirstRow != hook.config.freezeFirstRow) {
      _allColumns = _getColumns();
      _allRows = _getRows();

      _headerHeight = hook.config.headerHeight ?? hook.config.cellHeight;
      _freezedColumnWidth = hook.config.freezedColumnWidth ??
          _allColumns.first.width ??
          hook.config.cellWidth;

      spreadsheetUIState = spreadsheetUIState.copyWith(
        columns: _allColumns,
        selectedColumns: _selectedColumns,
        selectedRows: _selectedRows,
        rows: _allRows,
        headerHeight: _headerHeight,
        tempHeaderHeight: _tempHeaderHeight,
        freezedColumnWidth: _freezedColumnWidth,
        tempFreezedColumnWidth: _tempFreezedColumnWidth,
        selectedTempRowHeight: _selectedTempRowHeight,
        defaultColumnWidth: hook.config.cellWidth,
        defaultRowHeight: hook.config.cellHeight,
        freezedColumnExtendedByWidth: hook.config.freezedColumnExtendedByWidth,
        freezeFirstColumn: hook.config.freezeFirstColumn,
        freezeFirstRow: hook.config.freezeFirstRow,
        selectedColumnIndexForResizing: _selectedColumnIndexForResizing,
        selectedRowIndexForResizing: _selectedRowIndexForResizing,
        showFreezedColumnElevation: _showFreezedColumnElevation,
        forceUpdate: true,
      );
    }
    super.didUpdateHook(oldHook);
  }

  @override
  void dispose() {
    _horizontalControllers
        .removeOffsetChangedListener(listenHorizontalScrollOffsetChange);
    spreadsheetUIState.tableHeaderController.dispose();
    spreadsheetUIState.tableBodyController.dispose();
    spreadsheetUIState.verticalScrollController.dispose();
    super.dispose();
  }

  @override
  FlutterSpreadsheetUIState build(BuildContext context) => spreadsheetUIState;
}
