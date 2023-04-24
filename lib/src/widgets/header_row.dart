import 'package:flutter/material.dart';

import '../../flutter_spreadsheet_ui.dart';
import 'base_cell.dart';
import 'base_row.dart';
import 'scroll_shadow.dart';

class FlutterSpreadsheetUIHeaderRow extends StatelessWidget {
  const FlutterSpreadsheetUIHeaderRow({
    Key? key,
    required this.columns,
    required this.config,
    required this.headerHeight,
    required this.freezedCellWidth,
    required this.scrollController,
    required this.onCellWidthDragStart,
    required this.onCellWidthDrag,
    required this.onCellWidthDragEnd,
    required this.onCellHeightDrag,
    required this.onCellHeightDragEnd,
  }) : super(key: key);

  final List<FlutterSpreadsheetUIColumn> columns;
  final FlutterSpreadsheetUIConfig config;
  final double headerHeight;
  final double freezedCellWidth;
  final ScrollController scrollController;
  final Function(String cellId) onCellWidthDragStart;
  final Function(double updatedCellWidth, String cellId) onCellWidthDrag;
  final Function(double updatedCellWidth, String cellId) onCellWidthDragEnd;
  final Function(double updatedCellHeight, String cellId) onCellHeightDrag;
  final Function(double updatedCellHeight, String cellId) onCellHeightDragEnd;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      height: config.headerHeight ?? config.cellHeight,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BaseRow(
            rowIndex: 0,
            column: columns.first,
            cellHeight: headerHeight,
            cellWidth: freezedCellWidth,
            columnIndex: columns.indexOf(columns.first),
            borderDirection: BorderDirection.topBottomLeftRight,
            onCellWidthDrag: onCellWidthDrag,
            onCellWidthDragEnd: onCellWidthDragEnd,
            onCellHeightDrag: onCellHeightDrag,
            onCellHeightDragEnd: onCellHeightDragEnd,
            onCellWidthDragStart: onCellWidthDragStart,
          ),
          Flexible(
            child: ScrollShadow(
              size: 8,
              scrollDirection: Axis.horizontal,
              duration: kThemeAnimationDuration,
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              curve: Curves.fastOutSlowIn,
              controller: scrollController,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (notification) {
                  notification.disallowIndicator();
                  return true;
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: columns.length - 1,
                  itemBuilder: (context, columnIndex) {
                    columnIndex += 1;
                    return BaseRow(
                      rowIndex: 0,
                      column: columns[columnIndex],
                      cellHeight: headerHeight,
                      cellWidth: columns[columnIndex].width ?? config.cellWidth,
                      columnIndex: columnIndex,
                      borderDirection: BorderDirection.topBottomRight,
                      onCellWidthDrag: onCellWidthDrag,
                      onCellWidthDragEnd: onCellWidthDragEnd,
                      onCellHeightDrag: onCellHeightDrag,
                      onCellHeightDragEnd: onCellHeightDragEnd,
                      onCellWidthDragStart: onCellWidthDragStart,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
