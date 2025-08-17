// lib/widgets/heart_animation.dart
import 'dart:math';
import 'package:flutter/material.dart';

/// An overlay of floating hearts that rise, drift, and fade out.
/// Place inside a Stack (e.g., Positioned.fill) and show it after candles are blown.
///
/// Example:
/// if (_candlesBlown) const HeartAnimation(count: 28, color: Colors.pink);
class HeartAnimation extends StatefulWidget {
  const HeartAnimation({
    super.key,
    this.count = 24,
    this.color = Colors.pink,
    this.minSize = 10,
    this.maxSize = 26,
    this.duration = const Duration(seconds: 8),
    this.randomSeed,
  });

  /// Number of floating hearts.
  final int count;

  /// Base color for the hearts.
  final Color color;

  /// Minimum heart size (logical pixels).
  final double minSize;

  /// Maximum heart size (logical pixels).
  final double maxSize;

  /// Total time for a heart to travel bottom → top before looping.
  final Duration duration;

  /// Optional seed for deterministic randomness (useful for tests).
  final int? randomSeed;

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_HeartParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: widget.duration)..repeat();

    final rnd = Random(widget.randomSeed);
    _particles = List.generate(widget.count, (i) {
      final phase = rnd.nextDouble(); // 0..1 starting offset
      final x = rnd.nextDouble(); // normalized horizontal position 0..1
      final speed = lerpDouble(0.75, 1.25, rnd.nextDouble())!; // relative speed
      final size = lerpDouble(widget.minSize, widget.maxSize, rnd.nextDouble())!;
      final sway = lerpDouble(10, 40, rnd.nextDouble())!; // horizontal sway in px
      return _HeartParticle(
        startXNorm: x,
        phase: phase,
        speed: speed,
        size: size,
        sway: sway,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return CustomPaint(
              painter: _HeartsPainter(
                progress: _controller.value,
                particles: _particles,
                color: widget.color,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeartParticle {
  _HeartParticle({
    required this.startXNorm,
    required this.phase,
    required this.speed,
    required this.size,
    required this.sway,
  });

  /// Starting X as a fraction of width (0..1).
  final double startXNorm;

  /// Start offset along the animation loop (0..1).
  final double phase;

  /// Speed multiplier (around 1.0).
  final double speed;

  /// Base size (px).
  final double size;

  /// Horizontal sway amplitude (px).
  final double sway;
}

class _HeartsPainter extends CustomPainter {
  _HeartsPainter({
    required this.progress,
    required this.particles,
    required this.color,
  });

  final double progress; // 0..1 repeating
  final List<_HeartParticle> particles;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw from back to front based on size (smaller first for a nicer depth feel)
    final sorted = [...particles]..sort((a, b) => a.size.compareTo(b.size));

    for (final p in sorted) {
      // t goes 0..1 over the lifetime of the particle, then loops
      final t = ((progress * p.speed) + p.phase) % 1.0;

      // Vertical position: start near bottom and rise up
      final y = size.height - (size.height + p.size * 2) * t;

      // Horizontal drift with sine sway
      final drift = sin((t * 2 * pi) + (p.phase * 2 * pi)) * p.sway;
      final x = (p.startXNorm * size.width) + drift;

      // Fade in/out for smoothness: stronger near middle
      final fade = (1.0 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);

      // Slight scale pulsation while floating
      final pulse = 0.9 + 0.2 * sin((t * 2 * pi) + p.phase);
      final heartSize = p.size * pulse;

      final paint = Paint()
        ..color = color.withValues(alpha: 0.25 + 0.65 * fade)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      _drawHeart(canvas, Offset(x, y), heartSize, paint);

      // Optional subtle outline for crispness
      final stroke = Paint()
        ..color = color.withValues(alpha: 0.35 * fade)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      _drawHeart(canvas, Offset(x, y), heartSize, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _HeartsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.particles != particles;
  }
}

/// Draws a stylized heart centered near [center], sized by [size].
/// Built from symmetric cubic Béziers (no external assets).
void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
  // The path is built around (center.dx, center.dy)
  // with Y growing downward; we shape a classic heart.
  final s = size;
  final Path path = Path();

  // Start slightly below the top dip
  path.moveTo(center.dx, center.dy + s * 0.35);

  // Left lobe
  path.cubicTo(
    center.dx, center.dy + s * 0.10, // control 1
    center.dx - s * 0.50, center.dy + s * 0.10, // control 2
    center.dx - s * 0.50, center.dy + s * 0.35, // end
  );
  path.cubicTo(
    center.dx - s * 0.50, center.dy + s * 0.70, // control 1
    center.dx - s * 0.10, center.dy + s * 0.85, // control 2
    center.dx, center.dy + s, // tip (bottom)
  );

  // Right lobe (mirror)
  path.cubicTo(
    center.dx + s * 0.10, center.dy + s * 0.85, // control 1
    center.dx + s * 0.50, center.dy + s * 0.70, // control 2
    center.dx + s * 0.50, center.dy + s * 0.35, // end
  );
  path.cubicTo(
    center.dx + s * 0.50, center.dy + s * 0.10, // control 1
    center.dx, center.dy + s * 0.10, // control 2
    center.dx, center.dy + s * 0.35, // close near dip
  );

  path.close();
  canvas.drawPath(path, paint);
}

/// Simple linear interpolation helper without importing dart:ui lerpDouble.
double? lerpDouble(num? a, num? b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}
