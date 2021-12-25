import 'dart:math' as math show sin, pi;
import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({
    Key? key,
    this.color = Colors.white,
    this.size = 28.0,
    this.itemBuilder,
    this.itemCount = 3,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  }) : super(key: key);

  final Color? color;
  final int itemCount;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<double> _bars = _centerAnimationDelay(widget.itemCount);
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 1.25, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_bars.length, (i) {
            return ScaleYWidget(
              scaleY: DelayTween(begin: .4, end: 1.0, delay: _bars[i]).animate(_controller),
              child: SizedBox.fromSize(size: Size(8.0, widget.size), child: _itemBuilder(i)),
            );
          }),
        ),
      ),
    );
  }

  List<double> _centerAnimationDelay(int count) {
    return <double>[
      ...List<double>.generate(count ~/ 2, (index) => -1.0 + (index * 0.2) + 0.2).reversed,
      if (count.isOdd) -1.0,
      ...List<double>.generate(count ~/ 2, (index) => -1.0 + (index * 0.2) + 0.2),
    ];
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(72.0),
          ),
        );
}

class ScaleYWidget extends AnimatedWidget {
  const ScaleYWidget({
    Key? key,
    required Animation<double> scaleY,
    required this.child,
    this.alignment = Alignment.center,
  }) : super(key: key, listenable: scaleY);

  final Widget child;
  final Alignment alignment;

  Animation<double> get scale => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Transform(transform: Matrix4.identity()..scale(1.0, scale.value, 1.0), alignment: alignment, child: child);
  }
}

class DelayTween extends Tween<double> {
  DelayTween({double? begin, double? end, required this.delay}) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) => super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
