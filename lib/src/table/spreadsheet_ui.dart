part of 'table.dart';

class SpreadsheetUI extends TwoDimensionalScrollView {
  SpreadsheetUI({
    Key? key,
    required this.columns,
    required this.rows,
    SpreadsheetUIColumnBuilder? columnBuilder,
    SpreadsheetUIRowBuilder? rowBuilder,
    required SpreadsheetUICellBuilder cellBuilder,
    bool? primary,
    Axis mainAxis = Axis.vertical,
    ScrollableDetails horizontalDetails = const ScrollableDetails.horizontal(),
    ScrollableDetails verticalDetails = const ScrollableDetails.vertical(),
    double? cacheExtent,
    DiagonalDragBehavior diagonalDragBehavior = DiagonalDragBehavior.none,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    Clip clipBehavior = Clip.hardEdge,
  }) : super(
          key: key,
          primary: primary,
          mainAxis: mainAxis,
          horizontalDetails: horizontalDetails,
          verticalDetails: verticalDetails,
          cacheExtent: cacheExtent,
          diagonalDragBehavior: diagonalDragBehavior,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          clipBehavior: clipBehavior,
          delegate: SpreadsheetUICellBuilderDelegate(
            columnCount: columns.length,
            rowCount: rows.length,
            pinnedColumnCount:
                columns.where((element) => element.isFreezed).length,
            pinnedRowCount: rows.where((element) => element.isFreezed).length,
            columnBuilder: columnBuilder ?? (int index) => columns[index],
            rowBuilder: rowBuilder ?? (int index) => rows[index],
            cellBuilder: cellBuilder,
          ),
        );

  final List<SpreadsheetUIColumn> columns;
  final List<SpreadsheetUIRow> rows;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return false;
      },
      child: SizedBox(
        width: columns.fold(
            0, (previousValue, element) => previousValue! + element.width),
        height: rows.fold(
            0, (previousValue, element) => previousValue! + element.height),
        child: super.build(context),
      ),
    );
  }

  @override
  SpreadsheetUIViewport buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return SpreadsheetUIViewport(
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalDetails.direction,
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalDetails.direction,
      delegate: delegate as SpreadsheetUICellDelegateMixin,
      mainAxis: mainAxis,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }
}
