part of 'flutter_spreadsheet_ui.dart';

const double kDefaultColumnWidth = 200;
const double kDefaultRowHeight = kMinInteractiveDimension;

class FlutterSpreadsheetUIConfig {
  FlutterSpreadsheetUIConfig({
    this.borderSide,
    this.borderColor = Colors.grey,
    this.pinnedFirstRow = false,
    this.columnRowHeight = kDefaultRowHeight,
    this.columnRowColor,
    this.emptyRowBuilder,
  });

  final BorderSide? borderSide;
  final Color borderColor;
  final bool pinnedFirstRow;
  final Color? columnRowColor;
  final double columnRowHeight;
  final FlutterSpreadsheetUIEmptyRow? emptyRowBuilder;
}
