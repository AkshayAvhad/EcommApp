import 'package:flutter/material.dart';
import 'dart:math';

class CustomCircularProgress extends StatefulWidget {
  final double progress;
  final double size;
  final Color progressColor;
  final Color backgroundColor;

  const CustomCircularProgress({
    super.key,
    required this.progress,
    this.size = 200.0,
    this.progressColor = Colors.blueAccent,
    this.backgroundColor = const Color(0xFFEEEEEE), //Light gray track
  });

  @override
  State<CustomCircularProgress> createState() => _CustomCircularProgressState();
}

class _CustomCircularProgressState extends State<CustomCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CustomCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0.0);
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
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _CircularProgressPainter(
            progressValue: _animation.value,
            progressColor: widget.progressColor,
            backgroundColor: widget.backgroundColor,
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progressValue;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progressValue,
    required this.progressColor,
    required this.backgroundColor,
    this.strokeWidth = 15.0, // Standard width for the ring
  });

  // THE MAIN PAINTING STAGE
  @override
  void paint(Canvas canvas, Size size) {
    // A. Define Geometry based on the parent's layout constraints
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - (strokeWidth / 2);

    // B. Create the Paintbrush for the Background Track (The Gray Ring)
    final trackPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // C. Draw the background track (Full 360 degree circle)
    canvas.drawCircle(center, radius, trackPaint);

    // D. Create the Paintbrush for the Progress Arc (The Blue Sweep)
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap
          .round; // Senior architecture detail: Rounded edges like image_0.png

    // E. Calculate the angles (0 radians is 3 o'clock)
    // We want to start at 12 o'clock, so rotate -90 degrees (pi/2 radians).
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progressValue;

    // F. The Draw Command: Execute the arc sweep
    // The 'useCenter: false' is key: we want an open ring, not a 'pie slice'.
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false, // Do not connect back to the origin
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progressValue != progressValue ||
        oldDelegate.progressColor != progressColor;
  }
}
