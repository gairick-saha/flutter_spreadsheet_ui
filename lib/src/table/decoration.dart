part of 'table.dart';

abstract class SpreadsheetUIEmptyRowDecoration {
  void paint(SpreadsheetUIDecorationPaintDetails details);
}

abstract class SpreadsheetUIDecoration {
  void paint(SpreadsheetUIDecorationPaintDetails details);
}

abstract class SpreadsheetUIBorder {
  void paint(SpreadsheetUIDecorationPaintDetails details);
}

class SpreadsheetUIDecorationPaintDetails {
  SpreadsheetUIDecorationPaintDetails({
    required this.canvas,
    required this.rect,
    required this.axisDirection,
  });

  final Canvas canvas;

  final Rect rect;

  final AxisDirection axisDirection;
}
