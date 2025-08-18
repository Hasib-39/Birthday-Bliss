import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors; // optional custom colors
  final Alignment begin;
  final Alignment end;

  const GradientBackground({
    super.key,
    required this.child,
    this.gradientColors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ??
              const [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}
