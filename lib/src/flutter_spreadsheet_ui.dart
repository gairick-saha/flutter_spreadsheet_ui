import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../flutter_spreadsheet_ui.dart';
import 'hooks/flutter_spreadsheet_ui_hook.dart';
import 'models/flutter_spreadsheet_ui_state.dart';
import 'widgets/scroll/scroll.dart';
import 'widgets/widgets.dart';

class _InheritedFlutterSpreadsheetUI extends InheritedWidget {
  const _InheritedFlutterSpreadsheetUI({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  final FlutterSpreadsheetUIState state;

  @override
  bool updateShouldNotify(covariant _InheritedFlutterSpreadsheetUI oldWidget) =>
      true;
}

class FlutterSpreadsheetUI extends HookWidget {
  FlutterSpreadsheetUI({
    Key? key,
    required this.columns,
    required this.rows,
    this.config = const FlutterSpreadsheetUIConfig(),
    this.columnWidthResizeCallback,
    this.rowHeightResizeCallback,
  })  : assert(
          columns.isNotEmpty,
          'minimum 1 column need to be specified',
        ),
        assert(
          rows.isNotEmpty,
          'minimum 1 row need to be specified',
        ),
        assert(
          !rows.any(
            (FlutterSpreadsheetUIRow row) => row.cells.length != columns.length,
          ),
          "row cell's length should be equal to the length of the column",
        ),
        super(key: key);

  final List<FlutterSpreadsheetUIColumn> columns;
  final List<FlutterSpreadsheetUIRow> rows;
  final FlutterSpreadsheetUIConfig config;
  final FlutterSpreadsheetUIColumnWidthResizeCallback?
      columnWidthResizeCallback;
  final FlutterSpreadsheetUIRowHeightResizeCallback? rowHeightResizeCallback;

  static FlutterSpreadsheetUIState of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedFlutterSpreadsheetUI>()!
      .state;

  static int getColumnIndexFromCellId(String cellId) =>
      int.parse(cellId.split(',').first.replaceAll('C', ''));

  static int getRowIndexFromCellId(String cellId) =>
      int.parse(cellId.split(',').last.replaceAll('R', ''));

  @override
  Widget build(BuildContext context) {
    return _InheritedFlutterSpreadsheetUI(
      state: useFlutterSpreadsheetUIState(
        columns: columns,
        rows: rows,
        config: config,
        columnWidthResizeCallback: columnWidthResizeCallback,
        rowHeightResizeCallback: rowHeightResizeCallback,
      ),
      child: Builder(
        builder: (context) {
          FlutterSpreadsheetUIState tableState =
              FlutterSpreadsheetUI.of(context);
          return ScrollConfiguration(
            behavior: const FlutterSpreadsheetUIScrollBehavior(),
            child: CustomScrollView(
              controller: tableState.verticalScrollController,
              scrollDirection: Axis.vertical,
              scrollBehavior: const FlutterSpreadsheetUIScrollBehavior(),
              shrinkWrap: true,
              slivers: const [
                FlutterSpreadsheetUITableHeader(),
                FlutterSpreadsheetUITableBody(),
              ],
            ),
          );
        },
      ),
    );
  }
}
