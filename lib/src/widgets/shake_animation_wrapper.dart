import 'dart:math';
import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final bool shake;
  final VoidCallback? onAnimationComplete;

  const ShakeWidget({
    super.key,
    required this.child,
    this.shake = false,
    this.onAnimationComplete,
  });

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animation =
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller.reset();
            widget.onAnimationComplete?.call();
          }
        });

    if (widget.shake) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final sineValue = sin(3 * pi * _animation.value);
        return Transform.translate(
          offset: Offset(sineValue * 10, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
