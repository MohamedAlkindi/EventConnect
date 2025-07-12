import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

Widget confettiEffectWidget(ConfettiController confettiController) {
  return Align(
    alignment: Alignment.topCenter,
    child: ConfettiWidget(
      confettiController: confettiController,
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: false,
      colors: const [
        Color(0xFF6C63FF),
        Color(0xFFFF6584),
        Color(0xFFFFB74D),
        Colors.white,
      ],
      emissionFrequency: 0.05,
      numberOfParticles: 15,
      maxBlastForce: 15,
      minBlastForce: 5,
    ),
  );
}
