part of 'flutter_spreadsheet_ui.dart';

class FlutterSpreadsheetUIConfig {
  FlutterSpreadsheetUIConfig({
    this.borderSide,
    this.borderColor = Colors.grey,
    this.pinnedFirstRow = false,
    this.columnRowHeight = kDefaultRowHeight,
    this.columnRowColor,
    this.backgroundColor,
    this.horizontalDetails,
    this.verticalDetails,
  });

  final BorderSide? borderSide;
  final Color borderColor;
  final bool pinnedFirstRow;
  final Color? columnRowColor;
  final double columnRowHeight;
  final Color? backgroundColor;
  final ScrollableDetails? horizontalDetails;
  final ScrollableDetails? verticalDetails;
}
