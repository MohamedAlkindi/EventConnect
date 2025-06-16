import 'package:flutter/material.dart';

Widget customTextField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required IconData icon,
  bool isObsecure = false,
  void Function()? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Stack(
      children: [
        // Gradient background
        Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                spreadRadius: 5,
                offset: const Offset(4, 4),
              ),
            ],
          ),
        ),
        // TextField with transparent background
        TextField(
          controller: controller,
          decoration: InputDecoration(
            // filled: true,
            // fillColor: Colors.white.withOpacity(0.85),
            label: Text(
              labelText,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            hintText: hintText,
            // prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2.0,
                color: const Color(0xFF6C63FF),
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            suffixIcon: onTap != null
                ? IconButton(
                    icon: Icon(icon, color: const Color(0xFF6C63FF)),
                    onPressed: onTap,
                  )
                : null,
          ),
          obscureText: isObsecure,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
