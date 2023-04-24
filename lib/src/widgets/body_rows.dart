import 'package:flutter/material.dart';

import '../../flutter_spreadsheet_ui.dart';
import 'base_cell.dart';
import 'base_row.dart';
import 'scroll_shadow.dart';

class FlutterSpreadsheetUIBodyRows extends StatelessWidget {
  const FlutterSpreadsheetUIBodyRows({
    Key? key,
    required this.rows,
    required this.columns,
    required this.config,
    required this.scrollController,
    required this.onCellHeightDrag,
    required this.onCellHeightDragEnd,
    required this.freezedCellWidth,
    required this.selectedColumnIndex,
    required this.selectedColumnWidth,
  }) : super(key: key);

  final List<FlutterSpreadsheetUIRow> rows;
  final List<FlutterSpreadsheetUIColumn> columns;
  final FlutterSpreadsheetUIConfig config;
  final ScrollController scrollController;
  final Function(double updatedCellHeight, String cellId) onCellHeightDrag;
  final Function(double updatedCellHeight, String cellId) onCellHeightDragEnd;
  final double freezedCellWidth;
  final int? selectedColumnIndex;
  final double? selectedColumnWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: rows.map(
              (FlutterSpreadsheetUIRow row) {
                return BaseRow(
                  rowIndex: rows.indexOf(row),
                  row: row,
                  column: columns.first,
                  cellHeight: row.height ?? config.cellHeight,
                  cellWidth: freezedCellWidth,
                  columnIndex: columns.indexOf(columns.first),
                  borderDirection: BorderDirection.bottomLeftRight,
                  onCellHeightDrag: onCellHeightDrag,
                  onCellHeightDragEnd: onCellHeightDragEnd,
                );
              },
            ).toList(),
          ),
          Flexible(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowIndicator();
                return true;
              },
              child: ScrollShadow(
                size: 8,
                scrollDirection: Axis.horizontal,
                duration: kThemeAnimationDuration,
                color: Theme.of(context).shadowColor.withOpacity(0.2),
                curve: Curves.fastOutSlowIn,
                controller: scrollController,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      columns.length - 1,
                      (columnIndex) {
                        columnIndex += 1;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: rows
                              .map(
                                (FlutterSpreadsheetUIRow row) => BaseRow(
                                  rowIndex: rows.indexOf(row),
                                  row: row,
                                  column: columns[columnIndex],
                                  cellHeight: row.height ?? config.cellHeight,
                                  cellWidth: selectedColumnWidth != null &&
                                          columnIndex == selectedColumnIndex
                                      ? selectedColumnWidth!
                                      : columns[columnIndex].width ??
                                          config.cellWidth,
                                  columnIndex: columnIndex,
                                  borderDirection: BorderDirection.bottomRight,
                                  onCellHeightDrag: onCellHeightDrag,
                                  onCellHeightDragEnd: onCellHeightDragEnd,
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
