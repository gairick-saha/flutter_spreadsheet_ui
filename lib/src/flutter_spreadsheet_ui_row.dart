part of 'flutter_spreadsheet_ui.dart';

typedef FlutterSpreadsheetUIRowBuilder<T> = Widget Function(
  BuildContext context,
  CellIndex cellIndex,
  T rowData,
);

class FlutterSpreadsheetUIRow<T> {
  FlutterSpreadsheetUIRow({
    this.height = kDefaultRowHeight,
    this.color,
    this.borderSide,
    required this.value,
    required this.builder,
  });

  double height;
  Color? color;
  BorderSide? borderSide;
  T value;
  FlutterSpreadsheetUIRowBuilder<T> builder;

  Widget toWidget(
    BuildContext context,
    CellIndex cellIndex,
    AlignmentGeometry contentAlignment,
    EdgeInsetsGeometry contentPadding,
  ) =>
      Align(
        alignment: contentAlignment,
        child: Padding(
          padding: contentPadding,
          child: builder(context, cellIndex, value),
        ),
      );

  void update({
    double? height,
    Color? color,
    BorderSide? borderSide,
    T? value,
    FlutterSpreadsheetUIColumnBuilder<T>? builder,
  }) {
    this.height = height ?? this.height;
    this.color = color ?? this.color;
    this.borderSide = borderSide ?? this.borderSide;
    this.value = value ?? this.value;
    this.builder = builder ?? this.builder;
  }
}
