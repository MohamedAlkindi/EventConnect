import 'dart:ui';

import 'package:event_connect/core/constants/user_cities.dart';
import 'package:event_connect/features/manager/manager_profile/presentation/cubit/manager_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  required GotManagerProfileInfo state,
  required ManagerProfileCubit cubit,
}) {
  return Stack(
    children: [
      CircleAvatar(
        radius: 80,
        backgroundImage: cubit.returnManagerPic(
          state: state,
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

Widget managerProfilePicture({
  required ImageProvider<Object>? backgroundImage,
  required void Function()? onPressed,
}) {
  return Stack(
    children: [
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
          // // when entering the app this state will be init.

          // // get the picture from the state.
          // ? NetworkImage(
          //     "${state.managerProfile.profilePicUrl}?updated=${DateTime.now().millisecondsSinceEpoch}",
          //   )
          // // if the user changed the location only.
          // // the state will be SelectedCity so all the states are false.
          // // So get the old picture that was saved first from cubit,
          // : state is SelectedImage
          //     ? FileImage(
          //         File(state.selectedImagePath),
          //       )
          //     // check if the user registered a new pic first.
          //     : cubit.newSelectedImagePath == null
          //         ? cubit.supabaseImageUrl == null
          //             ? const AssetImage(
          //                 'assets/images/generic_user.png')
          //             : NetworkImage(
          //                 "${cubit.supabaseImageUrl!}updated=${DateTime.now().millisecondsSinceEpoch}",
          //               )
          //         : FileImage(
          //             File(cubit.newSelectedImagePath!),
          //           ),
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
    ],
  );
}

Widget managerFormCard({required Widget childWidget}) {
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

Widget managerCityDropDownMenu({
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

Widget managerSaveButton({
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
