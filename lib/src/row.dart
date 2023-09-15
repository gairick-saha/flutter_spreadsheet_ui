part of 'ui.dart';

class FlutterSpreadsheetUIRow {
  FlutterSpreadsheetUIRow({
    required this.height,
    this.decoration,
  });

  final double height;
  final FlutterSpreadsheetUIRowDecoration? decoration;
}

class FlutterSpreadsheetUIRowDecoration extends FlutterSpreadsheetUIDecoration {
  FlutterSpreadsheetUIRowDecoration({
    this.color,
    this.border,
  });

  final Color? color;

  final FlutterSpreadsheetUIRowBorder? border;

  @override
  void paint(FlutterSpreadsheetUIDecorationPaintDetails details) {
    if (color != null) {
      details.canvas.drawRect(
        details.rect,
        Paint()
          ..color = color!
          ..isAntiAlias = false,
      );
    }
    if (border != null) {
      border!.paint(details);
    }
  }
}

class FlutterSpreadsheetUIRowBorder extends FlutterSpreadsheetUIBorder {
  FlutterSpreadsheetUIRowBorder({
    this.left = BorderSide.none,
    this.right = BorderSide.none,
  });

  final BorderSide left;
  final BorderSide right;

  @override
  void paint(FlutterSpreadsheetUIDecorationPaintDetails details) {
    final AxisDirection axisDirection = details.axisDirection;
    switch (axisDirectionToAxis(axisDirection)) {
      case Axis.horizontal:
        paintBorder(
          details.canvas,
          details.rect,
          top: axisDirection == AxisDirection.right ? left : right,
          bottom: axisDirection == AxisDirection.right ? right : left,
        );
        break;
      case Axis.vertical:
        paintBorder(
          details.canvas,
          details.rect,
          left: axisDirection == AxisDirection.down ? left : right,
          right: axisDirection == AxisDirection.down ? right : left,
        );
        break;
    }
  }
}
