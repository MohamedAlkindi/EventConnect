import 'dart:ui';

import 'package:event_connect/core/constants/user_cities.dart';
import 'package:flutter/material.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

Widget userProfileBackground({required Widget childWidget}) {
  return Center(
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: childWidget,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget userProfilePicture({
  required ImageProvider<Object>? backgroundImage,
  required void Function()? onPressed,
}) {
  return Stack(children: [
    Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 80,
        backgroundColor: Colors.grey[200],
        backgroundImage: backgroundImage,
      ),
    ),
    Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF6C63FF),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    ),
  ]);
}

Widget formCard({required Widget childWidget}) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha((0.1 * 255).round()),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: childWidget,
  );
}

Widget cityDropDownMenu({
  required BuildContext context,
  required String? formFieldValue,
  required void Function(String?)? onChanged,
}) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: AppLocalizations.of(context)!.city,
      labelStyle: GoogleFonts.poppins(
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF6C63FF),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.withAlpha((0.5 * 255).round()),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF6C63FF),
        ),
      ),
    ),
    // Same as the picture!
    value: formFieldValue,
    items: cities.map((String city) {
      return DropdownMenuItem<String>(
        value: city,
        child: Text(
          city,
          style: GoogleFonts.poppins(),
        ),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

Widget saveButton({
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
          AppLocalizations.of(context)!.saveChanges,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )),
      ),
    ),
  );
}

Widget headerText({
  required BuildContext context,
  // required bool isEditProfilePage,
}) {
  return Expanded(
    child: Center(
      child: Text(
        AppLocalizations.of(context)!.editProfile,
        style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width < 400
              ? 22.0
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

Widget radioTileWidget({
  required bool isSelected,
  required String valueText,
  required String groupValue,
  required void Function(String?)? onChanged,
  required String buttonTitle,
}) {
  return RadioListTile<String>(
    selected: isSelected,
    value: valueText,
    groupValue: groupValue,
    onChanged: onChanged,
    title: Text(
      buttonTitle,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.black.withAlpha((0.8 * 255).round()),
      ),
      overflow: TextOverflow.clip,
    ),
    activeColor: const Color(0xFF6C63FF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: EdgeInsets.zero,
  );
}
