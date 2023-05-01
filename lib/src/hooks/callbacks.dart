part of 'flutter_spreadsheet_ui_hook.dart';

mixin _FlutterSpreadsheetUICellDragCallbacks {
  void listenHorizontalScrollOffsetChange();

  void startColumnWidthResizeCallback(String cellId);
  void endColumnWidthResizeCallback(String cellId);
  void columnWidthResizeUpdateCallback(
    String cellId,
    DragUpdateDetails dragUpdateDetails,
  );

  void startRowHeightResizeCallback(String cellId);
  void endRowHeightResizeCallback(String cellId);
  void rowHeightResizeUpdateCallback(
    String cellId,
    DragUpdateDetails dragUpdateDetails,
  );

  void selectColumn(String cellId);

  void selectRow(String cellId);
}
