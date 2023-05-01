part of 'widgets.dart';

class _FreezedColumn extends StatelessWidget {
  const _FreezedColumn({
    Key? key,
    required this.isHeaderItem,
  }) : super(key: key);

  final bool isHeaderItem;

  @override
  Widget build(BuildContext context) {
    FlutterSpreadsheetUIState tableState = FlutterSpreadsheetUI.of(context);
    return SliverPersistentHeader(
      pinned: tableState.freezeFirstColumn,
      delegate: _FreezedColumnDelegate(
        pinned: tableState.freezeFirstColumn,
        freezedColumnWidth:
            (tableState.tempFreezedColumnWidth ?? tableState.freezedColumnWidth)
                    .isNegative
                ? 0
                : tableState.tempFreezedColumnWidth ??
                    tableState.freezedColumnWidth,
        extendedColumnWidth: tableState.freezedColumnExtendedByWidth,
        child: Material(
          elevation: tableState.freezeFirstColumn &&
                  tableState.showFreezedColumnElevation
              ? 10
              : 0,
          child: _getChild(context),
        ),
      ),
    );
  }

  Widget _getChild(BuildContext context) {
    FlutterSpreadsheetUIState tableState = FlutterSpreadsheetUI.of(context);

    final FlutterSpreadsheetUIColumn column = tableState.freezedColumn;

    final bool isColumnResizing =
        tableState.selectedColumnIndexForResizing == column.columnIndex;

    final bool isRowResizing = tableState.selectedRowIndexForResizing == 0;

    String cellId = 'C${column.columnIndex}, R0';

    final bool isColumnSelected = tableState.selectedColumns.firstWhereOrNull(
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
        isSelected: isColumnResizing || isRowResizing || isColumnSelected,
        alignment: column.contentAlignment,
        padding: column.padding,
        margin: column.margin,
        borderWidth: tableState.borderWidth,
        borderColor: tableState.borderColor,
        selectionColor: tableState.selectionColor,
        borderDirection: BorderDirection.topBottomLeftRight,
        onCellWidthDragStart: !tableState.enableColumnWidthDrag
            ? null
            : () => tableState.startColumnWidthResizeCallback(cellId),
        onCellWidthDragEnd: !tableState.enableColumnWidthDrag
            ? null
            : () => tableState.endColumnWidthResizeCallback(cellId),
        onCellWidthDragUpdate: !tableState.enableColumnWidthDrag
            ? null
            : (DragUpdateDetails dragUpdateDetails) =>
                tableState.columnWidthResizeUpdateCallback(
                  cellId,
                  dragUpdateDetails,
                ),
        onCellHeightDragStart: !tableState.enableRowHeightDrag
            ? null
            : () => tableState.startRowHeightResizeCallback(cellId),
        onCellHeightDragEnd: !tableState.enableRowHeightDrag
            ? null
            : () => tableState.endRowHeightResizeCallback(cellId),
        onCellHeightDragUpdate: !tableState.enableRowHeightDrag
            ? null
            : (DragUpdateDetails dragUpdateDetails) =>
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
            final String cellId = 'C${column.columnIndex}, R${row.rowIndex}';

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

            final bool isRowSelected = tableState.selectedRows.firstWhereOrNull(
                    (element) => element.rowIndex == row.rowIndex) !=
                null;

            return _BaseCell(
              onTap: () {
                if (tableState.selectedRows.isEmpty) {
                  if (row.cells[column.columnIndex].onCellPressed != null) {
                    row.cells[column.columnIndex].onCellPressed!();
                  }
                } else {
                  tableState.rowSelectionCallback(cellId);
                }
              },
              onTapDown: null,
              onTapUp: null,
              onTapCancel: null,
              onDoubleTap: null,
              onLongPress: () => tableState.rowSelectionCallback(cellId),
              onHighlightChanged: null,
              onHover: null,
              onFocusChanged: null,
              isSelected: isColumnResizing ||
                  isRowResizing ||
                  isColumnSelected ||
                  isRowSelected,
              alignment: column.contentAlignment,
              padding: column.padding,
              margin: column.margin,
              cellHeight: cellHeight,
              borderWidth: tableState.borderWidth,
              borderColor: tableState.borderColor,
              selectionColor: tableState.selectionColor,
              borderDirection: BorderDirection.bottomLeftRight,
              onCellWidthDragStart: !tableState.enableColumnWidthDrag
                  ? null
                  : () => tableState.startColumnWidthResizeCallback(cellId),
              onCellWidthDragEnd: !tableState.enableColumnWidthDrag
                  ? null
                  : () => tableState.endColumnWidthResizeCallback(cellId),
              onCellWidthDragUpdate: !tableState.enableColumnWidthDrag
                  ? null
                  : (DragUpdateDetails dragUpdateDetails) =>
                      tableState.columnWidthResizeUpdateCallback(
                        cellId,
                        dragUpdateDetails,
                      ),
              onCellHeightDragStart: !tableState.enableRowHeightDrag
                  ? null
                  : () => tableState.startRowHeightResizeCallback(cellId),
              onCellHeightDragEnd: !tableState.enableRowHeightDrag
                  ? null
                  : () => tableState.endRowHeightResizeCallback(cellId),
              onCellHeightDragUpdate: !tableState.enableRowHeightDrag
                  ? null
                  : (DragUpdateDetails dragUpdateDetails) =>
                      tableState.rowHeightResizeUpdateCallback(
                        cellId,
                        dragUpdateDetails,
                      ),
              child: row.cells[column.columnIndex].toWidget(context, cellId),
            );
          },
        ).toList(),
      );
    }
  }
}

class _FreezedColumnDelegate extends SliverPersistentHeaderDelegate {
  _FreezedColumnDelegate({
    required this.freezedColumnWidth,
    required this.extendedColumnWidth,
    required this.pinned,
    required this.child,
  });

  final double freezedColumnWidth;
  final double extendedColumnWidth;
  final bool pinned;
  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      alignment: Alignment.topLeft,
      child: child,
    );
  }

  @override
  double get maxExtent =>
      pinned ? freezedColumnWidth + extendedColumnWidth : freezedColumnWidth;

  @override
  double get minExtent => freezedColumnWidth;

  @override
  bool shouldRebuild(covariant _FreezedColumnDelegate oldDelegate) =>
      oldDelegate.freezedColumnWidth != freezedColumnWidth ||
      oldDelegate.extendedColumnWidth != extendedColumnWidth ||
      oldDelegate.pinned != pinned ||
      oldDelegate.child != child;
}
