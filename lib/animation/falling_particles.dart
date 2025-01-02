import 'dart:math' as math;
import 'package:flutter/material.dart';

class ParticleModel {
  Offset position;
  double speed;
  double theta;
  double size;
  Color color;
  ImageProvider? image;
  double rotation;
  ParticleShape shape;

  ParticleModel({
    required this.position,
    required this.speed,
    required this.theta,
    required this.size,
    required this.color,
    this.image,
    required this.rotation,
    required this.shape,
  });
}

enum ParticleShape {
  circle,
  square,
  star,
  heart,
  image,
}

class FallingParticles extends StatefulWidget {
  final Widget child;
  final int numberOfParticles;
  final List<Color> colors;
  final double minSize;
  final double maxSize;
  final Duration duration;
  final ParticleShape shape;
  final ImageProvider? particleImage;

  const FallingParticles({
    super.key,
    required this.child,
    this.numberOfParticles = 30,
    this.colors = const [Colors.white],
    this.minSize = 5,
    this.maxSize = 15,
    this.duration = const Duration(seconds: 10),
    this.shape = ParticleShape.circle,
    this.particleImage,
  });

  @override
  State<FallingParticles> createState() => _FallingParticlesState();
}

class _FallingParticlesState extends State<FallingParticles>
    with SingleTickerProviderStateMixin {
  late List<ParticleModel> particles;
  late AnimationController _controller;
  final random = math.Random();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
        _updateParticles();
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      particles = List.generate(widget.numberOfParticles, (index) => _createParticle());
      _controller.repeat();
      _initialized = true;
    }
  }

  ParticleModel _createParticle({Offset? position}) {
    final size = widget.minSize +
        random.nextDouble() * (widget.maxSize - widget.minSize);
    return ParticleModel(
      position: position ??
          Offset(
              random.nextDouble() * MediaQuery.of(context).size.width, -size),
      speed: 50 + random.nextDouble() * 100,
      theta: random.nextDouble() * 0.1 - 0.05,
      size: size,
      color: widget.colors[random.nextInt(widget.colors.length)],
      image: widget.shape == ParticleShape.image ? widget.particleImage : null,
      rotation: random.nextDouble() * 2 * math.pi,
      shape: widget.shape,
    );
  }

  void _updateParticles() {
    final screenHeight = MediaQuery.of(context).size.height;
    for (int i = 0; i < particles.length; i++) {
      particles[i].position += Offset(
        math.sin(particles[i].theta) * particles[i].speed * 0.02,
        particles[i].speed * 0.02,
      );
      particles[i].rotation += 0.01;

      if (particles[i].position.dy > screenHeight) {
        particles[i] = _createParticle();
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: CustomPaint(
            size: Size.infinite,
            painter: ParticlePainter(
              particles: particles,
            ),
          ),
        ),
      ],
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<ParticleModel> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      switch (particle.shape) {
        case ParticleShape.circle:
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
          break;
        case ParticleShape.square:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size,
            ),
            paint,
          );
          break;
        case ParticleShape.star:
          _drawStar(canvas, particle.size / 2, paint);
          break;
        case ParticleShape.heart:
          _drawHeart(canvas, particle.size / 2, paint);
          break;
        case ParticleShape.image:
          if (particle.image != null) {
            // Здесь нужна дополнительная логика для отрисовки изображения
          }
          break;
      }
      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, double radius, Paint paint) {
    final path = Path();
    final double centerX = 0;
    final double centerY = 0;

    for (int i = 0; i < 5; i++) {
      double angle = -math.pi / 2 + i * 4 * math.pi / 5;
      if (i == 0) {
        path.moveTo(
          centerX + radius * math.cos(angle),
          centerY + radius * math.sin(angle),
        );
      } else {
        path.lineTo(
          centerX + radius * math.cos(angle),
          centerY + radius * math.sin(angle),
        );
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, double radius, Paint paint) {
    final path = Path();
    path.moveTo(0, radius);
    path.cubicTo(
      -radius * 2,
      -radius * 0.5,
      -radius * 0.5,
      -radius * 2,
      0,
      -radius,
    );
    path.cubicTo(
      radius * 0.5,
      -radius * 2,
      radius * 2,
      -radius * 0.5,
      0,
      radius,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
