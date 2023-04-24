import 'package:flutter/material.dart';

enum BorderDirection {
  topAndBottom,
  topBottomRight,
  topBottomLeftRight,
  bottomLeftRight,
  bottomRight,
}

class FlutterSpreadsheetUIBaseCell extends StatefulWidget {
  const FlutterSpreadsheetUIBaseCell({
    Key? key,
    required this.cellWidth,
    required this.cellHeight,
    required this.child,
    required this.borderDirection,
    this.alignment,
    this.borderWidth = 1.0,
    this.onTap,
    this.onFocusChanged,
    required this.onCellWidthDragStart,
    required this.onCellWidthDrag,
    required this.onCellWidthDragEnd,
    required this.onCellHeightDrag,
    required this.onCellHeightDragEnd,
  }) : super(key: key);

  final double cellWidth;
  final double? cellHeight;
  final Widget? child;
  final AlignmentGeometry? alignment;
  final BorderDirection borderDirection;
  final double borderWidth;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFocusChanged;
  final VoidCallback? onCellWidthDragStart;
  final Function(double updatedCellWidth)? onCellWidthDrag;
  final Function(double updatedCellWidth)? onCellWidthDragEnd;
  final Function(double updatedCellHeight) onCellHeightDrag;
  final Function(double updatedCellHeight) onCellHeightDragEnd;

  @override
  State<FlutterSpreadsheetUIBaseCell> createState() =>
      _FlutterSpreadsheetUIBaseCellState();
}

class _FlutterSpreadsheetUIBaseCellState
    extends State<FlutterSpreadsheetUIBaseCell> {
  late double cellWidth;

  @override
  void initState() {
    super.initState();
    cellWidth = widget.cellWidth;
    setState(() {});
  }

  @override
  void didUpdateWidget(FlutterSpreadsheetUIBaseCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cellWidth != widget.cellWidth) {
      cellWidth = widget.cellWidth;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cellWidth.isNegative ? 0 : cellWidth,
      height: widget.cellHeight,
      child: InkWell(
        onTap: widget.onTap,
        onFocusChange: widget.onFocusChanged,
        child: Stack(
          fit: StackFit.expand,
          alignment: widget.alignment ?? Alignment.center,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          children: [
            ..._buildBorders(context),
            Positioned.fill(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() => AnimatedContainer(
        width: cellWidth.isNegative ? 0 : cellWidth,
        height: widget.cellHeight,
        duration: kThemeChangeDuration,
        alignment: widget.alignment,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: widget.child,
      );

  List<Widget> _buildBorders(BuildContext context) {
    late List<Widget> borders;

    switch (widget.borderDirection) {
      case BorderDirection.topAndBottom:
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
          )
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
            right: 0,
            child: _buildRightBorder(context),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: _buildLeftBorder(context),
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
            right: 0,
            child: _buildRightBorder(context),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: _buildLeftBorder(context),
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
              width: widget.borderWidth,
            ),
          ),
        ),
        child: const SizedBox(
          height: 2.0,
        ),
      );

  Widget _buildBottomBorder(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.resizeRow,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: Divider.createBorderSide(context).copyWith(
                width: widget.borderWidth,
              ),
            ),
          ),
          child: const SizedBox(
            height: 2.0,
          ),
        ),
      );

  Widget _buildLeftBorder(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: Divider.createBorderSide(context).copyWith(
              width: widget.borderWidth,
            ),
          ),
        ),
      );

  Widget _buildRightBorder(BuildContext context) {
    final Widget child = DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          right: Divider.createBorderSide(context).copyWith(
            width: widget.borderWidth,
          ),
        ),
      ),
      child: const SizedBox(
        width: 2.0,
      ),
    );

    if (widget.onCellWidthDrag == null) {
      return child;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onHorizontalDragUpdate:
            widget.onCellWidthDrag == null ? null : _resizeColumn,
        onHorizontalDragStart: (_) => widget.onCellWidthDragStart == null
            ? null
            : widget.onCellWidthDragStart!(),
        onHorizontalDragEnd: (_) {
          if (widget.onCellWidthDragEnd != null) {
            cellWidth = widget.cellWidth;
            widget.onCellWidthDragEnd!(cellWidth);
          }
          setState(() {});
        },
        child: child,
      ),
    );
  }

  void _resizeColumn(DragUpdateDetails dragDetails) {
    double width = widget.cellWidth + dragDetails.localPosition.dx;
    cellWidth = width;
    widget.onCellWidthDrag!(width);
    setState(() {});
  }
}
