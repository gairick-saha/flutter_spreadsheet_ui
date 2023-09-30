part of 'table.dart';

class SpreadsheetUI extends TwoDimensionalScrollView {
  SpreadsheetUI({
    Key? key,
    required this.columns,
    required this.rows,
    SpreadsheetUIColumnBuilder? columnBuilder,
    SpreadsheetUIRowBuilder? columnRowBuilder,
    SpreadsheetUIRowBuilder? rowBuilder,
    required SpreadsheetUICellBuilder cellBuilder,
    required SpreadsheetUICellBuilder columnCellsBuilder,
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
    bool freezeColumnRow = true,
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
            columns: columns,
            rows: List.from([
              SpreadsheetUIRow(
                height: columnRowBuilder?.call(0).height ?? kDefaultRowHeight,
                decoration: columnRowBuilder?.call(0).decoration,
                isFreezed:
                    columnRowBuilder?.call(0).isFreezed ?? freezeColumnRow,
              ),
              ...rows,
            ]),
            columnBuilder: columnBuilder,
            columnRowBuilder: columnRowBuilder,
            rowBuilder: rowBuilder,
            cellBuilder: cellBuilder,
            columnCellsBuilder: columnCellsBuilder,
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
        width: (delegate as SpreadsheetUICellBuilderDelegate).columns.fold(
            0, (previousValue, element) => previousValue! + element.width),
        height: (delegate as SpreadsheetUICellBuilderDelegate).rows.fold(
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
