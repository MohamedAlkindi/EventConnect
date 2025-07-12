import 'package:flutter/material.dart';

Widget appBackgroundColors() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFe0e7ff),
          Color(0xFFfceabb),
          Color(0xFFf8b6b8),
        ],
      ),
    ),
  );
}
