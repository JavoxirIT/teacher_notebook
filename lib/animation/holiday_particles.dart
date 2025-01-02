import 'package:TeamLead/theme/color.dart';
import 'package:flutter/material.dart';
import 'falling_particles.dart';

class HolidayParticles {
  static Widget getHolidayParticles(BuildContext context, Widget child) {
    final now = DateTime.now();

    // Новый год (Декабрь и Январь)
    if (now.month == 12 || now.month == 1) {
      return FallingParticles(
        numberOfParticles: 50,
        colors: const [
          Color.fromARGB(255, 3, 51, 240),
          Color.fromARGB(255, 180, 234, 255),
          colorWhite
        ],
        shape: ParticleShape.star,
        minSize: 5,
        maxSize: 15,
        duration: const Duration(seconds: 10),
        child: child,
      );
    }

    // День святого Валентина (14 февраля)
    if (now.month == 2 && now.day == 14) {
      return FallingParticles(
        numberOfParticles: 30,
        colors: const [
          Colors.red,
          Colors.pink,
          Colors.redAccent,
        ],
        shape: ParticleShape.heart,
        minSize: 10,
        maxSize: 20,
        duration: const Duration(seconds: 8),
        child: child,
      );
    }

    // Наврўз (21 марта)
    if (now.month == 3 && now.day == 21) {
      return FallingParticles(
        numberOfParticles: 40,
        colors: const [
          Color(0xFF00FF00), // Зеленый
          Color(0xFFFFFF00), // Желтый
          Color(0xFFFF69B4), // Розовый
        ],
        shape: ParticleShape.circle,
        minSize: 8,
        maxSize: 15,
        duration: const Duration(seconds: 10),
        child: child,
      );
    }

    // Осень (Сентябрь-Ноябрь)
    if (now.month >= 9 && now.month <= 11) {
      return FallingParticles(
        numberOfParticles: 40,
        colors: const [
          Colors.orange,
          Colors.red,
          Colors.brown,
          Colors.yellow,
        ],
        shape: ParticleShape
            .square, // Можно заменить на ParticleShape.image с картинкой листа
        minSize: 15,
        maxSize: 25,
        duration: const Duration(seconds: 12),
        child: child,
      );
    }

    // По умолчанию возвращаем виджет без анимации
    return child;
  }
}
