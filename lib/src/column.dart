part of 'ui.dart';

class FlutterSpreadsheetUIColumn {
  FlutterSpreadsheetUIColumn({
    required this.width,
    this.decoration,
  });

  final double width;
  final FlutterSpreadsheetUIColumnDecoration? decoration;
}

class FlutterSpreadsheetUIColumnDecoration
    extends FlutterSpreadsheetUIDecoration {
  FlutterSpreadsheetUIColumnDecoration({
    this.color,
    this.border,
  });

  final Color? color;

  final FlutterSpreadsheetUIColumnBorder? border;

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

class FlutterSpreadsheetUIColumnBorder extends FlutterSpreadsheetUIBorder {
  FlutterSpreadsheetUIColumnBorder({
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
