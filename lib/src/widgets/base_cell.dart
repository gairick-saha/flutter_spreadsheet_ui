part of 'widgets.dart';

class _BaseCell extends StatelessWidget {
  const _BaseCell({
    Key? key,
    this.cellWidth,
    this.cellHeight,
    required this.child,
    required this.borderDirection,
    required this.borderWidth,
    this.alignment,
    this.borderColor,
    this.selectionColor,
    this.isSelected = false,
    this.onCellWidthDragStart,
    this.onCellWidthDragEnd,
    this.onCellHeightDragStart,
    this.onCellHeightDragEnd,
    this.onCellWidthDragUpdate,
    this.onCellHeightDragUpdate,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onDoubleTap,
    this.onLongPress,
    this.onHighlightChanged,
    this.onHover,
    this.onFocusChanged,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  final double? cellWidth, cellHeight;
  final Widget? child;
  final BorderDirection borderDirection;
  final double borderWidth;
  final AlignmentGeometry? alignment;
  final Color? borderColor;
  final Color? selectionColor;
  final bool isSelected;

  final VoidCallback? onCellWidthDragStart,
      onCellWidthDragEnd,
      onCellHeightDragStart,
      onCellHeightDragEnd;
  final GestureDragUpdateCallback? onCellWidthDragUpdate,
      onCellHeightDragUpdate;

  final GestureTapCallback? onTap, onTapCancel, onDoubleTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureLongPressCallback? onLongPress;
  final ValueChanged<bool>? onHighlightChanged, onHover, onFocusChanged;
  final EdgeInsetsGeometry? padding, margin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: InkWell(
        onTap: onTap,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTapCancel: onTapCancel,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onHighlightChanged: onHighlightChanged,
        onHover: onHover,
        onFocusChange: onFocusChanged,
        child: Stack(
          fit: StackFit.expand,
          alignment: alignment ?? Alignment.center,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          children: [
            Positioned.fill(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildContent(context),
            ),
            ..._buildBorders(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) => AnimatedContainer(
        decoration: BoxDecoration(
          color: isSelected
              ? (selectionColor ?? Theme.of(context).highlightColor)
              : Theme.of(context).canvasColor,
        ),
        width: cellWidth,
        height: cellHeight,
        duration: kThemeChangeDuration,
        alignment: alignment ?? Alignment.center,
        padding: padding,
        margin: margin,
        child: child,
      );

  List<Widget> _buildBorders(BuildContext context) {
    List<Widget> borders = [];

    switch (borderDirection) {
      case BorderDirection.topBottomLeftRight:
        borders = [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBorder(context),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBorder(context),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: _buildLeftBorder(context),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: _buildRightBorder(context),
          ),
        ];
        break;
      case BorderDirection.bottomLeftRight:
        borders = [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBorder(context),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: _buildLeftBorder(context),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: _buildRightBorder(context),
          ),
        ];
        break;
      case BorderDirection.topBottomRight:
        borders = [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBorder(context),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBorder(context),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: _buildRightBorder(context),
          ),
        ];
        break;
      case BorderDirection.bottomRight:
        borders = [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBorder(context),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: _buildRightBorder(context),
          ),
        ];
        break;
    }

    return borders;
  }

  Widget _buildTopBorder(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: Divider.createBorderSide(context).copyWith(
              width: borderWidth,
            ),
          ),
        ),
        child: const SizedBox(
          height: 5.0,
        ),
      );

  Widget _buildBottomBorder(BuildContext context) {
    final Widget child = DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context).copyWith(
            width: borderWidth,
          ),
        ),
      ),
      child: const SizedBox(
        height: 5.0,
      ),
    );

    if (onCellHeightDragUpdate == null) {
      return child;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.resizeRow,
      child: GestureDetector(
        onVerticalDragStart: onCellHeightDragStart == null
            ? null
            : (_) => onCellHeightDragStart!(),
        onVerticalDragEnd:
            onCellHeightDragEnd == null ? null : (_) => onCellHeightDragEnd!(),
        onVerticalDragUpdate: onCellHeightDragUpdate,
        child: child,
      ),
    );
  }

  Widget _buildLeftBorder(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: Divider.createBorderSide(context).copyWith(
              width: borderWidth,
            ),
          ),
        ),
      );

  Widget _buildRightBorder(BuildContext context) {
    final Widget child = DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          right: Divider.createBorderSide(context).copyWith(
            width: borderWidth,
          ),
        ),
      ),
      child: const SizedBox(
        width: 5.0,
      ),
    );

    if (onCellWidthDragUpdate == null) {
      return child;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onHorizontalDragStart: onCellWidthDragStart == null
            ? null
            : (_) => onCellWidthDragStart!(),
        onHorizontalDragEnd:
            onCellWidthDragEnd == null ? null : (_) => onCellWidthDragEnd!(),
        onHorizontalDragUpdate: onCellWidthDragUpdate,
        child: child,
      ),
    );
  }
}
