import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedDonut extends StatefulWidget {
  final String centerText;
  final String centerSubText;
  final double size;

  const AnimatedDonut({
    super.key,
    this.centerText = 'λ',
    this.centerSubText = 'growth',
    this.size = 110,
  });

  @override
  State<AnimatedDonut> createState() => _AnimatedDonutState();
}

class _AnimatedDonutState extends State<AnimatedDonut>
    with TickerProviderStateMixin {
  late AnimationController _drawController;
  late AnimationController _rotateController;
  late Animation<double> _drawAnimation;

  @override
  void initState() {
    super.initState();

    _drawController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _drawAnimation = CurvedAnimation(
      parent: _drawController,
      curve: Curves.easeOutCubic,
    );

    _drawController.forward();
  }

  @override
  void dispose() {
    _drawController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_drawAnimation, _rotateController]),
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: _rotateController.value * 2 * pi,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: DonutPainter(progress: _drawAnimation.value),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.centerText,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.centerSubText,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class DonutPainter extends CustomPainter {
  final double progress;
  const DonutPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 11.0;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = Colors.white.withValues(alpha: 0.07),
    );

    final segments = [
      (0.35, const Color(0xFF00BCD4)),
      (0.25, const Color(0xFF1565C0)),
      (0.20, const Color(0xFF2E7D32)),
      (0.12, const Color(0xFF6A1B9A)),
      (0.08, const Color(0xFFE65100)),
    ];

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    const gapAngle = 0.08;
    const totalAngle = 2 * pi;
    double startAngle = -pi / 2;
    double totalDrawn = 0;
    final maxDraw = totalAngle * progress;

    for (final seg in segments) {
      if (totalDrawn >= maxDraw) break;
      final fullSweep = seg.$1 * totalAngle;
      final visibleSweep = fullSweep - gapAngle;
      final clampedSweep =
          visibleSweep.clamp(0.0, maxDraw - totalDrawn);

      if (clampedSweep > 0) {
        paint.color = seg.$2;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          clampedSweep,
          false,
          paint,
        );
      }

      startAngle += fullSweep;
      totalDrawn += fullSweep;
    }

    canvas.drawCircle(
      center,
      radius + strokeWidth / 2 + 5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.white.withValues(alpha: 0.1),
    );
  }

  @override
  bool shouldRepaint(DonutPainter old) => old.progress != progress;
}