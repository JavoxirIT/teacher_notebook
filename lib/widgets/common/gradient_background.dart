import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GradientBackground extends StatelessWidget {
  final Widget? child;

  const GradientBackground({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: _GradientPainter(),
          size: Size.infinite,
        ),
        if (child != null) child!,
      ],
    );
  }
}

class _GradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    // Создаем градиентные цвета
    final colors = [
      const Color(0xFF2E3192).withOpacity(0.8),  // Синий
      const Color(0xFFE94E68).withOpacity(0.7),   // Красный
      const Color(0xFF662D8C).withOpacity(0.6),   // Фиолетовый
    ];

    // Создаем градиентные точки
    final stops = [0.0, 0.5, 1.0];

    // Верхняя волна
    final topPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.5,
        size.width * 0.3,
        size.height * 0.7,
      )
      ..lineTo(0, size.height * 0.3)
      ..close();

    // Нижняя волна
    final bottomPath = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.8,
        size.width * 0.6,
        size.height * 0.6,
      )
      ..lineTo(size.width, size.height * 0.8)
      ..close();

    // Рисуем градиенты
    final topGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
      stops: stops,
    );

    final bottomGradient = LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: colors.reversed.toList(),
      stops: stops,
    );

    // Применяем размытие
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    // Рисуем верхнюю волну
    canvas.drawPath(
      topPath,
      Paint()
        ..shader = topGradient.createShader(rect)
        ..maskFilter = paint.maskFilter,
    );

    // Рисуем нижнюю волну
    canvas.drawPath(
      bottomPath,
      Paint()
        ..shader = bottomGradient.createShader(rect)
        ..maskFilter = paint.maskFilter,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
