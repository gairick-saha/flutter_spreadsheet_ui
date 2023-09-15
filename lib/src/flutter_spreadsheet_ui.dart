part of 'ui.dart';

class FlutterSpreadsheetUI extends TwoDimensionalScrollView {
  FlutterSpreadsheetUI({
    Key? key,
    required int columnCount,
    required int rowCount,
    int pinnedRowCount = 0,
    int pinnedColumnCount = 0,
    required FlutterSpreadsheetUIColumnBuilder columnBuilder,
    required FlutterSpreadsheetUIRowBuilder rowBuilder,
    required FlutterSpreadsheetUICellBuilder cellBuilder,
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
          delegate: FlutterSpreadsheetUICellBuilderDelegate(
            columnCount: columnCount,
            rowCount: rowCount,
            pinnedColumnCount: pinnedColumnCount,
            pinnedRowCount: pinnedRowCount,
            cellBuilder: cellBuilder,
            columnBuilder: columnBuilder,
            rowBuilder: rowBuilder,
          ),
        );

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return false;
      },
      child: FlutterSpreadsheetUIViewport(
        verticalOffset: verticalOffset,
        verticalAxisDirection: verticalDetails.direction,
        horizontalOffset: horizontalOffset,
        horizontalAxisDirection: horizontalDetails.direction,
        delegate: delegate as FlutterSpreadsheetUICellDelegateMixin,
        mainAxis: mainAxis,
        cacheExtent: cacheExtent,
        clipBehavior: clipBehavior,
      ),
    );
  }
}
