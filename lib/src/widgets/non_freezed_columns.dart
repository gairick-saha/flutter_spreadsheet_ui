part of 'widgets.dart';

class _NonFreezedColumns extends StatelessWidget {
  const _NonFreezedColumns({
    Key? key,
    required this.isHeaderItem,
  }) : super(key: key);

  final bool isHeaderItem;

  @override
  Widget build(BuildContext context) {
    FlutterSpreadsheetUIState tableState = FlutterSpreadsheetUI.of(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int nonFreezeColumnIndex) {
          final FlutterSpreadsheetUIColumn column =
              tableState.nonFreezedColumns[nonFreezeColumnIndex];

          final String cellId = 'C${column.columnIndex}, R0';

          final bool isColumnResizing =
              tableState.selectedColumnIndexForResizing == column.columnIndex;

          final bool isRowResizing =
              tableState.selectedRowIndexForResizing == 0;

          final double cellWidth = isColumnResizing
              ? (tableState.selectedTempColumnWidth ??
                          (column.width ?? tableState.defaultColumnWidth))
                      .isNegative
                  ? 0
                  : tableState.selectedTempColumnWidth ??
                      (column.width ?? tableState.defaultColumnWidth)
              : column.width ?? tableState.defaultColumnWidth;

          final bool isColumnSelected = tableState.selectedColumns
                  .firstWhereOrNull(
                      (element) => element.columnIndex == column.columnIndex) !=
              null;

          if (isHeaderItem) {
            return _BaseCell(
              onTap: () {
                if (tableState.selectedColumns.isEmpty) {
                  if (column.onCellPressed != null) {
                    column.onCellPressed!();
                  }
                } else {
                  tableState.columnSelectionCallback(cellId);
                }
              },
              onTapDown: null,
              onTapUp: null,
              onTapCancel: null,
              onDoubleTap: null,
              onLongPress: () => tableState.columnSelectionCallback(cellId),
              onHighlightChanged: null,
              onHover: null,
              onFocusChanged: null,
              cellWidth: cellWidth,
              isSelected: isColumnResizing || isRowResizing || isColumnSelected,
              borderColor: null,
              selectionColor: null,
              borderWidth: 2.0,
              borderDirection: BorderDirection.topBottomRight,
              onCellWidthDragStart: () =>
                  tableState.startColumnWidthResizeCallback(cellId),
              onCellWidthDragEnd: () =>
                  tableState.endColumnWidthResizeCallback(cellId),
              onCellWidthDragUpdate: (DragUpdateDetails dragUpdateDetails) =>
                  tableState.columnWidthResizeUpdateCallback(
                cellId,
                dragUpdateDetails,
              ),
              onCellHeightDragStart: () =>
                  tableState.startRowHeightResizeCallback(cellId),
              onCellHeightDragEnd: () =>
                  tableState.endRowHeightResizeCallback(cellId),
              onCellHeightDragUpdate: (DragUpdateDetails dragUpdateDetails) =>
                  tableState.rowHeightResizeUpdateCallback(
                cellId,
                dragUpdateDetails,
              ),
              child: column.toWidget(
                context,
                cellId,
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: tableState.rows.map(
                (FlutterSpreadsheetUIRow row) {
                  final String cellId =
                      'C${column.columnIndex}, R${row.rowIndex}';

                  final bool isRowResizing =
                      tableState.selectedRowIndexForResizing == row.rowIndex;

                  final double cellHeight = isRowResizing
                      ? (tableState.selectedTempRowHeight ??
                                  (row.height ?? tableState.defaultRowHeight))
                              .isNegative
                          ? 0
                          : tableState.selectedTempRowHeight ??
                              (row.height ?? tableState.defaultRowHeight)
                      : row.height ?? tableState.defaultRowHeight;

                  final bool isRowSelected = tableState.selectedRows
                          .firstWhereOrNull(
                              (element) => element.rowIndex == row.rowIndex) !=
                      null;

                  return _BaseCell(
                    onTap: null,
                    onTapDown: null,
                    onTapUp: null,
                    onTapCancel: null,
                    onDoubleTap: null,
                    onLongPress: null,
                    onHighlightChanged: null,
                    onHover: null,
                    onFocusChanged: null,
                    cellWidth: cellWidth,
                    cellHeight: cellHeight,
                    isSelected: isColumnResizing ||
                        isRowResizing ||
                        isColumnSelected ||
                        isRowSelected,
                    borderColor: null,
                    selectionColor: null,
                    borderWidth: 2.0,
                    borderDirection: BorderDirection.bottomRight,
                    onCellWidthDragStart: () =>
                        tableState.startColumnWidthResizeCallback(cellId),
                    onCellWidthDragEnd: () =>
                        tableState.endColumnWidthResizeCallback(cellId),
                    onCellWidthDragUpdate:
                        (DragUpdateDetails dragUpdateDetails) =>
                            tableState.columnWidthResizeUpdateCallback(
                      cellId,
                      dragUpdateDetails,
                    ),
                    onCellHeightDragStart: () =>
                        tableState.startRowHeightResizeCallback(cellId),
                    onCellHeightDragEnd: () =>
                        tableState.endRowHeightResizeCallback(cellId),
                    onCellHeightDragUpdate:
                        (DragUpdateDetails dragUpdateDetails) =>
                            tableState.rowHeightResizeUpdateCallback(
                      cellId,
                      dragUpdateDetails,
                    ),
                    child: row.cells[column.columnIndex].toWidget(
                      context,
                      cellId,
                    ),
                  );
                },
              ).toList(),
            );
          }
        },
        childCount: tableState.nonFreezedColumns.length,
      ),
    );
  }
}
