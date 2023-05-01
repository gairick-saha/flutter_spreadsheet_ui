import 'package:flutter/material.dart';

import '../../flutter_spreadsheet_ui.dart';
import '../widgets/widgets.dart';

class FlutterSpreadsheetUIState {
  FlutterSpreadsheetUIState({
    required this.tableHeaderController,
    required this.tableBodyController,
    required this.columns,
    required this.selectedColumns,
    required this.rows,
    required this.selectedRows,
    required this.verticalScrollController,
    required this.defaultRowHeight,
    required this.headerHeight,
    required this.tempHeaderHeight,
    required this.defaultColumnWidth,
    required this.freezedColumnWidth,
    required this.freezedColumnExtendedByWidth,
    required this.tempFreezedColumnWidth,
    required this.selectedTempColumnWidth,
    required this.freezeFirstColumn,
    required this.freezeFirstRow,
    required this.selectedColumnIndexForResizing,
    required this.selectedTempRowHeight,
    required this.selectedRowIndexForResizing,
    required this.showFreezedColumnElevation,
    required this.startColumnWidthResizeCallback,
    required this.endColumnWidthResizeCallback,
    required this.columnWidthResizeUpdateCallback,
    required this.startRowHeightResizeCallback,
    required this.endRowHeightResizeCallback,
    required this.rowHeightResizeUpdateCallback,
  });

  final ScrollController tableHeaderController,
      tableBodyController,
      verticalScrollController;
  final List<FlutterSpreadsheetUIColumn> columns, selectedColumns;
  final List<FlutterSpreadsheetUIRow> rows, selectedRows;
  final double headerHeight,
      freezedColumnWidth,
      freezedColumnExtendedByWidth,
      defaultColumnWidth,
      defaultRowHeight;
  final double? tempHeaderHeight,
      tempFreezedColumnWidth,
      selectedTempColumnWidth,
      selectedTempRowHeight;
  final bool freezeFirstColumn, freezeFirstRow, showFreezedColumnElevation;
  final int? selectedColumnIndexForResizing, selectedRowIndexForResizing;
  final StartColumnWidthResizeCallback startColumnWidthResizeCallback;
  final EndColumnWidthResizeCallback endColumnWidthResizeCallback;
  final ColumnWidthResizeUpdateCallback columnWidthResizeUpdateCallback;
  final StartRowHeightResizeCallback startRowHeightResizeCallback;
  final EndRowHeightResizeCallback endRowHeightResizeCallback;
  final RowHeightResizeUpdateCallback rowHeightResizeUpdateCallback;

  FlutterSpreadsheetUIState copyWith({
    List<FlutterSpreadsheetUIColumn>? columns,
    List<FlutterSpreadsheetUIColumn>? selectedColumns,
    List<FlutterSpreadsheetUIRow>? rows,
    List<FlutterSpreadsheetUIRow>? selectedRows,
    double? headerHeight,
    double? tempHeaderHeight,
    double? defaultColumnWidth,
    double? freezedColumnWidth,
    double? freezedColumnExtendedByWidth,
    double? tempFreezedColumnWidth,
    double? selectedTempColumnWidth,
    double? selectedTempRowHeight,
    double? defaultRowHeight,
    bool? freezeFirstColumn,
    bool? freezeFirstRow,
    bool? showFreezedColumnElevation,
    int? selectedColumnIndexForResizing,
    int? selectedRowIndexForResizing,
    bool forceUpdate = false,
  }) =>
      FlutterSpreadsheetUIState(
        tableHeaderController: tableHeaderController,
        tableBodyController: tableBodyController,
        verticalScrollController: verticalScrollController,
        columns: columns ?? this.columns,
        selectedColumns: selectedColumns ?? this.selectedColumns,
        rows: rows ?? this.rows,
        selectedRows: selectedRows ?? this.selectedRows,
        defaultRowHeight: defaultRowHeight ?? this.defaultRowHeight,
        headerHeight: headerHeight ?? this.headerHeight,
        tempHeaderHeight: forceUpdate
            ? tempHeaderHeight
            : tempHeaderHeight ?? this.tempHeaderHeight,
        defaultColumnWidth: defaultColumnWidth ?? this.defaultColumnWidth,
        freezedColumnWidth: freezedColumnWidth ?? this.freezedColumnWidth,
        freezedColumnExtendedByWidth:
            freezedColumnExtendedByWidth ?? this.freezedColumnExtendedByWidth,
        tempFreezedColumnWidth: forceUpdate
            ? tempFreezedColumnWidth
            : tempFreezedColumnWidth ?? this.tempFreezedColumnWidth,
        selectedTempColumnWidth: forceUpdate
            ? selectedTempColumnWidth
            : selectedTempColumnWidth ?? this.selectedTempColumnWidth,
        freezeFirstColumn: freezeFirstColumn ?? this.freezeFirstColumn,
        freezeFirstRow: freezeFirstRow ?? this.freezeFirstRow,
        selectedColumnIndexForResizing: forceUpdate
            ? selectedColumnIndexForResizing
            : selectedColumnIndexForResizing ??
                this.selectedColumnIndexForResizing,
        selectedRowIndexForResizing: forceUpdate
            ? selectedRowIndexForResizing
            : selectedRowIndexForResizing ?? this.selectedRowIndexForResizing,
        selectedTempRowHeight: forceUpdate
            ? selectedTempRowHeight
            : selectedTempRowHeight ?? this.selectedTempRowHeight,
        showFreezedColumnElevation:
            showFreezedColumnElevation ?? this.showFreezedColumnElevation,
        startColumnWidthResizeCallback: startColumnWidthResizeCallback,
        endColumnWidthResizeCallback: endColumnWidthResizeCallback,
        columnWidthResizeUpdateCallback: columnWidthResizeUpdateCallback,
        startRowHeightResizeCallback: startRowHeightResizeCallback,
        endRowHeightResizeCallback: endRowHeightResizeCallback,
        rowHeightResizeUpdateCallback: rowHeightResizeUpdateCallback,
      );

  FlutterSpreadsheetUIColumn get freezedColumn => columns.first;

  List<FlutterSpreadsheetUIColumn> get nonFreezedColumns {
    List<FlutterSpreadsheetUIColumn> restOfColumns =
        List.from(columns, growable: true);
    restOfColumns.remove(freezedColumn);
    return restOfColumns;
  }

  double get calculatedTotalRowsHeight => rows.fold<double>(
        0,
        (previousValue, element) {
          int indexOfRow = rows.indexOf(element) + 1;
          final double height = indexOfRow == selectedRowIndexForResizing
              ? (selectedTempRowHeight ?? (element.height ?? defaultRowHeight))
                      .isNegative
                  ? 0
                  : selectedTempRowHeight ??
                      (element.height ?? defaultRowHeight)
              : (element.height ?? defaultRowHeight);
          return previousValue + height;
        },
      );
}
