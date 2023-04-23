import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FlutterSpreadsheetUIScrollBehavior extends MaterialScrollBehavior {
  const FlutterSpreadsheetUIScrollBehavior({
    Set<PointerDeviceKind>? scrollingBehaviours,
  })  : _dragDevices = scrollingBehaviours ?? _defaultScrollingBehaviours,
        super();

  @override
  Set<PointerDeviceKind> get dragDevices => _dragDevices;

  final Set<PointerDeviceKind> _dragDevices;

  static const Set<PointerDeviceKind> _defaultScrollingBehaviours = {
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.unknown,
  };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
