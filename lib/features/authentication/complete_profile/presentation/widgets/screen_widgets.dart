import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget finalizeButton({
  required BuildContext context,
  required void Function()? onTap,
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
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.finalizeProfile,
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

Widget completeProfileHeader({
  required BuildContext context,
}) {
  return Expanded(
    child: Center(
      child: Text(
        AppLocalizations.of(context)!.completeProfile,
        style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width < 400
              ? 20.0
              : MediaQuery.of(context).size.width < 600
                  ? 24.0
                  : 28.0, // Max font size
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6C63FF),
        ),
      ),
    ),
  );
}
