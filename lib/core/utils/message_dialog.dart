import 'package:flutter/material.dart';

AlertDialog dialog({
  required String titleText,
  required String contentText,
  required IconData icon,
  required Color iconColor,
  required String buttonText,
  required void Function()? onPressed,
  String? secondButtonText,
  void Function()? secondOnPressed,
}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    title: Column(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 50,
        ),
        SizedBox(height: 10),
        Text(
          titleText,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
      ],
    ),
    content: Text(
      contentText,
      style: TextStyle(
        fontSize: 20,
      ),
    ),
    actions: [
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 136, 186),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (secondButtonText != null && secondOnPressed != null)
              TextButton(
                onPressed: secondOnPressed,
                child: Text(
                  secondButtonText,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 136, 186),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
