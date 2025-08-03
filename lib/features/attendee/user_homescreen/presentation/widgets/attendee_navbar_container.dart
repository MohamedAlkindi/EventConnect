import 'package:flutter/material.dart';

Widget attendeeNavBarContainer({required Widget childWidget}) {
  return Container(
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha((0.1 * 255).round()),
          blurRadius: 20,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: childWidget,
  );
}
