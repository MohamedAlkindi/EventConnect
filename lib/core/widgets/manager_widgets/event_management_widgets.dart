// For both add and edit events, as they use the same Widgets!
import 'dart:ui';

import 'package:event_connect/core/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget managementBackgroundWidget({required Widget childWidget}) {
  return Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: childWidget,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget managementMainBarItems(
    {required BuildContext context, required String barText}) {
  return Row(
    children: [
      IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_rounded),
        color: Colors.black,
        // iconSize: 28,
        tooltip: 'Back',
      ),
      Text(
        barText,
        style: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6C63FF),
        ),
      ),
    ],
  );
}

Widget imageContainer({required Widget childWidget}) {
  return Container(
    width: 500,
    height: 300,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: Colors.white,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha((0.08 * 255).round()),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: childWidget,
  );
}

Widget managementCameraButton({
  required void Function()? onPressed,
}) {
  return Positioned(
    bottom: 3,
    right: 3,
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
          Icons.image,
          color: Colors.white,
          size: 24,
        ),
      ),
    ),
  );
}

Widget managementFormCardContainer({required Widget childWidget}) {
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

Widget managementFormFields({
  required TextEditingController controller,
  required int? maxLength,
  required String labelText,
  required String hintText,
  bool isDateTimeField = false,
  required BuildContext context,
}) {
  return TextField(
    controller: controller,
    maxLength: maxLength,
    onTap: isDateTimeField
        ? () async {
            await returnDateAndTime(context: context);
          }
        : null,
    readOnly: isDateTimeField,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: GoogleFonts.poppins(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF6C63FF),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF6C63FF),
        ),
      ),
    ),
  );
}

Widget managementDropDownFormFields({
  required String? value,
  required String labelText,
  required List<DropdownMenuItem<String>>? itemsList,
  required void Function(String?)? onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: GoogleFonts.poppins(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF6C63FF),
        ),
      ),
    ),
    items: itemsList,
    onChanged: onChanged,
  );
}

Widget managementButtonContainer({required Widget childWidget}) {
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
    child: childWidget,
  );
}

Widget managementButton({
  required void Function()? onTap,
  required String textButton,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Center(
        child: Text(
          textButton,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
