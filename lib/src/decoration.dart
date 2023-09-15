part of 'ui.dart';

abstract class FlutterSpreadsheetUIDecoration {
  void paint(FlutterSpreadsheetUIDecorationPaintDetails details);
}

abstract class FlutterSpreadsheetUIBorder {
  void paint(FlutterSpreadsheetUIDecorationPaintDetails details);
}

class FlutterSpreadsheetUIDecorationPaintDetails {
  FlutterSpreadsheetUIDecorationPaintDetails({
    required this.canvas,
    required this.rect,
    required this.axisDirection,
  });

  final Canvas canvas;

  final Rect rect;

  final AxisDirection axisDirection;
}
