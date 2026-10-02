import 'package:flutter/material.dart';

class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int index;
  final double offset;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.offset = 24,
  });

  @override
  Widget build(BuildContext context) {
    final delay = (index > 8 ? 8 : index) * 70;
    final total = 420 + delay;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Interval(delay / total, 1, curve: Curves.easeOutCubic),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, offset * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}