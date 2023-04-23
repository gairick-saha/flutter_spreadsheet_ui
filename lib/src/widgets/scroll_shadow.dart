import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScrollShadow extends StatefulWidget {
  const ScrollShadow({
    super.key,
    this.size = 15,
    this.color = Colors.grey,
    this.controller,
    this.scrollDirection = Axis.vertical,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOutQuint,
    this.ignoreInteraction = true,
  });

  final Color color;

  final double size;

  final Axis scrollDirection;

  final ScrollController? controller;

  final Widget child;

  final Duration duration;

  final Curve curve;

  final bool ignoreInteraction;

  @override
  State<ScrollShadow> createState() => _ScrollShadowState();
}

class _ScrollShadowState extends State<ScrollShadow> {
  ScrollController _controller = ScrollController();
  bool _reachedStart = true;
  bool _reachedStartSnap = true;
  bool _reachedEnd = false;
  bool _reachedEndSnap = false;

  @override
  void dispose() {
    _controller.removeListener(_listener);
    super.dispose();
  }

  bool get _shadowVisible =>
      _controller.positions.isNotEmpty &&
      (_controller.position.extentBefore > 0 ||
          _controller.position.extentAfter > 0);

  void _listener() {
    _reachedStart = _controller.positions.isNotEmpty &&
        _controller.position.extentBefore == 0;
    _reachedEnd = _controller.positions.isNotEmpty &&
        _controller.position.extentAfter == 0;
    _update();
  }

  void _update() {
    if (_reachedStart != _reachedStartSnap) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _reachedStartSnap = _reachedStart);
        }
      });
    }
    if (_reachedEnd != _reachedEndSnap) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _reachedEndSnap = _reachedEnd);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null) {
      _controller = widget.controller!..addListener(_listener);
    } else if (_controller != PrimaryScrollController.of(context)) {
      _controller = PrimaryScrollController.of(context)..addListener(_listener);
    }
    _update();

    final Widget shadow = IgnorePointer(
      ignoring: widget.ignoreInteraction,
      child: (widget.scrollDirection == Axis.horizontal)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: _reachedStartSnap || !_shadowVisible ? 0 : 1,
                  duration: widget.duration,
                  curve: widget.curve,
                  child: Container(
                    width: widget.size,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        stops: const [0.0, 1.0],
                        colors: [
                          widget.color.withOpacity(0.0),
                          widget.color,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: _reachedStartSnap || !_shadowVisible ? 0 : 1,
                  duration: widget.duration,
                  curve: widget.curve,
                  child: Container(
                    height: widget.size,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 1.0],
                        colors: [
                          widget.color.withOpacity(0.0),
                          widget.color,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );

    return LayoutBuilder(
      builder: (context, constrains) {
        _listener();
        return Stack(
          children: <Widget>[
            widget.child,
            if (widget.scrollDirection == Axis.horizontal)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: widget.size,
                child: shadow,
              ),
            if (widget.scrollDirection == Axis.vertical)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: widget.size,
                child: shadow,
              ),
          ],
        );
      },
    );
  }
}
