import 'dart:developer';

import 'package:flutter/material.dart';

enum BorderDirection {
  topAndBottom,
  topBottomRight,
  topBottomLeftRight,
  bottomLeftRight,
  bottomRight,
}

class FlutterSpreadsheetUIBaseCell extends StatelessWidget {
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
  }) : super(key: key);

  final double cellWidth;
  final double? cellHeight;
  final Widget? child;
  final AlignmentGeometry? alignment;
  final BorderDirection borderDirection;
  final double borderWidth;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFocusChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: InkWell(
        onTap: onTap,
        onFocusChange: onFocusChanged,
        child: Stack(
          fit: StackFit.expand,
          alignment: alignment ?? Alignment.center,
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

  List<Widget> _buildBorders(BuildContext context) {
    late List<Widget> borders;

    switch (borderDirection) {
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

  Widget _buildLeftBorder(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: Divider.createBorderSide(context).copyWith(
              width: borderWidth,
            ),
          ),
        ),
      );

  Widget _buildRightBorder(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            log("Drag started global position: ${details.globalPosition}");
            log("Drag started local position: ${details.localPosition}");
            log("Drag started local position axis-x: ${details.localPosition.dx}");
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                right: Divider.createBorderSide(context).copyWith(
                  width: borderWidth,
                ),
              ),
            ),
            child: const SizedBox(
              width: 2.0,
            ),
          ),
        ),
      );

  Widget _buildTopBorder(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: Divider.createBorderSide(context).copyWith(
              width: borderWidth,
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
                width: borderWidth,
              ),
            ),
          ),
          child: const SizedBox(
            height: 2.0,
          ),
        ),
      );

  Widget _buildContent() => AnimatedContainer(
        width: cellWidth,
        duration: kThemeChangeDuration,
        alignment: alignment,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: child,
      );
}
