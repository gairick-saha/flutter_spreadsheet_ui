part of 'table.dart';

class _ColumnSpan {
  double get startOffset => _startOffset;
  late double _startOffset;

  double get width => _width;
  late double _width;

  SpreadsheetUIColumn get configuration => _configuration!;
  SpreadsheetUIColumn? _configuration;

  bool get isPinned => _isPinned;
  late bool _isPinned;

  double get size => startOffset + width;

  void updateColumn({
    required SpreadsheetUIColumn configuration,
    required double startOffset,
    required double width,
    required bool isPinned,
  }) {
    _startOffset = startOffset;
    _width = width;
    _isPinned = isPinned;
    if (configuration == _configuration) {
      return;
    }
    _configuration = configuration;
  }

  void dispose() {}
}

class SpreadsheetUIColumn {
  SpreadsheetUIColumn({
    required this.width,
    this.isFreezed = false,
    this.decoration,
  });

  final double width;
  final bool isFreezed;
  final SpreadsheetUIColumnDecoration? decoration;
}

class SpreadsheetUIColumnDecoration extends SpreadsheetUIDecoration {
  SpreadsheetUIColumnDecoration({
    this.color,
    this.border,
  });

  final Color? color;

  final SpreadsheetUIColumnBorder? border;

  @override
  void paint(SpreadsheetUIDecorationPaintDetails details) {
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

class SpreadsheetUIColumnBorder extends SpreadsheetUIBorder {
  SpreadsheetUIColumnBorder({
    this.left = BorderSide.none,
    this.right = BorderSide.none,
  });

  final BorderSide left;
  final BorderSide right;

  @override
  void paint(SpreadsheetUIDecorationPaintDetails details) {
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
