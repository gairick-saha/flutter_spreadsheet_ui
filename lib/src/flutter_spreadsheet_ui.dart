import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../flutter_spreadsheet_ui.dart';
import 'utils/scroll_behaviour.dart';
import 'widgets/body_rows.dart';
import 'widgets/header_row.dart';

class FlutterSpreadsheetUI extends StatefulWidget {
  FlutterSpreadsheetUI({
    Key? key,
    required this.columns,
    required this.rows,
    this.config = const FlutterSpreadsheetUIConfig(),
  })  : assert(
          columns.isNotEmpty,
          "minimum 1 column need to be specified",
        ),
        assert(
          rows.isNotEmpty,
          "minimum 1 row need to be specified",
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

  @override
  State<FlutterSpreadsheetUI> createState() => _FlutterSpreadsheetUIState();

  static int getColumnIndexFromCellId(String cellId) =>
      int.parse(cellId.split(',').first.replaceAll('C', ''));

  static int getRowIndexFromCellId(String cellId) =>
      int.parse(cellId.split(',').last.replaceAll('R', ''));
}

class _FlutterSpreadsheetUIState extends State<FlutterSpreadsheetUI> {
  late LinkedScrollControllerGroup _horizontalControllers;
  late ScrollController _headController;
  late ScrollController _bodyController;
  late ScrollController _verticalScrollController;

  double? tempCellWidthFromHeader;
  int? selectedColumnIndex;
  int? selectedRowIndex;
  FlutterSpreadsheetUIColumn? selectedColumn;
  List<FlutterSpreadsheetUIColumn> allColumns = [];
  List<FlutterSpreadsheetUIRow> allRows = [];

  @override
  void initState() {
    super.initState();
    _horizontalControllers = LinkedScrollControllerGroup();
    _headController = _horizontalControllers.addAndGet();
    _bodyController = _horizontalControllers.addAndGet();
    _verticalScrollController = ScrollController();
    allColumns = widget.columns;
    allRows = widget.rows;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant FlutterSpreadsheetUI oldWidget) {
    setState(() {
      if (oldWidget.columns != widget.columns ||
          oldWidget.rows != widget.rows) {
        allColumns = widget.columns;
        allRows = widget.rows;
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  void _startColumnWidthResize(String cellId) {
    selectedColumnIndex = FlutterSpreadsheetUI.getColumnIndexFromCellId(cellId);
    selectedColumn = widget.columns[selectedColumnIndex!];
    setState(() {});
  }

  void _updateColumnWidth(double updatedCellWidth, String cellId) {
    if (updatedCellWidth <= 0) {
      tempCellWidthFromHeader = 0;
    } else {
      tempCellWidthFromHeader = updatedCellWidth;
    }
    setState(() {});
  }

  void _onFreezedCellWidthDragEnd(double updatedCellWidth, String cellId) {
    tempCellWidthFromHeader = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Widget tableHeader = FlutterSpreadsheetUIHeaderRow(
      columns: allColumns,
      freezedCellWidth: widget.config.freezedCellWidth ??
          allColumns.first.width ??
          widget.config.cellWidth,
      headerHeight: widget.config.headerHeight ?? widget.config.cellHeight,
      config: widget.config,
      scrollController: _headController,
      onCellWidthDragStart: _startColumnWidthResize,
      onCellWidthDrag: _updateColumnWidth,
      onCellWidthDragEnd: _onFreezedCellWidthDragEnd,
      onCellHeightDrag: (double updatedCellHeight, String cellId) {
        log("Row Height changed for cell $cellId : $updatedCellHeight");
      },
      onCellHeightDragEnd: (double updatedCellHeight, String cellId) {
        log("Row Height updated for cell $cellId : $updatedCellHeight");
      },
    );

    final Widget tableBody = FlutterSpreadsheetUIBodyRows(
      freezedCellWidth:
          tempCellWidthFromHeader != null && selectedColumnIndex == 0
              ? tempCellWidthFromHeader!
              : widget.config.freezedCellWidth ??
                  allColumns.first.width ??
                  widget.config.cellWidth,
      rows: allRows,
      columns: allColumns,
      config: widget.config,
      scrollController: _bodyController,
      selectedColumnIndex: selectedColumnIndex,
      selectedColumnWidth:
          tempCellWidthFromHeader != null && selectedColumnIndex != 0
              ? tempCellWidthFromHeader
              : null,
      onCellHeightDrag: (double updatedCellHeight, String cellId) {
        log("Row Height changed for cell $cellId : $updatedCellHeight");
      },
      onCellHeightDragEnd: (double updatedCellHeight, String cellId) {
        log("Row Height updated for cell $cellId : $updatedCellHeight");
      },
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: ScrollConfiguration(
        behavior: const FlutterSpreadsheetUIScrollBehavior(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            tableHeader,
            Flexible(
              child: SingleChildScrollView(
                controller: _verticalScrollController,
                scrollDirection: Axis.vertical,
                child: widget.config.customVerticalScrollViewBuilder != null
                    ? widget.config.customVerticalScrollViewBuilder!(tableBody)
                    : tableBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
