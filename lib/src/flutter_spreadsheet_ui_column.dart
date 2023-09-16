part of 'flutter_spreadsheet_ui.dart';

typedef FlutterSpreadsheetUIColumnBuilder<T> = Widget Function(
  BuildContext context,
  CellIndex cellIndex,
  T columnData,
);

class FlutterSpreadsheetUIColumn<T> {
  FlutterSpreadsheetUIColumn({
    this.width = kDefaultColumnWidth,
    this.color,
    this.borderSide,
    required this.value,
    required this.builder,
  });

  double width;
  Color? color;
  BorderSide? borderSide;
  T value;
  FlutterSpreadsheetUIColumnBuilder<T> builder;

  Widget toWidget(BuildContext context, CellIndex cellIndex) =>
      builder(context, cellIndex, value);

  void update({
    double? width,
    Color? color,
    BorderSide? borderSide,
    T? value,
    FlutterSpreadsheetUIColumnBuilder<T>? builder,
  }) {
    this.width = width ?? this.width;
    this.color = color ?? this.color;
    this.borderSide = borderSide ?? this.borderSide;
    this.value = value ?? this.value;
    this.builder = builder ?? this.builder;
  }
}
