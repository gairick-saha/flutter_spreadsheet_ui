import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Utility {
  static double getCellBorderWidth({
    required GlobalKey cellGlobalKey,
    required double cellWidth,
  }) {
    final BuildContext? freezedCellContext = cellGlobalKey.currentContext;
    double width = cellWidth;
    if (freezedCellContext != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        width = freezedCellContext.size!.width;
      });
    }
    return width;
  }

  static double getCellBorderHeight({
    required GlobalKey cellGlobalKey,
    required double cellHeight,
  }) {
    final BuildContext? freezedCellContext = cellGlobalKey.currentContext;
    double height = cellHeight;
    if (freezedCellContext != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        height = freezedCellContext.size!.height;
      });
    }
    return height;
  }
}
