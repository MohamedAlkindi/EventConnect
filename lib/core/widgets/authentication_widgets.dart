import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget backgroundContainer({required Widget childWidget}) {
  return SafeArea(
    child: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.18 * 255).round()),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                      color: Colors.black.withAlpha((0.2 * 255).round()),
                      width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withAlpha((0.3 * 255).round()),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: childWidget,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget titleWidget({required String titleText}) {
  return Center(
    child: Text(
      titleText,
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF6C63FF),
      ),
    ),
  );
}

Widget subtitleWidget({required String subtitleText}) {
  return Center(
    child: Text(
      subtitleText,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.black.withAlpha((0.7 * 255).round()),
      ),
    ),
  );
}

Widget authButton({
  required void Function()? onTap,
  required String buttonText,
}) {
  return Container(
    width: double.infinity,
    height: 56,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6C63FF).withAlpha((0.3 * 255).round()),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget moreInfo(
    {required String text,
    required void Function()? onPressed,
    required textButtonText}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      TextButton(
        onPressed: onPressed,
        child: Text(
          textButtonText,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6C63FF),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ],
  );
}
