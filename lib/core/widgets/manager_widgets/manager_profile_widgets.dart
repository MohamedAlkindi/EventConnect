import 'dart:ui';

import 'package:event_connect/features/manager/manager_profile/presentation/cubit/manager_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget profileFrostedContainerWidget({required Widget childWidget}) {
  return Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 32.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.18 * 255).round()),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                    color: Colors.black.withAlpha((0.12 * 255).round()),
                    width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withAlpha((0.18 * 255).round()),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: childWidget,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget managerProfileHeader({
  required String headerText,
}) {
  return Center(
    child: Text(
      headerText,
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF6C63FF),
        shadows: [
          Shadow(
            color: Colors.black.withAlpha((0.08 * 255).round()),
            blurRadius: 6,
          ),
        ],
      ),
    ),
  );
}

Widget profilePicContainer({required Widget childWidget}) {
  return Center(
    child: Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.12 * 255).round()),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: childWidget,
    ),
  );
}

Widget managerProfilePicStack({
  required ManagerProfileCubit cubit,
  required String? cachedPicturePath,
  required String profilePicUrl,
}) {
  return Stack(
    children: [
      CircleAvatar(
        radius: 80,
        backgroundImage: cubit.returnManagerPic(
          cachedPicturePath: cachedPicturePath,
          profilePicUrl: profilePicUrl,
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
          ),
          child: const Icon(
            Icons.celebration,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    ],
  );
}
