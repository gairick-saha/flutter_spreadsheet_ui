part of 'table.dart';

const double kDefaultRowHeight = kMinInteractiveDimension;

class _RowSpan {
  double get startOffset => _startOffset;
  late double _startOffset;

  double get height => _height;
  late double _height;

  SpreadsheetUIRow get configuration => _configuration!;
  SpreadsheetUIRow? _configuration;

  bool get isPinned => _isPinned;
  late bool _isPinned;

  double get size => startOffset + height;

  void updateRow({
    required SpreadsheetUIRow configuration,
    required double startOffset,
    required double height,
    required bool isPinned,
  }) {
    _startOffset = startOffset;
    _height = height;
    _isPinned = isPinned;
    if (configuration == _configuration) {
      return;
    }
    _configuration = configuration;
  }

  void dispose() {}
}

class SpreadsheetUIRow {
  SpreadsheetUIRow({
    required this.height,
    this.isFreezed = false,
    this.decoration,
  });

  final double height;
  final bool isFreezed;
  final SpreadsheetUIRowDecoration? decoration;
}

class SpreadsheetUIRowDecoration extends SpreadsheetUIDecoration {
  SpreadsheetUIRowDecoration({
    this.color,
    this.border,
  });

  final Color? color;

  final SpreadsheetUIRowBorder? border;

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

class SpreadsheetUIRowBorder extends SpreadsheetUIBorder {
  SpreadsheetUIRowBorder({
    this.top = BorderSide.none,
    this.bottom = BorderSide.none,
  });

  final BorderSide top;
  final BorderSide bottom;

  @override
  void paint(SpreadsheetUIDecorationPaintDetails details) {
    final AxisDirection axisDirection = details.axisDirection;
    switch (axisDirectionToAxis(axisDirection)) {
      case Axis.horizontal:
        paintBorder(
          details.canvas,
          details.rect,
          top: axisDirection == AxisDirection.right ? top : bottom,
          bottom: axisDirection == AxisDirection.right ? bottom : top,
        );
        break;
      case Axis.vertical:
        paintBorder(
          details.canvas,
          details.rect,
          left: axisDirection == AxisDirection.down ? top : bottom,
          right: axisDirection == AxisDirection.down ? bottom : top,
        );
        break;
    }
  }
}
