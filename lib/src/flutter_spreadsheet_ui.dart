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
}

class _FlutterSpreadsheetUIState extends State<FlutterSpreadsheetUI> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _headController;
  late ScrollController _bodyController;
  late ScrollController _verticalScrollController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();
    _verticalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            FlutterSpreadsheetUIHeaderRow(
              columns: widget.columns,
              config: widget.config,
              scrollController: _headController,
            ),
            Flexible(
              child: SingleChildScrollView(
                controller: _verticalScrollController,
                scrollDirection: Axis.vertical,
                child: FlutterSpreadsheetUIBodyRows(
                  rows: widget.rows,
                  columns: widget.columns,
                  config: widget.config,
                  scrollController: _bodyController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
