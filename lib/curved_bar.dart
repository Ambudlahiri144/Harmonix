import 'package:flutter/material.dart';
import 'dart:math';

class WavySlider extends StatelessWidget {
  final double progress;

  WavySlider({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WavySliderPainter(progress),
      size: Size(double.infinity, 60), // Height of the wavy slider
    );
  }
}

class _WavySliderPainter extends CustomPainter {
  final double progress;
  final Paint linePaint;
  final Paint knobPaint;

  _WavySliderPainter(this.progress)
      : linePaint = Paint()
    ..color = Colors.white // Highlighted color for the visible wave
    ..strokeWidth = 4
    ..style = PaintingStyle.stroke,
        knobPaint = Paint()..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    double waveHeight = 6; // Amplitude of the wave
    double waveLength = size.width / 10; // Length of each wave segment

    // Draw the visible wavy line path up to the progress
    for (double i = 0; i <= size.width * progress; i += 1) {
      double x = i;
      double y = size.height / 2 + sin(i / waveLength * 2 * pi) * waveHeight;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    // Draw the knob on the path based on the progress
    double knobX = size.width * progress;
    double knobY = size.height / 2 + sin(knobX / waveLength * 2 * pi) * waveHeight;

    // Define the vertical rounded rectangle's dimensions and corner radius
    Rect rect = Rect.fromCenter(center: Offset(knobX, knobY), width: 10, height: 20);
    RRect roundedRect = RRect.fromRectAndRadius(rect, Radius.circular(5));

    canvas.drawRRect(roundedRect, knobPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint when progress changes
  }
}
