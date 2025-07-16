import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget actionButton(
    {required bool isEditProfileButton,
    required void Function()? onTap,
    required IconData icon,
    required Color iconColor,
    required String text,
    required Color textColor}) {
  return Container(
    width: double.infinity,
    height: 56,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isEditProfileButton
            ? [Color(0xFF6C63FF), Color(0xFFFF6584)]
            : [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 245, 243, 243)
              ],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6C63FF).withAlpha((0.18 * 255).round()),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
