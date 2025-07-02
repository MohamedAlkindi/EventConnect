import 'dart:io';
import 'dart:ui';

import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/complete_profile/presentation/cubit/complete_profile_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompleteProfileCubit(),
      child: const CompleteProfileScreenView(),
    );
  }
}

class CompleteProfileScreenView extends StatelessWidget {
  const CompleteProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CompleteProfileCubit>();
    return Scaffold(
      // Receive the route name as an argument
      body: BlocListener<CompleteProfileCubit, CompleteProfileState>(
        listener: (context, state) {
          if (state is CompleteProfileLoading) {
            showLoadingDialog(context);
          } else if (state is CompleteProfileSuccessul) {
            hideLoadingDialog(context);
            showMessageDialog(
              context: context,
              titleText: 'Success! 🥳',
              contentText: "You have successfully completed your profile!",
              icon: Icons.check_circle_outline_rounded,
              iconColor: Colors.green,
              buttonText: 'Proceed',
              onPressed: () {
                cubit.isEmailConfirmed();
              },
            );
          } else if (state is EmailConfirmed) {
            state.isConfirmed
                ? cubit.showUserHomescreen()
                : Navigator.pushReplacementNamed(
                    context,
                    emailConfirmationnRoute,
                  );
          } else if (state is UserHomescreenState) {
            Navigator.pushReplacementNamed(
              context,
              state.userHomeScreenPageRoute,
            );
          } else if (state is CompleteProfileError) {
            hideLoadingDialog(context);
            showErrorDialog(
              context: context,
              message: state.message,
            );
          }
        },
        child: Stack(
          children: [
            // Modern background with gradient and subtle overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFe0e7ff),
                    Color(0xFFfceabb),
                    Color(0xFFf8b6b8)
                  ],
                ),
              ),
            ),
            // Main frosted glass content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 32.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.18 * 255).round()),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                              color:
                                  Colors.black.withAlpha((0.2 * 255).round()),
                              width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withAlpha((0.3 * 255).round()),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Text(
                                "Complete Your Profile",
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF6C63FF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: Text(
                                "Add your profile picture and location to get started",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black
                                      .withAlpha((0.7 * 255).round()),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 48),
                            Center(
                              child: Stack(
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
                                    child: BlocBuilder<CompleteProfileCubit,
                                        CompleteProfileState>(
                                      builder: (context, state) {
                                        final cubit = context
                                            .read<CompleteProfileCubit>();
                                        return CircleAvatar(
                                            radius: 80,
                                            backgroundColor: Colors.white,
                                            backgroundImage: cubit.imagePath
                                                    .startsWith("assets/")
                                                ? AssetImage(cubit.imagePath)
                                                    as ImageProvider
                                                : FileImage(
                                                    File(cubit.imagePath),
                                                  ) as ImageProvider);
                                      },
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
                                        onPressed: () => context
                                            .read<CompleteProfileCubit>()
                                            .pickImage(),
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48),
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withAlpha((0.1 * 255).round()),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Select Your City",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF6C63FF),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  BlocBuilder<CompleteProfileCubit,
                                      CompleteProfileState>(
                                    builder: (context, state) {
                                      final cubit =
                                          context.read<CompleteProfileCubit>();
                                      return DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: "City",
                                          labelStyle: GoogleFonts.poppins(
                                            color: Colors.grey,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF6C63FF),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Colors.grey.withAlpha(
                                                  (0.5 * 255).round()),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF6C63FF),
                                            ),
                                          ),
                                        ),
                                        value: cubit.selectedCity,
                                        items: cubit.yemeniCities.map((city) {
                                          return DropdownMenuItem<String>(
                                            value: city,
                                            child: Text(
                                              city,
                                              style: GoogleFonts.poppins(),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            cubit.selectCity(value);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 40),
                                  Text(
                                    "You are:",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black
                                          .withAlpha((0.8 * 255).round()),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  BlocBuilder<CompleteProfileCubit,
                                      CompleteProfileState>(
                                    builder: (context, state) {
                                      return Column(
                                        children: [
                                          RadioListTile<String>(
                                            selected: true,
                                            value: "Attendee",
                                            groupValue: cubit.selectedRole,
                                            onChanged: (value) {
                                              if (value != null) {
                                                cubit.selectRole(value);
                                              }
                                            },
                                            title: Text(
                                              "An attendee",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.black.withAlpha(
                                                    (0.8 * 255).round()),
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                            activeColor:
                                                const Color(0xFF6C63FF),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          const SizedBox(width: 8),
                                          RadioListTile<String>(
                                            value: "Manager",
                                            groupValue: cubit.selectedRole,
                                            onChanged: (value) {
                                              if (value != null) {
                                                cubit.selectRole(value);
                                              }
                                            },
                                            title: Text(
                                              "A manager",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.black.withAlpha(
                                                    (0.8 * 255).round()),
                                              ),
                                            ),
                                            activeColor:
                                                const Color(0xFF6C63FF),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 40),
                                  Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF6C63FF),
                                          Color(0xFFFF6584)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF6C63FF)
                                              .withAlpha((0.3 * 255).round()),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => context
                                            .read<CompleteProfileCubit>()
                                            .completeProfile(),
                                        borderRadius: BorderRadius.circular(16),
                                        child: Center(
                                          child: Text(
                                            "Finalize Profile",
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
